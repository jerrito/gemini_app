import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:gemini/core/error/error_model.dart';
import 'package:gemini/core/urls/urls.dart';
import 'package:gemini/features/authentication/data/models/user_model.dart';

abstract class UserRemoteDatasource {
  // update user
  Future<UserModel> updateUser(Map<String, dynamic> params);

  // update profile
  Future<String> updateProfilePicture(Map<String, dynamic> params);

  //change password
  Future<String> changePassword(Map<String, dynamic> params);
}

class UserRemoteDatasourceImpl implements UserRemoteDatasource {
  final http.Client client;
  final FirebaseAuth firebaseAuth;

  UserRemoteDatasourceImpl({required this.firebaseAuth, required this.client});
  @override
  Future<UserModel> updateUser(Map<String, dynamic> params) async {
    final String authoken =
        await firebaseAuth.currentUser?.getIdToken() ?? params["token"];
    Map<String, String>? headers = {};
    headers.addAll(<String, String>{
      "Content-Type": "application/json; charset=UTF-8",
      "Accept": "application/json",
      'Authorization': authoken
    });

    final Map<String, dynamic> queryParams = params["queryParams"];
    final response = await client.put(
      getUri(endpoint: Url.updateUser.endpoint, queryParams: queryParams),
      headers: headers,
    );
    final decodedResponse = jsonDecode(response.body);
    print(decodedResponse);
    if (response.statusCode == 200) {
      return UserModel.fromJson(decodedResponse["user"]);
    } else {
      throw Exception(ErrorModel.fromJson(decodedResponse));
    }
  }

  @override
  Future<String> updateProfilePicture(Map<String, dynamic> params) async {
    final String authoken =
        await firebaseAuth.currentUser?.getIdToken() ?? params["token"];
    Map<String, String>? headers = {};
    headers.addAll(<String, String>{
      "Content-Type": "application/json; charset=UTF-8",
      "Accept": "application/json",
      'Authorization': authoken
    });
    final Map<String, dynamic> body = {"data": params["dataImage"]};
    final response = await client.put(
        getUri(endpoint: Url.updateProfilePicture.endpoint),
        body: jsonEncode(body),
        headers: headers);
    final decodedResponse = jsonDecode(response.body);
    print(decodedResponse);
    if (response.statusCode == 200) {
      return decodedResponse["profile"];
    } else {
      throw Exception(ErrorModel.fromJson(decodedResponse));
    }
  }

  @override
  Future<String> changePassword(Map<String, dynamic> params) async {
    final String authoken =
        await firebaseAuth.currentUser?.getIdToken() ?? params["token"];
    Map<String, String>? headers = {};
    headers.addAll(<String, String>{
      "Content-Type": "application/json; charset=UTF-8",
      "Accept": "application/json",
      'Authorization': authoken
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
