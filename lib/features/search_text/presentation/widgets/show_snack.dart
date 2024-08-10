import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gemini/core/size/sizes.dart';

showSnackbar({
  bool? isSuccessMessage,
  required BuildContext context,
  required String message,
}) {
  FToast fToast = FToast();
  fToast = FToast();
  // if you want to use context from globally instead of content we need to pass navigatorKey.currentContext!
  fToast.init(context);
  return fToast.showToast(
    toastDuration: const Duration(milliseconds: 3500),
    isDismissable: true,
    gravity: ToastGravity.TOP,
    child: Container(
      width: double.infinity,
      height: Sizes().height(context, 0.055),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Sizes().height(context, 0.01)),
          color: (isSuccessMessage ?? false)
              ? const Color.fromRGBO(7, 158, 7, 1)
              : const Color.fromRGBO(205, 6, 16, 0.894)),

      // action: SnackBarAction(label: label, onPressed: onPressed),
      child: Center(
        child: Text(
          message.length <= 150 ? message : "${message.substring(0, 100)} ...",
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
      ),
    ),
  );
}
