import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class AuthenticationLocalDatasource {
  cacheUserData(Map<String, dynamic> userData);
  cacheToken(Map<String, dynamic> authorization);
  Future<Map<String, dynamic>> getCachedUser();
  Future<Map<String, dynamic>> getToken();
  deleteToken(Map<String,dynamic> params);
}

class AuthenticationLocalDatasourceImpl
    implements AuthenticationLocalDatasource {
  // Create storage
  final storage = const FlutterSecureStorage();

  final userCacheKey = "userKey";
  final tokenKey = "tokenKey";
  SharedPreferences? sharedPreferences;
  @override
  cacheUserData(Map<String, dynamic> userData) async {
    final data =
        await storage.write(key: userCacheKey, value: jsonEncode(userData));
    return data;
  }

  @override
  Future<Map<String, dynamic>> getCachedUser() async {
    final data = await storage.read(key: userCacheKey);
    return json.decode(data!);
  }

  @override
  cacheToken(Map<String, dynamic> authorization) async {
    // Read value
    await storage.write(key: tokenKey, value: jsonEncode(authorization));
  }

  @override
  Future<Map<String, dynamic>> getToken() async {
    final authorization = await storage.read(key: tokenKey);
    return jsonDecode(authorization!);
  }
  
  @override
  deleteToken(Map<String, dynamic> params) async{
    final response=await storage.delete(key: tokenKey);
    return response;
  }
}
