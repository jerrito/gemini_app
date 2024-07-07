import 'package:dartz/dartz.dart';
import 'package:gemini/core/usecase/usecase.dart';
import 'package:gemini/features/search_text/domain/repository/search_repository.dart';
import 'package:gemini/features/sqlite_database/entities/text.dart';

class DeleteAllData extends UseCases<dynamic, List<TextEntity>?> {
  final SearchRepository searchRepository;

  DeleteAllData({required this.searchRepository});
  @override
  Future<Either<String, dynamic>> call(List<TextEntity>? params) async {
    return await searchRepository.deleteAll(params);
  }
}
