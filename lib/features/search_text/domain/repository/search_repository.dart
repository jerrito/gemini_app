import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:gemini/features/sqlite_database/entities/text.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

abstract class SearchRepository {
  //search with text
  Future<Either<String, dynamic>> searchText(Map<String, dynamic> params);

  //chat
  Future<Either<String, dynamic>> chat(Map<String, dynamic> params);

  //search text and image
  Future<Either<String, dynamic>> searchTextAndImage(
      Map<String, dynamic> params);

  //add single or multiple images
  Future<Either<String, Map<List<Uint8List>, List<String>>>>
      addMultipleImages();

  // generate content
  Stream<Either<String, Stream<GenerateContentResponse>>> generateContent(
      Map<String, dynamic> params);

  // read data
  Future<Either<String, List<TextEntity>?>> readData();

  //delete all data
  Future<Either<String, void>> deleteAll(List<TextEntity>? listTextEntities);

  //check if is enabled
  Future<Either<String, bool>> isSpeechTextEnabled();

// listen to speech
  Future<Either<String, dynamic>> listenToSpeechText();

  //stop speech text
  Future<Either<String, void>> stopSpeechText();

  //on speech transformed to text
  Either<String, String> onSpeechResult(SpeechRecognitionResult result);
}
