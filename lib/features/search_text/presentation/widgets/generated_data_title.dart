import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gemini/core/size/sizes.dart';
import 'package:gemini/core/spacing/whitspacing.dart';

class GeneratedDataTitle extends StatelessWidget {
  final String? title, imageUrl;
  final void Function()? onTap, onLongPress;
  final void Function(bool?)? onChanged;
  final bool? value, canDelete, hasImage;

  const GeneratedDataTitle(
      {super.key,
      this.title,
      this.onTap,
      this.onChanged,
      this.value,
      this.canDelete,
      this.hasImage,
      this.imageUrl,
      this.onLongPress});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
        onLongPress: onLongPress,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: Sizes().height(context, 0.005),
            horizontal: Sizes().width(context, 0.02),
          ),
          child: Container(
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(Sizes().height(context, 0.01)),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black
                      : Colors.black12),
              padding: EdgeInsets.symmetric(
                vertical: Sizes().height(context, 0.01),
                horizontal: Sizes().width(context, 0.02),
              ),
              child: (canDelete ?? false)
                  ? CheckboxListTile(
                      checkColor: Colors.white,
                      activeColor: Colors.red,
                      side: BorderSide(
                          color: (value ?? true)
                              ? Colors.white
                              : theme.brightness == Brightness.light
                                  ? Colors.black
                                  : Colors.white54),
                      value: value,
                      onChanged: onChanged,
                      title: Text(
                          style:
                              const TextStyle(fontSize: 16, letterSpacing: 1.2),
                          (title!.length >= 30)
                              ? "${title!.substring(0, 30)}..."
                              : (title ?? "")),
                    )
                  : GestureDetector(
                      onTap: onTap,
                      child: Wrap(
                        children: [
                          Text(
                              style: const TextStyle(
                                  fontSize: 16, letterSpacing: 1.2),
                              (title!.length >= 50)
                                  ? "${title!.substring(0, 50)}..."
                                  : (title ?? "")),
                          Space().width(context, 0.01),
                          (hasImage ?? false)
                              ? Container(
                                  width: Sizes().width(context, 0.09),
                                  height: Sizes().height(context, 0.045),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: Sizes().width(context, 0.005),
                                    vertical: Sizes().height(context, 0.05),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            imageUrl!),
                                        fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                )
                              : const SizedBox()
                        ],
                      ),
                    )),
        ));
  }
}
