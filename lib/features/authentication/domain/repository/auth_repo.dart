import "package:dartz/dartz.dart";
import "package:gemini/features/authentication/domain/entities/admin.dart";
// import "package:gemini/features/authentication/domain/entities/user.dart";
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthenticationRepository {
// signup
  Future<Either<String, UserCredential>> signup(Map<String, dynamic> params);

// signin
  Future<Either<String, UserCredential>> signin(Map<String, dynamic> params);

  //cache user
  Future<Either<String, dynamic>> cacheUserData(Map<String, dynamic> params);

  //get User
  Future<Either<String, UserCredential>> getUser(Map<String, dynamic> params);

  //cache token
  Future<Either<String, dynamic>> cacheToken(
      Map<String, dynamic> authorization);

  //get token
  Future<Either<String, Map<String, dynamic>>> getToken();

// delete token
  Future<Either<String, dynamic>> deleteToken(Map<String, dynamic> params);

  // get cached User
  Future<Either<String, Map<String, dynamic>>> getCachedUser();

  //log out
  Future<Either<String, String>> logout(Map<String, dynamic> params);

  // refresh token
  Future<Either<String, String>> refreshToken(String refreshToken);

  //delete account
  Future<Either<String, String>> deleteAccount(Map<String, dynamic> params);

// become a teacher
  Future<Either<String, AdminResponse>> becomeATeacher(
      Map<String, dynamic> params);
}
