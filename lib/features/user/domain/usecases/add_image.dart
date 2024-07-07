
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:gemini/core/usecase/usecase.dart';
import 'package:gemini/features/user/domain/repositories/user_repository.dart';

class PickImage extends UseCases<Uint8List?,Map<String,dynamic>>{
  final UserRepository repository;

  PickImage({required this.repository});
  @override
  Future<Either<String, Uint8List?>> call(params) async{
    return await repository.pickImage(params);
  }

}