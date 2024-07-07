import 'package:gemini/core/size/sizes.dart';
import 'package:shimmer/shimmer.dart';
import "package:flutter/material.dart";

class HistoryShimmer extends StatelessWidget {
  const HistoryShimmer({super.key});

  final gradient = const LinearGradient(colors: [
    Color.fromARGB(66, 224, 220, 220),
    Color.fromARGB(221, 143, 141, 141),
  ]);
  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: ListView.builder(
      itemCount:10,
      itemBuilder: (context, index) {
        return Padding(
          padding:  EdgeInsets.symmetric(
            horizontal:Sizes().width(context,0.08),
            vertical:Sizes().height(context,0.01),
            ),
          child: Shimmer(
              gradient: gradient,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(66, 224, 220, 220),
                  borderRadius: BorderRadius.circular(
                    Sizes().height(context, 0.015),
                  ),
                ),
                height: Sizes().height(context, 0.03),
                width: Sizes().width(context, 0.03),
              )),
        );
      },
    ));
  }
}
