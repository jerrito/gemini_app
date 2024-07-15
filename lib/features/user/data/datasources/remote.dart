import 'dart:convert';
import 'dart:io';
import 'package:gemini/core/error/error_model.dart';
import 'package:gemini/core/urls/urls.dart';
import 'package:http/http.dart' as http;
import 'package:gemini/features/authentication/data/models/user_model.dart';

abstract class UserRemoteDatasource {
  // update user
  Future<UserModel> updateUser(Map<String, dynamic> params);

  // update profile
  Future<String> updateProfile(Map<String, dynamic> params);

  //change password
  Future<String> changePassword(Map<String, dynamic> params);
}

class UserRemoteDatasourceImpl implements UserRemoteDatasource {
  final http.Client client;

  UserRemoteDatasourceImpl({required this.client});
  @override
  Future<UserModel> updateUser(Map<String, dynamic> params) async {
    Map<String, String>? headers = {};
    headers.addAll(<String, String>{
      "Content-Type": "application/json; charset=UTF-8",
      "Authorization": params["token"]
    });
    final Map<String, dynamic> queryParams = params["queryParams"];
    final response = await client.put(
      getUri(endpoint: Url.updateUser.endpoint, queryParams: queryParams),
      headers: headers,
    );
    final decodedResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return UserModel.fromJson(decodedResponse);
    } else {
      throw Exception(ErrorModel.fromJson(decodedResponse));
    }
  }

  @override
  Future<String> updateProfile(Map<String, dynamic> params) async {
    final Map<String, String> headers = {
      "Content-Type": "application/json; charset=UTF-8",
      "Authorization": params["token"]
    };
    final Map<String, dynamic> body = params["body"];
    final response = await client.put(
        getUri(endpoint: Url.updateProfile.endpoint),
        body: body,
        headers: headers);
    final decodedResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return decodedResponse;
    } else {
      throw Exception(ErrorModel.fromJson(decodedResponse));
    }
  }

  @override
  Future<String> changePassword(Map<String, dynamic> params) async {
    Map<String, String>? headers = {};
    headers.addAll({
      "Content-Type": "application/json; charset=UTF-8",
      "Authorization": params["token"]
    });
    final Map<String, dynamic> body = {
      "old_password": params["oldPassword"],
      "new_password": params["newPassword"],
      "confirm_password": params["confirmPassword"]
    };
    final response = await client.put(
      getUri(endpoint: Url.changePasswordUrl.endpoint),
      headers: headers,
      body: jsonEncode(body),
    );
    final decodedResponse = jsonDecode(response.body);
    if (response.statusCode == HttpStatus.ok) {
      return decodedResponse["message"];
    } else {
      throw Exception(
        ErrorModel.fromJson(decodedResponse).toMap(),
      );
    }
  }
}
