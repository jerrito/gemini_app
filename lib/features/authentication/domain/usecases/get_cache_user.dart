

import 'package:dartz/dartz.dart';
import 'package:gemini/features/authentication/domain/repository/auth_repo.dart';

class GetCacheUser {
  final AuthenticationRepository repository;

  GetCacheUser({required this.repository});

   // get cached User 
  Future<Either<String, Map<String, dynamic>>> getCachedUser()async{

    return await repository.getCachedUser();
  }
}