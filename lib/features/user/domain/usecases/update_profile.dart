import 'package:dartz/dartz.dart';
import 'package:gemini/core/usecase/usecase.dart';
import 'package:gemini/features/authentication/domain/entities/user.dart';
import 'package:gemini/features/user/domain/repositories/user_repository.dart';

class UpdateProfile extends UseCases<String, Map<String, dynamic>> {
  final UserRepository repository;

  UpdateProfile({required this.repository});
  @override
  Future<Either<String, String>> call(params) async {
    return await repository.updateProfile(params);
  }
}
