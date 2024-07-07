import 'package:dartz/dartz.dart';
import 'package:gemini/core/usecase/usecase.dart';
import 'package:gemini/features/authentication/domain/entities/user.dart';
import 'package:gemini/features/authentication/domain/repository/auth_repo.dart';

class Signin extends UseCases<SigninResponse, Map<String, dynamic>> {
  final AuthenticationRepository repository;

  Signin({required this.repository});
  @override
  Future<Either<String, SigninResponse>> call(Map<String, dynamic> params) async {
    return await repository.signin(params);
  }
}
