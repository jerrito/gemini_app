import 'package:dartz/dartz.dart';
import 'package:gemini/core/usecase/usecase.dart';
import 'package:gemini/features/user/domain/repositories/user_repository.dart';

class ChangePassword extends UseCases<String,Map<String,dynamic>>{
  final UserRepository repository;

  ChangePassword({required this.repository});
  @override
  Future<Either<String, String>> call(Map<String, dynamic> params) async{
     return await repository.changePassword(params);
  }

}