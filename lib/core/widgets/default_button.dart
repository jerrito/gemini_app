import 'package:flutter/material.dart';
import 'package:gemini/core/size/sizes.dart';

class DefaultButton extends StatelessWidget {
  final void Function()? onTap;
  final String? label;
  const DefaultButton({super.key, this.onTap, this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: Sizes().height(context, 0.05),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 54, 225, 244),
          foregroundColor: Colors.white
        ),
        onPressed: onTap,
        child: Text(label!),
      ) ,
    );
  }
}
