import 'package:dartz/dartz.dart';
import 'package:gemini/features/search_text/domain/repository/search_repository.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GenerateContent  {
  final SearchRepository repository;

  GenerateContent({required this.repository});
 
  Stream<Either<String, Stream<GenerateContentResponse>>> generateContent(Map<String, dynamic> params) async*{
    yield*  repository.generateContent(params); 
  }
}
