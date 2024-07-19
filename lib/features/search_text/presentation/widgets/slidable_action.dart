import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gemini/core/size/sizes.dart';

class SlidableActionWidget extends StatelessWidget {
  final void Function(BuildContext)? onPressed;
  final bool isDeleteButton;
  const SlidableActionWidget(
      {super.key, required this.onPressed, required this.isDeleteButton});

  @override
  Widget build(BuildContext context) {
    return SlidableAction(
      borderRadius: BorderRadius.circular(Sizes().height(context, 0.01)),
      onPressed: onPressed,
      backgroundColor: isDeleteButton
          ? const Color.fromARGB(255, 229, 6, 6)
          : const Color.fromARGB(255, 73, 229, 6),
      foregroundColor: Colors.white,
      icon: isDeleteButton ? Icons.delete : Icons.share,
      padding: EdgeInsets.symmetric(horizontal: Sizes().width(context, 0.02)),
    );
  }
}
