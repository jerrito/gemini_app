import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gemini/assets/svgs/svgs.dart';
import 'package:gemini/core/size/sizes.dart';

class UserProfileWidget extends StatelessWidget {
  final VoidCallback onTap;
  final UserProfileData userProfileData;
  final String label;
  const UserProfileWidget(
      {super.key,
      required this.userProfileData,
      required this.onTap,
      required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Sizes().height(context, 0.005)),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        contentPadding: EdgeInsets.zero,
        visualDensity: VisualDensity.comfortable,
        leading: SvgPicture.asset(
          userProfileData.svg,
          colorFilter: ColorFilter.mode(
              theme.brightness == Brightness.dark ? Colors.white : Colors.black,
              BlendMode.srcIn),
        ),
        title: Text(label),
        trailing:
            GestureDetector(onTap: onTap, child: SvgPicture.asset(editSVG)),
      ),
    );
  }
}

enum UserProfileData {
  userName(svg: profileSVG),
  email(svg: emailSVG),
  password(svg: lockSVG);

  final String svg;
  const UserProfileData({required this.svg});
}
