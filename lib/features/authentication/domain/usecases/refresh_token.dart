import 'package:dartz/dartz.dart';
import 'package:gemini/core/usecase/usecase.dart';
import 'package:gemini/features/authentication/domain/repository/auth_repo.dart';

class RefreshToken extends UseCases<String, String> {
  final AuthenticationRepository repository;

  RefreshToken({required this.repository});
  
  @override
  Future<Either<String, String>> call(String params) async {
    return await repository.refreshToken(params);
  }
}
