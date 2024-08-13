import 'package:flutter/material.dart';
import 'package:gemini/assets/images/images.dart';
import 'package:gemini/core/widgets/default_bottom_sheet.dart';
import 'package:go_router/go_router.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset(
        defaultImage,
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      ),
      bottomSheet: DefaultBottomSheet(onTap: () {
        context.pushNamed("phone", queryParameters: {
          "isSignup": "false",
        });
      }, onTap2: () {
        context.pushNamed("phone", queryParameters: {
          "isSignup": "true",
        });
      }),
    );
  }
}
