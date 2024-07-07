
import 'package:dartz/dartz.dart';
import 'package:gemini/core/usecase/usecase.dart';
import 'package:gemini/features/data_generated/domain/entities/data.dart';
import 'package:gemini/features/data_generated/domain/repositories/data_generated_repo.dart';

class AddDataGenerated extends UseCases<Data,Map<String ,dynamic>>{
  final DataGeneratedRepository repository;

  AddDataGenerated({required this.repository});
  @override
  Future<Either<String, Data>> call(Map<String, dynamic> params) async{
    
    return await repository.addDataGenerated(params);
  }

}