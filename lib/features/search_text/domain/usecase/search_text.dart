import 'package:dartz/dartz.dart';
import 'package:gemini/core/usecase/usecase.dart';
import 'package:gemini/features/search_text/domain/repository/search_repository.dart';

class SearchText extends UseCases<dynamic, Map<String, dynamic>> {
  final SearchRepository repository;

  SearchText({required this.repository});
  @override
  Future<Either<String, dynamic>> call(Map<String, dynamic> params) async {
    return await repository.searchText(params);
  }
}
