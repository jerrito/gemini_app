import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:gemini/core/network/networkinfo.dart';
import 'package:gemini/features/authentication/domain/entities/user.dart';
import 'package:gemini/features/user/data/datasources/local_ds.dart';
import 'package:gemini/features/user/data/datasources/remote.dart';
import 'package:gemini/features/user/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDatasource remoteDatasource;
  final UserLocalDatasource localDatasource;
  final NetworkInfo networkInfo;
  UserRepositoryImpl({
    required this.networkInfo,
    required this.localDatasource,
    required this.remoteDatasource,
  });

  //! UPDATE USER
  @override
  Future<Either<String, User>> updateUser(Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDatasource.updateUser(params);
        return Right(response);
      } catch (e) {
        return Left(e.toString());
      }
    } else {
      return Left(
        networkInfo.noNetworkMessage,
      );
    }
  }

  //! UPDATE PROFILE
  @override
  Future<Either<String, String>> updateProfile(
      Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDatasource.updateProfilePicture(params);
        return Right(response);
      } catch (e) {
        return Left(
          e.toString(),
        );
      }
    } else {
      return Left(
        networkInfo.noNetworkMessage,
      );
    }
  }

  //! PICK IMAGE
  @override
  Future<Either<String, Uint8List?>> pickImage(
      Map<String, dynamic> params) async {
    try {
      final response = await localDatasource.addFileImage(params);
      return Right(response);
    } catch (e) {
      return Left(e.toString());
    }
  }

  //! CHANGE PASSWORD
  @override
  Future<Either<String, String>> changePassword(
      Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDatasource.changePassword(params);

        return Right(response);
      } catch (e) {
        return Left(e.toString());
      }
    } else {
      return Left(networkInfo.noNetworkMessage);
    }
  }
}
