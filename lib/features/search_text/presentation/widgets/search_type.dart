import 'package:flutter/material.dart';
import 'package:gemini/core/size/sizes.dart';
import 'package:gemini/features/search_text/presentation/pages/search_page.dart';

class SearchTypeWidget extends StatelessWidget {
  final RequestType type;
  final int value;
  final void Function()? onTap;
  const SearchTypeWidget({
    super.key,
    this.onTap,
    required this.type,
    required this.value,
  });

  @override
  build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(
        horizontal: Sizes().width(context, 0.02),),
      child: ListTile(
        iconColor:type.value==value ? type.color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
        textColor: value==type.value ? type.color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
        leading:Icon(type.icon) ,
        onTap: onTap,
        title:  Text(type.label),
        // subtitle:  Text(subLabel ?? ""),
        
      ),
    );
  }
}
