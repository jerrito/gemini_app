import 'package:dartz/dartz.dart';
import 'package:gemini/core/usecase/usecase.dart';
import 'package:gemini/features/authentication/domain/entities/admin.dart';
import 'package:gemini/features/authentication/domain/repository/auth_repo.dart';

class BecomeATeacher extends UseCases<AdminResponse,Map<String,dynamic>>{
  final AuthenticationRepository repository;

  BecomeATeacher({required this.repository});
  @override
  Future<Either<String, AdminResponse>> call(Map<String, dynamic> params) async{
    return await repository.becomeATeacher(params);
  }

}











