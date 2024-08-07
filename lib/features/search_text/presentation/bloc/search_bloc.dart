import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini/core/api/api_key.dart' as key;
import 'package:gemini/core/network/networkinfo.dart';
import 'package:gemini/core/usecase/usecase.dart';
import 'package:gemini/features/data_generated/domain/entities/data.dart';
import 'package:gemini/features/search_text/domain/usecase/add_multi_images.dart';
import 'package:gemini/features/search_text/domain/usecase/chat.dart';
import 'package:gemini/features/search_text/domain/usecase/delete_all_data.dart';
import 'package:gemini/features/search_text/domain/usecase/generate_content.dart';
import 'package:gemini/features/search_text/domain/usecase/read_sql_data.dart';
import 'package:gemini/features/search_text/domain/usecase/search_text.dart';
import 'package:gemini/features/search_text/domain/usecase/search_text_image.dart';
import 'package:gemini/features/sqlite_database/entities/text.dart';
import 'package:gemini/main.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import "package:google_generative_ai/google_generative_ai.dart" as ai;
part "search_event.dart";
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchText searchText;
  final SearchTextAndImage searchTextAndImage;
  final AddMultipleImages addMultipleImage;
  final GenerateContent generateContent;
  final Chat chat;
  final ReadData readSQLData;
  final DeleteAllData deleteAllData;
  final NetworkInfo networkInfo;

  StreamController<SpeechRecognitionResult> words =
      StreamController<SpeechRecognitionResult>();
  List<String> all = [];
  String question = "";
  String? token;

  StreamController<ai.GenerateContentResponse> streamContent =
      StreamController<ai.GenerateContentResponse>.broadcast();

  SearchBloc(
      {required this.searchText,
      required this.networkInfo,
      required this.searchTextAndImage,
      required this.addMultipleImage,
      required this.generateContent,
      required this.chat,
      required this.readSQLData,
      required this.deleteAllData})
      : super(SearchInitState()) {
    on<SearchTextEvent>((event, emit) async {
      emit(SearchTextLoading());

      final response = await searchText.call(event.params);

      emit(
        response.fold(
          (error) => SearchTextError(errorMessage: error),
          (response) => SearchTextLoaded(
            data: response.toString(),
          ),
        ),
      );
    });

    on<SearchTextAndImageEvent>((event, emit) async {
      emit(SearchTextAndImageLoading());

      final response = await searchTextAndImage.call(event.params);

      emit(response.fold(
          (error) => SearchTextAndImageError(errorMessage: error),
          (response) => SearchTextAndImageLoaded(data: response.toString())));
    });

    on<AddMultipleImageEvent>((event, emit) async {
      emit(AddMultipleImageLoading());

      final response = await addMultipleImage.call(event.noParams);

      emit(response.fold(
        (error) => AddMultipleImageError(errorMessage: error),
        (response) => AddMultipleImageLoaded(
          data: response,
        ),
      ));
    });
    on<ReadAllEvent>((event, emit) {
      emit(const ReadAll());
    });

    on<ListenSpeechTextEvent>((event, emit) async {
      // emit(OnSpeechResultLoading());

      listenToSpeechText();

      await emit.forEach(words.stream, onData: (data) {
        emit(OnSpeechResultLoading());

        return OnSpeechResultLoaded(
          result: data.recognizedWords,
        );
      });
    });

    on<GenerateContentDoneEvent>((event, emit) {
      emit(GenerateContentAllDone(data: all.join("")));
      all.clear();
    });

    on<GenerateContentEvent>((event, emit) async {
      emit(GenerateStreamLoading());
      await generateStreams(event.params);

      await emit.onEach(streamContent.stream, onData: (data) {
        emit(GenerateContentLoading());
        all.add(data.text!);
        emit(GenerateContentLoaded(data: data.text));
      }, onError: (error, _) {
        emit(
          GenerateContentError(
            errorMessage: error.toString(),
          ),
        );
      });
    });

    on<GenerateStreamStopEvent>((event, emit) async {
      final content = [ai.Content.text(event.params["text"])];
      if (await networkInfo.isConnected) {
        try {
          final response = model
              .generateContentStream(content, safetySettings: [
            ai.SafetySetting(
                ai.HarmCategory.dangerousContent, ai.HarmBlockThreshold.none)
          ]);
          await for (final r in response) {
            emit(GenerateContentLoading());
            all.add(r.text!);
            emit(
              GenerateContentLoaded(
                data: r.text,
              ),
            );
          }
          emit(GenerateContentAllDone(data: all.join()));
          all.clear();
        } catch (e) {
          emit(GenerateContentError(errorMessage: e.toString()));
        }
      } else {
        emit(
          GenerateContentError(
            errorMessage: networkInfo.noNetworkMessage,
          ),
        );
      }
    });

    on<ChatEvent>((event, emit) async {
      emit(ChatLoading());
      final response = await chat.call(event.params);

      emit(
        response.fold(
          (error) => ChatError(errorMessage: error),
          (response) => ChatLoaded(data: response.toString()),
        ),
      );
    });
    on<ReadSQLDataEvent>((event, emit) async {
      emit(ReadDataLoading());
      final response = await readSQLData.call(NoParams());
      emit(
        response.fold(
          (error) => ReadDataError(errorMessage: error),
          (response) => ReadDataLoaded(
            data: response,
          ),
        ),
      );
    });

    on<ReadDataDetailsEvent>((event, emit) {
      emit(ReadDataDetailsLoading());
      final response = readDataDetails(event.params);
      emit(
        ReadDataDetailsLoaded(
          response,
        ),
      );
    });

    on<StopSpeechTextEvent>((event, emit) async {
      await stopSpeechText();
      emit(
        const StopSpeechTextLoaded(),
      );
    });

    on<IsSpeechTextEnabledEvent>((event, emit) async {
      try {
        await _speechToText.initialize();

        emit(IsSpeechTextEnabledLoaded());
      } catch (e) {
        emit(const IsSpeechTextEnabledError(
          errorMessage: "Your phone is not supported",
        ));
        throw PlatformException(
            code: "404", message: "Your phone is not supported");
      }
    });

    on<DeleteDataEvent>((event, emit) async {
      emit(DeleteDataLoading());
      final response = await deleteAllData.call(event.params);
      emit(response.fold((error) => DeleteDataError(errorMessage: error),
          (response) => const DeleteDataLoaded()));
    });
  }
  final model =
      ai.GenerativeModel(model: "gemini-1.5-flash-latest", apiKey: key.apiKey);

  Future<dynamic> generateContents(Map<String, dynamic> params) async {
    final content = [ai.Content.text(params["text"])];

    final response = model.generateContentStream(content, safetySettings: [
      ai.SafetySetting(
          ai.HarmCategory.dangerousContent, ai.HarmBlockThreshold.none)
    ]);
    await for (final r in response) {
      return r.text;
    }
  }

  String replace(String data) {
    return data.replaceAll(RegExp(r'[^\w\s]+'), '');
  }

  Future<dynamic> generateStreams(Map<String, dynamic> params) async {
    final content = [ai.Content.text(params["text"])];

    final response = model.generateContentStream(content);

    return response.asBroadcastStream().listen((onData) {
      // onData.text);
      streamContent.add(onData);
    }, onDone: () {
      add(GenerateContentDoneEvent());
    });
  }

  /// Each time to start a speech recognition session
  Future<dynamic> listenToSpeechText() async {
    return await _speechToText.listen(
      onResult: (result) => words.add(result),
      listenOptions: SpeechListenOptions(listenMode: ListenMode.search),
    );
  }

  final _speechToText = SpeechToText();

  /// This has to happen only once per app
  Future<bool> isSpeechTextEnabled() async {
    try {
      final speechEnabled = await _speechToText.initialize();
      return speechEnabled;
    } catch (e) {
      throw PlatformException(
          code: "404", message: "Your phone is not supported");
    }
  }

  Future<void> stopSpeechText() async {
    return await _speechToText.stop();
  }

  Future addData(Map<String, dynamic> params) async {
    final personDao = database?.textDao;
    final textEntity = TextEntity(
        textId: params["textId"],
        title: params["title"],
        data: params["data"],
        dataImage: params["dataImage"],
        hasImage: params["hasImage"] ?? false);

    return await personDao?.insertData(textEntity);
    // final result = await personDao.getTextData();
  }

  Future deleteData(Map<String, dynamic> params) async {
    final textDao = database?.textDao;
    final textEntity = TextEntity(
        textId: params["textId"],
        title: params["title"],
        data: params["data"],
        dataImage: params["dataImage"],
        hasImage: params["hasImage"] ?? false);

    return await textDao?.deleteData(textEntity);
  }

  Future<List<TextEntity>?> readData() async {
    final textData = database?.textDao;
    return await textData?.getAllTextData();
  }

  Future deleteAll(List<TextEntity>? listTextEntities) async {
    final textDao = database?.textDao;
    return await textDao?.deleteAll(listTextEntities!);
  }

  Data? readDataDetails(Map<String, dynamic> params) {
    final dataDetails = Data(
        hasImage: params["hasImage"],
        userId: params["userId"],
        id: params["id"],
        dateTime: params["dateTime"],
        data: params["data"],
        title: params["title"],
        dataImage: params["hasImage"] ? params["dataImage"] as String : null);
    return dataDetails;
  }

  Future<void> copyText(Map<String, dynamic> params) async {
    await Clipboard.setData(ClipboardData(text: params["text"]));
  }
}
