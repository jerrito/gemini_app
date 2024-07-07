
import 'package:dartz/dartz.dart';
import 'package:gemini/core/usecase/usecase.dart';
import 'package:gemini/features/search_text/domain/repository/search_repository.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class OnSpeechResult extends UseCases<void, SpeechRecognitionResult > {
  final SearchRepository repository;

  OnSpeechResult({required this.repository});

  @override
  Future<Either<String, String>> call(SpeechRecognitionResult params) async {
    return  repository.onSpeechResult( params);
  }
}
