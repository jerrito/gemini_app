import 'dart:convert';
import 'dart:io';
import 'package:gemini/core/error/error_model.dart';
import 'package:gemini/core/urls/urls.dart';
import 'package:gemini/features/authentication/data/models/admin_model.dart';
import 'package:gemini/features/authentication/data/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthenticationRemoteDatasource {
  //signup
  Future<UserModel> signupUser(Map<String, dynamic> params);

// signin
  Future<UserModel> signinUser(Map<String, dynamic> params);

  // get user
  Future<UserModel> getUser(Map<String, dynamic>? params);

  // logout
  Future<String> logout(Map<String, dynamic> params);

// refresh token
  Future<String> refreshToken(String refreshToken);

// delete account
  Future<String> deleteAccount(Map<String, dynamic> params);

  Future<AdminModelResponse> becomeATeacher(Map<String, dynamic> params);

  Future<User> verifyOTP(PhoneAuthCredential credential);

  Future<void> verifyPhoneNumber(
    String phoneNumber,
    dynamic Function(String, int?) onCodeSent,
    dynamic Function(PhoneAuthCredential) onCompleted,
    dynamic Function(FirebaseAuthException) onFailed,
  );
}

class AuthenticationRemoteDatasourceImpl
    implements AuthenticationRemoteDatasource {
  final http.Client client;
  final FirebaseAuth firebaseAuth;

  AuthenticationRemoteDatasourceImpl({
    required this.client,
    required this.firebaseAuth,
  });
  @override
  Future<UserModel> signupUser(Map<String, dynamic> params) async {
    final String authoken =
        await firebaseAuth.currentUser?.getIdToken(true) ?? params["token"];
    Map<String, String>? headers = {};
    headers.addAll(<String, String>{
      "Content-Type": "application/json; charset=UTF-8",
      "Accept": "application/json",
      'Authorization': authoken
    });

    final Map<String, dynamic> body = {
      "userName": params["userName"],
      "email": params["email"],
      "password": params["password"],
      "phoneNumber": params["phoneNumber"]
    };
    // User;

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
      return UserModel.fromJson(data);
    } else {
      throw Exception(ErrorModel.fromJson(data).toMap());
    }
  }

  @override
  Future<UserModel> signinUser(Map<String, dynamic> params) async {
    final String authoken =
        await firebaseAuth.currentUser?.getIdToken(true) ?? params["token"];
    Map<String, String>? headers = {};
    headers.addAll(<String, String>{
      "Content-Type": "application/json; charset=UTF-8",
      "Accept": "application/json",
      'Authorization': authoken
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

    if (response.statusCode == 200) {
      return UserModel.fromJson(decodedResponse);
    } else {
      throw Exception(ErrorModel.fromJson(decodedResponse).toMap());
    }
  }

  @override
  Future<UserModel> getUser(Map<String, dynamic>? params) async {
    Map<String, String>? headers = {};
    final String authoken =
        await firebaseAuth.currentUser?.getIdToken(true) ?? params?["token"];
    headers.addAll({
      "Content-Type": "application/json",
      "Accept": "application/json",
      'Authorization': authoken
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
    final String authoken =
        await firebaseAuth.currentUser?.getIdToken() ?? params["token"];

    headers.addAll({
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": authoken
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
    final String authoken =
        await firebaseAuth.currentUser?.getIdToken() ?? refreshToken;

    headers.addAll({
      "Content-Type": "application/json; charset=UTF-8",
      "Accept": "application/json",
      "Authorization": authoken
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
    final String authoken =
        await firebaseAuth.currentUser?.getIdToken() ?? params["token"];

    headers.addAll({
      "Content-Type": "application/json; charset=UTF-8",
      "Accept": "application/json",
      "Authorization": authoken
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
    final String authoken =
        await firebaseAuth.currentUser?.getIdToken() ?? params["token"];

    headers.addAll({
      "Content-Type": "application/json; charset=UTF-8",
      "Accept": "application/json",
      "Authorization": authoken
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

    return response.user!;
  }

  @override
  Future<void> verifyPhoneNumber(
      String phoneNumber,
      Function(String verificationId, int? resendToken) onCodeSent,
      Function(PhoneAuthCredential phoneAuthCredential) onCompleted,
      Function(FirebaseAuthException) onFailed) async {
    await FirebaseAuth.instance
        .verifyPhoneNumber(
            phoneNumber: phoneNumber,
            timeout: const Duration(seconds: 120),
            verificationCompleted: onCompleted,
            verificationFailed: onFailed,
            codeSent: onCodeSent,
            codeAutoRetrievalTimeout: (String verificationId) {})
        .catchError((e) {
      throw FirebaseAuthException(
        code: e.toString(),
      );
    });
  }
}
