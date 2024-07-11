import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:gemini/features/authentication/domain/entities/user.dart';

abstract class UserRepository {
  // update user
  Future<Either<String, User>> updateUser(Map<String, dynamic> params);

  // update profile
  Future<Either<String, String>> updateProfile(Map<String, dynamic> params);

  //
  Future<Either<String,Uint8List?>> pickImage(Map<String, dynamic> params);

  // change password
  Future<Either<String, String>> changePassword(Map<String,dynamic>params);

}
