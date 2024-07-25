import 'package:flutter/material.dart';
import 'package:gemini/assets/images/images.dart';
import 'package:gemini/core/widgets/default_bottom_sheet.dart';
import 'package:gemini/features/authentication/presentation/pages/signin_page.dart';
import 'package:gemini/features/authentication/presentation/pages/signup_page.dart';

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
      bottomSheet:DefaultBottomSheet(
        onTap:  () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SigninPage()),
                  );
                },
          onTap2:() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignupPage()),
                  );
                }      
      )
    );
  }
}
