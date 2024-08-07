import 'package:flutter/material.dart';

class IconGesture extends StatelessWidget {
  final VoidCallback? onTap;
  final IconData icon;
  const IconGesture({super.key, required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon),
    );
  }
}
