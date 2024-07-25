import "dart:async";
import "package:gemini/core/api/api_key.dart";
import "package:google_generative_ai/google_generative_ai.dart" as ai;

abstract class SearchRemoteDatasource {
  // future text search
  Future<dynamic> searchText(Map<String, dynamic> params);

  // search with text and image
  Future<dynamic> searchTextAndImage(Map<String, dynamic> params);

  // stream to generateContent
  Stream<ai.GenerateContentResponse> generateContent(
      Map<String, dynamic> params);

  //chat
  Future<dynamic> chat(Map<String, dynamic> params);
}

class SearchRemoteDatasourceImpl implements SearchRemoteDatasource {
  // final NetworkInfo networkInfo;

  final model =
      ai.GenerativeModel(model: "gemini-1.5-flash-latest", apiKey: apiKey);

  SearchRemoteDatasourceImpl();

  @override
  Future searchText(Map<String, dynamic> params) async {
    final content = [ai.Content.text(params["text"])];

    final response = await model.generateContent(content);
    return response.text;
  }

  @override
  Future<dynamic> searchTextAndImage(Map<String, dynamic> params) async {
    // final model = ai.GenerativeModel(model: 'gemini-pro-vision', apiKey: apiKey);
    final prompt = ai.TextPart(params["text"]);
    final imageParts = [];
    // params["images"].map(
    //   (e)=>ai.DataPart('image/${params["ext"][e]}', params["image"][e])
    // ).toList();
    // ai.DataPart('image/${params["ext"]}', params["image"]),
    for (int i = 0; i < params["images"]; i++) {
      imageParts
          .add(ai.DataPart('image/${params["ext"][i]}', params["image"][i]));
    }
    final response = await model.generateContent([
      ai.Content.multi([prompt, ...imageParts])
    ]);
    return response.text;
  }

  @override
  Stream<ai.GenerateContentResponse> generateContent(
      Map<String, dynamic> params) async* {
    final content = [ai.Content.text(params["text"])];

    final response = model.generateContentStream(content, safetySettings: [
      ai.SafetySetting(
          ai.HarmCategory.dangerousContent, ai.HarmBlockThreshold.none)
    ]);

    yield* response.asBroadcastStream();
  }

  @override
  Future chat(Map<String, dynamic> params) async {
    final content = ai.Content.text(params["text"]);
    final chat = model.startChat();

    final response = await chat.sendMessage(content);
    return response.text;
  }
}
