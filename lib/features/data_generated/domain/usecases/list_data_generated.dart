import 'package:dartz/dartz.dart';
import 'package:gemini/core/usecase/usecase.dart';
import 'package:gemini/features/data_generated/domain/entities/data_info.dart';
import 'package:gemini/features/data_generated/domain/repositories/data_generated_repo.dart';

class ListDataGenerated extends UseCases<DataInfo, Map<String, dynamic>> {
  final DataGeneratedRepository repository;

  ListDataGenerated({required this.repository});
  @override
  Future<Either<String, DataInfo>> call(Map<String, dynamic> params) async {
    return await repository.allDataGenerated(params);
  }
}
