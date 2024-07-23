import 'package:flutter/material.dart';
import 'package:gemini/core/size/sizes.dart';
import 'package:gemini/core/spacing/whitspacing.dart';

class RemoveUser extends StatelessWidget {
  final VoidCallback onTap;
  final bool? isLogOut;
  final RemoveData removeData;
  const RemoveUser(
      {super.key,
      required this.onTap,
      this.isLogOut,
      required this.removeData});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: Sizes().height(context, .02)),
        child: Row(
          children: [
            Icon(removeData.icon),
            Space().width(context, .03),
            Text(removeData.name)
          ],
        ),
      ),
    );
  }
}

enum RemoveData {
  deleteUser(icon: Icons.delete),
  logOut(icon: Icons.cancel);

  final IconData icon;
  const RemoveData({required this.icon});
}
