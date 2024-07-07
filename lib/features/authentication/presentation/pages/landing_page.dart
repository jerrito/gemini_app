import 'package:flutter/material.dart';
import 'package:gemini/core/size/sizes.dart';
import 'package:gemini/core/spacing/whitspacing.dart';
import 'package:gemini/core/widgets/default_button.dart';
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

      body: Padding(
        padding:  EdgeInsets.symmetric(
          horizontal: Sizes().width(context, 0.04)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            DefaultButton(
              onTap: (){
                Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SigninPage()),
            );
              },
              label: "Signin",
            ),
            
            Space().height(context,0.02),

            DefaultButton(
              onTap: (){
                Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignupPage()),
            );
              },
              label: "Signup",
            ),
          ],
        ),
      ),
    );
  }
}