import 'package:dartz/dartz.dart';
import 'package:gemini/core/network/networkinfo.dart';
import 'package:gemini/features/authentication/data/data_source/local_ds.dart';
import 'package:gemini/features/authentication/data/data_source/remote_ds.dart';
import 'package:gemini/features/authentication/domain/entities/admin.dart';
import 'package:gemini/features/authentication/domain/entities/user.dart';
import 'package:gemini/features/authentication/domain/repository/auth_repo.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final NetworkInfo networkInfo;
  final AuthenticationRemoteDatasource userRemoteDatasource;
  final AuthenticationLocalDatasource userLocalDatasource;

  AuthenticationRepositoryImpl(
      {required this.userLocalDatasource,
      required this.userRemoteDatasource,
      required this.networkInfo});

  @override
  Future<Either<String, SigninResponse>> signin(
      Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await userRemoteDatasource.signinUser(params);
        return Right(response);
      } catch (e) {
        return Left(e.toString());
      }
    } else {
      return Left(networkInfo.noNetworkMessage);
    }
  }

  @override
  Future<Either<String, SignupResponse>> signup(
      Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await userRemoteDatasource.signupUser(params);
        return Right(response);
      } catch (e) {
        return Left(e.toString());
      }
    } else {
      return Left(networkInfo.noNetworkMessage);
    }
  }

  @override
  Future<Either<String, dynamic>> cacheToken(
      Map<String, dynamic> authorization) async {
    try {
      final response = await userLocalDatasource.cacheToken(authorization);

      return Right(response);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Map<String, dynamic>>> getToken() async {
    try {
      final response = await userLocalDatasource.getToken();

      return Right(response);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, User>> getUser(Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await userRemoteDatasource.getUser(params);

        return Right(response);
      } catch (e) {
        return Left(e.toString());
      }
    } else {
      return Left(networkInfo.noNetworkMessage);
    }
  }

  @override
  Future<Either<String, dynamic>> cacheUserData(
      Map<String, dynamic> params) async {
    try {
      final response = await userLocalDatasource.cacheUserData(params);

      return Right(response);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Map<String, dynamic>>> getCachedUser() async {
    try {
      final response = await userLocalDatasource.getCachedUser();

      return Right(response);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> logout(Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await userRemoteDatasource.logout(params);

        return Right(response);
      } catch (e) {
        return Left(e.toString());
      }
    } else {
      return Left(networkInfo.noNetworkMessage);
    }
  }

  @override
  Future<Either<String, String>> refreshToken(String refreshToken) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await userRemoteDatasource.refreshToken(refreshToken);

        return Right(response);
      } catch (e) {
        return Left(e.toString());
      }
    } else {
      return Left(networkInfo.noNetworkMessage);
    }
  }
  
  @override
  Future<Either<String, String>> deleteAccount(Map<String, dynamic> params) async{
    if (await networkInfo.isConnected) {
      try {
        final response = await userRemoteDatasource.deleteAccount(params);

        return Right(response);
      } catch (e) {
        return Left(e.toString());
      }
    } else {
      return Left(networkInfo.noNetworkMessage);
    }
  }
  
  @override
  Future<Either<String, dynamic>> deleteToken(Map<String, dynamic> params) async{
       try {
      final response = await userLocalDatasource.deleteToken(params);

      return Right(response);
    } catch (e) {
      return Left(e.toString());
    }

  }

  @override
  Future<Either<String, AdminResponse>> becomeATeacher(Map<String, dynamic> params) async{
   if (await networkInfo.isConnected) {
      try {
        final response = await userRemoteDatasource.becomeATeacher(params);

        return Right(response);
      } catch (e) {
        return Left(e.toString());
      }
    } else {
      return Left(networkInfo.noNetworkMessage);
    }
  }
  }
