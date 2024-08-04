import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:gemini/core/error/error_model.dart';
import 'package:gemini/core/urls/urls.dart';
import 'package:gemini/features/authentication/data/models/admin_model.dart';
import 'package:gemini/features/authentication/data/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthenticationRemoteDatasource {
  //signup
  Future<UserCredential> signupUser(Map<String, dynamic> params);

// signin
  Future<UserCredential> signinUser(Map<String, dynamic> params);

  // get user
  Future<UserCredential> getUser(Map<String, dynamic> params);

  // logout
  Future<String> logout(Map<String, dynamic> params);

// refresh token
  Future<String> refreshToken(String refreshToken);

// delete account
  Future<String> deleteAccount(Map<String, dynamic> params);

  Future<AdminModelResponse> becomeATeacher(Map<String, dynamic> params);

  Future<User> verifyOTP(PhoneAuthCredential credential);
}

class AuthenticationRemoteDatasourceImpl
    implements AuthenticationRemoteDatasource {
  final http.Client client;

  AuthenticationRemoteDatasourceImpl({required this.client});
  @override
  Future<UserCredential> signupUser(Map<String, dynamic> params) async {
    Map<String, String>? headers = {};
    headers.addAll(<String, String>{
      "Content-Type": "application/json; charset=UTF-8",
    });
    final Map<String, dynamic> body = {
      "userName": params["userName"],
      "email": params["email"],
      "password": params["password"],
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
    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception(ErrorModel.fromJson(data).toMap());
    }
  }

  @override
  Future<UserCredential> signinUser(Map<String, dynamic> params) async {
    Map<String, String>? headers = {};
    headers.addAll(<String, String>{
      "Content-Type": "application/json; charset=UTF-8",
    });
    final Map<String, dynamic> body = {
      "email": params["email"],
      "password": params["password"],
      "phoneNumber": params["phoneNumber"]
    };
    final response = await client.post(
      getUri(endpoint: Url.signinUrl.endpoint),
      headers: headers,
      body: jsonEncode(
        body,
      ),
    );
    final decodedResponse = jsonDecode(response.body);
    print(decodedResponse);

    if (response.statusCode == 200) {
      return decodedResponse;
    } else {
      throw Exception(ErrorModel.fromJson(decodedResponse).toMap());
    }
  }

  @override
  Future<UserCredential> getUser(Map<String, dynamic> params) async {
    Map<String, String>? headers = {};

    headers.addAll({
      "Content-Type": "application/json; charset=UTF-8",
      "Authorization": await FirebaseMessaging.instance.getToken() ?? ""
    });

    final response = await client.get(getUri(endpoint: Url.homeUrl.endpoint),
        headers: headers);
    final decodedResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return decodedResponse;
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
      return data["message"];
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
      "Authorization": await FirebaseMessaging.instance.getToken() ?? ""
    });

    print(await FirebaseMessaging.instance.getToken());
    print(FirebaseAuth.instance.currentUser?.refreshToken);
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

    final response = await client.delete(
      getUri(endpoint: Url.deleteAccount.endpoint),
      body: jsonEncode(params["body"]),
      headers: headers,
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == HttpStatus.ok) {
      return data["message"];
    } else {
      throw Exception(
        ErrorModel.fromJson(data).toMap(),
      );
    }
  }

  @override
  Future<AdminModelResponse> becomeATeacher(Map<String, dynamic> params) async {
    Map<String, String>? headers = {};

    headers.addAll({
      "Content-Type": "application/json; charset=UTF-8",
      "Authorization": params["token"]
    });

    final response = await client.post(
      getUri(endpoint: Url.becomeATeacherUrl.endpoint),
      body: jsonEncode(params["body"]),
      headers: headers,
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == HttpStatus.ok) {
      return AdminModelResponse.fromJson(data);
    } else {
      throw Exception(
        ErrorModel.fromJson(data).toMap(),
      );
    }
  }

  @override
  Future<User> verifyOTP(PhoneAuthCredential credential) async {
    final response =
        await FirebaseAuth.instance.signInWithCredential(credential);

    if (kDebugMode) {
      print(response.user?.uid);
    }

    return response.user!;
  }
}
