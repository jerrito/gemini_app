

import 'package:flutter/foundation.dart';

class TokenProvider extends ChangeNotifier{

  String? _token;

  String? get token => _token;

 set setToken(String token){
    print(token);
    _token = token;
    print(_token);
    notifyListeners();
  }
}