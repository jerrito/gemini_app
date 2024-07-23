import 'package:flutter/material.dart';
import 'package:gemini/core/size/sizes.dart';
import 'package:gemini/core/spacing/whitspacing.dart';
import 'package:gemini/core/widgets/default_button.dart';

class DefaultBottomSheet extends StatelessWidget {
  final VoidCallback? onTap, onTap2;
  final String? label;
  final Widget? profileWidget; 
  final bool? isLandingPage;
  const DefaultBottomSheet({
    super.key,
    this.onTap,
    this.label,
    this.isLandingPage,
    this.onTap2,
    this.profileWidget,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Sizes().height(context, 0.2),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Sizes().width(context, 0.04)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DefaultButton(
              onTap: onTap,
              label: label ?? "Signin",
            ),
            Space().height(context, 0.02),
            (isLandingPage ?? true)
                ? DefaultButton(
                    onTap: onTap2,
                    label: "Signup",
                  )
                : profileWidget!
          ],
        ),
      ),
    );
  }
}
