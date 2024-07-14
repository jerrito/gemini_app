

import 'package:flutter/foundation.dart';

class TokenProvider extends ChangeNotifier{

  String? _token, _refreshToken;

  String? get token => _token;
  String? get refreshToken => _refreshToken;

 set setToken(String token){
    _token = token;
    notifyListeners();
  }
  set setRefreshToken(String refreshToken){
    _refreshToken = refreshToken;
    notifyListeners();
    }

}