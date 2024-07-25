import 'package:dartz/dartz.dart';
import 'package:gemini/core/usecase/usecase.dart';
import 'package:gemini/features/authentication/domain/repository/auth_repo.dart';

class DeleteToken extends UseCases<dynamic,Map<String,dynamic>>{
  final AuthenticationRepository repository;

  DeleteToken({required this.repository});
  @override
  Future<Either<String, dynamic>> call(Map<String, dynamic> params) async{
    return await repository.deleteToken(params);
  }

}











