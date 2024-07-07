import 'package:flutter/material.dart';
import 'package:gemini/assets/animations/animations.dart';
import 'package:gemini/core/widgets/default_button.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class NoInternetPage extends StatelessWidget {
  const NoInternetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

        const Text("No Internet"),
        Lottie.asset(historyJson),
        DefaultButton(
          onTap: (){
            context.goNamed("connection");
          },
          label: "Retry",
        )
      ],),
    );
  }
}