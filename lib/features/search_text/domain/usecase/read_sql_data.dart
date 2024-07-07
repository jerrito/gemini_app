import 'package:dartz/dartz.dart';
import 'package:gemini/core/usecase/usecase.dart';
import 'package:gemini/features/search_text/domain/repository/search_repository.dart';
import 'package:gemini/features/sqlite_database/entities/text.dart';

class ReadData extends UseCases<List<TextEntity>?, NoParams> {
  final SearchRepository searchRepository;

  ReadData({required this.searchRepository});
  @override
  Future<Either<String, List<TextEntity>?>> call(NoParams params) async {
    return await searchRepository.readData();
  }
}
