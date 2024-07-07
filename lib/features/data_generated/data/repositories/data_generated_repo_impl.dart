import 'package:dartz/dartz.dart';
import 'package:gemini/core/network/networkinfo.dart';
import 'package:gemini/features/data_generated/data/datasources/remote_ds.dart';
import 'package:gemini/features/data_generated/domain/entities/data.dart';
import 'package:gemini/features/data_generated/domain/repositories/data_generated_repo.dart';

class DataGeneratedRepositorympl implements DataGeneratedRepository {
  final NetworkInfo networkInfo;
  final DataGeneratedRemoteDatasource dataGeneratedRemoteDatasource;

  DataGeneratedRepositorympl(
      {required this.networkInfo, required this.dataGeneratedRemoteDatasource});
  @override
  Future<Either<String, Data>> addDataGenerated(
      Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        final response =
            await dataGeneratedRemoteDatasource.addDataGenerated(params);
        return Right(response);
      } catch (e) {
        return Left(e.toString());
      }
    } else {
      return Left(networkInfo.noNetworkMessage);
    }
  }

  @override
  Future<Either<String, List<Data>>> allDataGenerated(
      Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        final response =
            await dataGeneratedRemoteDatasource.listDataGenerated(params);
        return Right(response);
      } catch (e) {
        return Left(e.toString());
      }
    } else {
      return Left(networkInfo.noNetworkMessage);
    }
  }

  @override
  Future<Either<String, bool>> deleteDataGenerated(
      Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        final response =
            await dataGeneratedRemoteDatasource.deleteDataGenerated(params);
        return Right(response);
      } catch (e) {
        return Left(e.toString());
      }
    } else {
      return Left(networkInfo.noNetworkMessage);
    }
  }

  @override
  Future<Either<String, Data>> getDataGeneratedById(
      Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        final response =
            await dataGeneratedRemoteDatasource.getDataGeneratedById(params);
        return Right(response);
      } catch (e) {
        return Left(e.toString());
      }
    } else {
      return Left(networkInfo.noNetworkMessage);
    }
  }

  @override
  Future<Either<String, bool>> deleteListDataGenerated(
      Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataGeneratedRemoteDatasource
            .deleteMultipleDataGenerated(params);
        return Right(response);
      } catch (e) {
        return Left(e.toString());
      }
    } else {
      return Left(networkInfo.noNetworkMessage);
    }
  }
}
