import 'dart:async';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:gemini/main.dart';
import 'package:gemini/features/sqlite_database/entities/text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

abstract class SearchLocalDatasource {
  Future<Map<List<Uint8List>, List<String>>> images();
  Future<List<TextEntity>?> readData();
  Future deleteAll(List<TextEntity>? listTextEntities);
  Future<bool> isSpeechTextEnabled();
  Future<dynamic> listenToSpeechText();
  Future<void> stopSpeechText();
  String onSpeechResult(SpeechRecognitionResult result);
}

class SearchLocalDatasourceImpl implements SearchLocalDatasource {
  final _speechToText = SpeechToText();
  @override

  /// This has to happen only once per app
  Future<bool> isSpeechTextEnabled() async {
    final speechEnabled = await _speechToText.initialize();
    return speechEnabled;
  }

  @override
  Future deleteAll(List<TextEntity>? listTextEntities) async {
    final textDao = database?.textDao;
    return await textDao?.deleteAll(listTextEntities!);
  }

  @override

  /// Each time to start a speech recognition session
  Future<dynamic> listenToSpeechText() async {
    final response = await _speechToText.listen(onResult: onSpeechResult);
    return response;
  }

  @override

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  Future<void> stopSpeechText() async {
    return await _speechToText.stop();
  }

  @override

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  String onSpeechResult(SpeechRecognitionResult result) {
    return result.recognizedWords;
  }

  @override
  Future<Map<List<Uint8List>, List<String>>> images() async {
    final response = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: true, withData: true);

    List<Uint8List> file = [];
    List<String> ext = [];
    Map<List<Uint8List>, List<String>> all = <List<Uint8List>, List<String>>{};
    if (response!.files.isNotEmpty) {
      file.addAll(response.files.map((e) => e.bytes!));
      ext.addAll(response.files.map((e) => e.extension!));
    }

    all.addAll({file: ext});

    //file);
    return all;
  }

  @override
  Future<List<TextEntity>?> readData() async {
    final textData = database?.textDao;
    return await textData?.getAllTextData();
  }
}
