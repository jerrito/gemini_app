import 'package:flutter/material.dart';

class LearningHomePage extends StatefulWidget {
  const LearningHomePage({super.key});

  @override
  State<LearningHomePage> createState() => _LearningHomePageState();
}

class _LearningHomePageState extends State<LearningHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(children: [
        Container(
          child: Text('Learning Home Page'),
        ),
        ElevatedButton(
          onPressed: () {
          },
          child: Text('Go to Details'),
        ),
        ElevatedButton(
          onPressed: () {
            // Navigate to the previous page
            Navigator.pop(context);
          },
          child: Text('Go back'),
        ),
      ],)
    );
  }
}