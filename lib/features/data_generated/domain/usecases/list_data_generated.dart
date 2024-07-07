

import 'package:dartz/dartz.dart';
import 'package:gemini/core/usecase/usecase.dart';
import 'package:gemini/features/data_generated/domain/entities/data.dart';
import 'package:gemini/features/data_generated/domain/repositories/data_generated_repo.dart';

class ListDataGenerated extends UseCases<List<Data>,Map<String,dynamic>>{
 final DataGeneratedRepository repository;

  ListDataGenerated({required this.repository});
  @override
  Future<Either<String, List<Data>>> call(Map<String, dynamic> params) async{
    
    return await repository.allDataGenerated(params);
  }

}