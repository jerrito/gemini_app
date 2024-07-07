import 'package:dartz/dartz.dart';
import 'package:gemini/core/usecase/usecase.dart';
import 'package:gemini/features/authentication/domain/entities/user.dart';
import 'package:gemini/features/user/domain/repositories/user_repository.dart';

class UpdateUser extends UseCases<User, Map<String, dynamic>> {
  final UserRepository repository;

  UpdateUser({required this.repository});
  @override
  Future<Either<String, User>> call(Map<String, dynamic> params) async {
    return await repository.updateUser(params);
  }
}
