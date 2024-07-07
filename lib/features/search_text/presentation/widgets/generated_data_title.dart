import 'package:flutter/material.dart';
import 'package:gemini/core/size/sizes.dart';

class GeneratedDataTitle extends StatefulWidget {
  final String? title;
  final void Function()? onTap, onLongPress;
  final void Function(bool?)? onChanged;
  final bool? value, canDelete;

  const GeneratedDataTitle(
      {super.key,
      this.title,
      this.onTap,
      this.onChanged,
      this.value,
      this.canDelete,
      this.onLongPress});

  @override
  State<GeneratedDataTitle> createState() => _GeneratedDataTitleState();
}

class _GeneratedDataTitleState extends State<GeneratedDataTitle> {
  bool? myValue;
  @override
  void initState() {
    myValue = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
        onLongPress: widget.onLongPress,
        onTap: widget.onTap,
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
              child: (widget.canDelete ?? false)
                  ? CheckboxListTile(
                      checkColor: Colors.white,
                      activeColor: Colors.red,
                      side: BorderSide(
                          color: (widget.value ?? true)
                              ? Colors.white
                              : theme.brightness == Brightness.light
                                  ? Colors.black
                                  : Colors.white54),
                      value: widget.value,
                      onChanged: widget.onChanged,
                      title: Text(
                          style:
                              const TextStyle(fontSize: 16, letterSpacing: 1.2),
                          (widget.title!.length >= 30)
                              ? widget.title!.substring(30)
                              : (widget.title ?? "")),
                    )
                  : Text(
                      style: const TextStyle(fontSize: 16, letterSpacing: 1.2),
                      widget.title ?? "")),
        ));
  }
}
