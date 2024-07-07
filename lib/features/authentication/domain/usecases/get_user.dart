import 'package:dartz/dartz.dart';
import 'package:gemini/core/usecase/usecase.dart';
import 'package:gemini/features/authentication/domain/entities/user.dart';
import 'package:gemini/features/authentication/domain/repository/auth_repo.dart';

class GetUserData extends UseCases<User, Map<String, dynamic>> {
  final AuthenticationRepository repository;

  GetUserData({required this.repository});

  @override
  Future<Either<String, User>> call(Map<String, dynamic> params)async{
    return await repository.getUser(params);
  }
}
