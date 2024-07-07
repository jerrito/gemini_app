

import 'package:dartz/dartz.dart';
import 'package:gemini/core/usecase/usecase.dart';
import 'package:gemini/features/search_text/domain/repository/search_repository.dart';

class SpeechTextEnabled extends UseCases<bool, NoParams> {
  final SearchRepository repository;

  SpeechTextEnabled({required this.repository});

  @override
  Future<Either<String, bool>> call(NoParams params) async {
    return await repository.isSpeechTextEnabled();
  }
}

