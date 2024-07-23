import 'dart:convert';
import 'dart:io';
import 'package:gemini/core/error/error_model.dart';
import 'package:gemini/core/urls/urls.dart';
import 'package:gemini/features/authentication/data/models/user_model.dart';
import 'package:http/http.dart' as http;

abstract class AuthenticationRemoteDatasource {
  //signup
  Future<SignupResponseModel> signupUser(Map<String, dynamic> params);

// signin
  Future<SigninResponseModel> signinUser(Map<String, dynamic> params);

  // get user
  Future<UserModel> getUser(Map<String, dynamic> params);

  // logout
  Future<String> logout(Map<String, dynamic> params);

// refresh token
  Future<String> refreshToken(String refreshToken);

// delete account
  Future<String> deleteAccount(Map<String, dynamic> params);
}

class AuthenticationRemoteDatasourceImpl
    implements AuthenticationRemoteDatasource {
  final http.Client client;

  AuthenticationRemoteDatasourceImpl({required this.client});
  @override
  Future<SignupResponseModel> signupUser(Map<String, dynamic> params) async {
    Map<String, String>? headers = {};
    headers.addAll(<String, String>{
      "Content-Type": "application/json; charset=UTF-8",
    });
    final Map<String, dynamic> body = {
      "userName": params["userName"],
      "email": params["email"],
      "password": params["password"],
      "profile": ""
    };

    final response = await client.post(
      getUri(
        endpoint: Url.signupUrl.endpoint,
      ),
      headers: headers,
      body: jsonEncode(
        body,
      ),
    );
    final data = jsonDecode(response.body);
    print(data);
    if (response.statusCode == 200) {
      return SignupResponseModel.fromJson(data);
    } else {
      throw Exception(ErrorModel.fromJson(data).toMap());
    }
  }

  @override
  Future<SigninResponseModel> signinUser(Map<String, dynamic> params) async {
    Map<String, String>? headers = {};
    headers.addAll(<String, String>{
      "Content-Type": "application/json; charset=UTF-8",
    });
    final Map<String, dynamic> body = {
      "email": params["email"],
      "password": params["password"],
    };
    final response = await client.post(
      getUri(endpoint: Url.signinUrl.endpoint),
      headers: headers,
      body: jsonEncode(
        body,
      ),
    );
    final decodedResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return SigninResponseModel.fromJson(decodedResponse);
    } else {
      throw Exception(ErrorModel.fromJson(decodedResponse).toMap());
    }
  }

  @override
  Future<UserModel> getUser(Map<String, dynamic> params) async {
    Map<String, String>? headers = {};

    headers.addAll({
      "Content-Type": "application/json; charset=UTF-8",
      "Authorization": params["token"]
    });

    final response = await client.get(getUri(endpoint: Url.homeUrl.endpoint),
        headers: headers);
    final decodedResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return UserModel.fromJson(decodedResponse);
    } else {
      throw Exception(ErrorModel.fromJson(decodedResponse).toMap());
    }
  }

  @override
  Future<String> logout(Map<String, dynamic> params) async {
    Map<String, String>? headers = {};

    headers.addAll({
      "Content-Type": "application/json; charset=UTF-8",
      "Authorization": params["token"]
    });

    final response = await client.post(
      getUri(
        endpoint: Url.logoutUrl.endpoint,
      ),
      headers: headers,
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == HttpStatus.ok) {
      return data["success"];
    } else {
      throw Exception(
        ErrorModel.fromJson(data).toMap(),
      );
    }
  }

  @override
  Future<String> refreshToken(String refreshToken) async {
    Map<String, String>? headers = {};

    headers.addAll({
      "Content-Type": "application/json; charset=UTF-8",
      "Authorization": refreshToken
    });

    final response = await client
        .post(getUri(endpoint: Url.refreshUrl.endpoint), headers: headers);
    final data = jsonDecode(response.body);
    if (response.statusCode == HttpStatus.ok) {
      return data["token"];
    } else {
      throw Exception(
        ErrorModel.fromJson(data).toMap(),
      );
    }
  }

  @override
  Future<String> deleteAccount(Map<String, dynamic> params) async {
    Map<String, String>? headers = {};

    headers.addAll({
      "Content-Type": "application/json; charset=UTF-8",
      "Authorization": params["token"]
    });

    final response = await client
        .delete(getUri(endpoint: Url.deleteAccount.endpoint),body: params["body"], headers: headers);
    final data = jsonDecode(response.body);
    if (response.statusCode == HttpStatus.ok) {
      return data["message"];
    } else {
      throw Exception(
        ErrorModel.fromJson(data).toMap(),
      );
    }
  }
}
