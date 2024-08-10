import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';

class FirebaseAppCheckHelper {
  FirebaseAppCheckHelper._();

  static Future initialiseAppCheck() async {
    await FirebaseAppCheck.instance.activate(
       webProvider: _webProvider(),
      androidProvider: _androidProvider(),
    );
  }

  static Future getAppCheckToken() async {
    return await FirebaseAppCheck.instance.getToken();
  }

  static AndroidProvider _androidProvider() {
    if (kDebugMode) {
      return AndroidProvider.debug;
    }

    return AndroidProvider.playIntegrity;
  }
}

ReCaptchaV3Provider _webProvider() {
  return ReCaptchaV3Provider('recaptcha-v3-site-key');
}
