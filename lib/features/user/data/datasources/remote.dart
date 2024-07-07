import 'dart:convert';
import 'package:gemini/core/error/error_model.dart';
import 'package:gemini/core/urls/urls.dart';
import 'package:http/http.dart' as http;
import 'package:gemini/features/authentication/data/models/user_model.dart';

abstract class UserRemoteDatasource {
  // update user
  Future<UserModel> updateUser(Map<String, dynamic> params);

  // update profile
  Future<String> updateProfile(Map<String, dynamic> params);

}

class UserRemoteDatasourceImpl implements UserRemoteDatasource {
  final http.Client client;

  UserRemoteDatasourceImpl({required this.client});
  @override
  Future<UserModel> updateUser(Map<String, dynamic> params) async {
    final Map<String, String> headers = {
      "Content-Type": "application/json; charset=UTF-8",
      "token": params["token"]
    };
    final body = {"userName": params["userName"]};
    final response = await client.patch(getUri(endpoint: "endpoint"),
        body: jsonEncode(body), headers: headers);

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
      "token": params["token"]
    };
    final body = {"data": params["data"]};
    final response = await client.patch(getUri(endpoint: "endpoint"),
        body: jsonEncode(body), headers: headers);

    final decodedResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return decodedResponse;
    } else {
      throw Exception(ErrorModel.fromJson(decodedResponse));
    }
  }
}
