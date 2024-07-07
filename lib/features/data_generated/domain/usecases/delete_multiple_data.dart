import 'package:dartz/dartz.dart';
import 'package:gemini/core/usecase/usecase.dart';
import 'package:gemini/features/data_generated/domain/repositories/data_generated_repo.dart';

class DeleteListDataGenerated extends UseCases<bool, Map<String, dynamic>> {
  final DataGeneratedRepository repository;

  DeleteListDataGenerated({required this.repository});
  @override
  Future<Either<String, bool>> call(Map<String, dynamic> params) async {
    return await repository.deleteListDataGenerated(params);
  }
}
