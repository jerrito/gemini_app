import 'package:flutter/material.dart';
import 'package:gemini/core/size/sizes.dart';

showSnackbar({
  bool? isSuccessMessage,
  required BuildContext context,
  required String message,
}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      showCloseIcon: true,
      elevation: Sizes().height(context, 1) - 100,
      backgroundColor: (isSuccessMessage ?? false)
          ? const Color.fromRGBO(7, 158, 7, 1)
          : const Color.fromRGBO(205, 6, 16, 0.894),
      behavior: SnackBarBehavior.floating,
      content: Text(
        message.length <= 150 ? message : "${message.substring(0, 100)} ...",
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    ),
  );
}
