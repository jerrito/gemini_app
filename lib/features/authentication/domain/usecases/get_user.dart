import 'package:dartz/dartz.dart';
import 'package:gemini/core/usecase/usecase.dart';
import 'package:gemini/features/authentication/domain/entities/user.dart';
import 'package:gemini/features/authentication/domain/repository/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
class GetUserData extends UseCases<UserCredential, Map<String, dynamic>> {
  final AuthenticationRepository repository;

  GetUserData({required this.repository});

  @override
  Future<Either<String, UserCredential>> call(Map<String, dynamic> params)async{
    return await repository.getUser(params);
  }
}
