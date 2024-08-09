// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:gemini/core/size/sizes.dart';
import 'package:gemini/core/spacing/whitspacing.dart';

class SearchTextfield extends StatefulWidget {
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final void Function()? onTap;
  final void Function()? onPressed;
  final TextEditingController? controller;
  final String? hintText, initialValue, errorText;
  final double? height;
  final Uint8List? byte;
  final bool? enabled, isAdded;
  final bool isTextAndImage;
  final TextInputType? textInputType;
  const SearchTextfield({
    super.key,
    this.onChanged,
    this.controller,
    this.hintText,
    this.textInputType,
    this.errorText,
    this.height,
    this.initialValue,
    this.enabled,
    this.isAdded,
    required this.isTextAndImage,
    this.onTap,
    this.onPressed,
    this.validator,
    this.byte,
  });

  @override
  State<SearchTextfield> createState() => _SearchTextfieldState();
}

class _SearchTextfieldState extends State<SearchTextfield> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: widget.validator,
        initialValue: widget.initialValue,
        keyboardType: widget.textInputType,
        controller: widget.controller,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          prefixIcon: widget.isTextAndImage
              ? GestureDetector(
                  onTap: widget.onTap,
                  child: Icon(Icons.file_upload,
                      size: Sizes().height(context, 0.03)))
              : (widget.isAdded ?? false)
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Sizes().width(context, 0.01),
                          vertical: Sizes().height(context, 0.007)),
                      child: Container(
                        width: Sizes().width(context, 0.09),
                        height: Sizes().height(context, 0.045),
                        padding: EdgeInsets.symmetric(
                          horizontal: Sizes().width(context, 0.005),
                          vertical: Sizes().height(context, 0.05),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          image: DecorationImage(
                              image: Image.memory(widget.byte!).image,
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Sizes().width(context, 0.015),
                        vertical: Sizes().height(context, 0.015),
                      ),
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
          suffixIcon: GestureDetector(
              onTap: widget.onPressed,
              child: (widget.enabled ?? true)
                  ? Icon(Icons.send, size: Sizes().height(context, 0.03))
                  : const SizedBox()),
          isDense: true,
          errorText: widget.errorText,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Sizes().height(context, 0.04)),
            borderSide: BorderSide(
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color.fromARGB(255, 233, 225, 225)
                  : const Color.fromARGB(255, 18, 17, 17),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Sizes().height(context, 0.04)),
            borderSide: BorderSide(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Sizes().height(context, 0.04)),
            borderSide: BorderSide(
                color: theme.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Sizes().height(context, 0.04)),
            borderSide: BorderSide(
                color: theme.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black),
          ),
        ));
  }
}

class DefaultTextFieldForm extends StatefulWidget {
  final void Function(String?)? onChanged;
  final void Function(PointerDownEvent)? onTapOutSide;
  final String Function(String?)? validator;
  final TextEditingController? controller;
  final String? hintText, initialValue, errorText, label;
  final double? height;
  final bool? obscureText, isPassword, enabled;
  final Widget? suffixIcon;
  final TextInputType? textInputType;
  final FocusNode? focusNode;
  const DefaultTextFieldForm({
    super.key,
    this.onChanged,
    this.controller,
    this.hintText,
    this.obscureText,
    this.isPassword,
    this.suffixIcon,
    this.enabled = false,
    this.errorText,
    this.label,
    this.height,
    this.textInputType,
    this.focusNode,
    this.onTapOutSide,
    this.initialValue,
    this.validator,
  });

  @override
  State<DefaultTextFieldForm> createState() => _DefaultTextFieldFormState();
}

class _DefaultTextFieldFormState extends State<DefaultTextFieldForm> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label ?? ""),
        Space().height(context, 0.006),
        TextFormField(
          enabled: widget.enabled,
          validator: widget.validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: widget.obscureText ?? false,
          focusNode: widget.focusNode,
          initialValue: widget.initialValue,
          keyboardType: widget.textInputType,
          controller: widget.controller,
          onChanged: widget.onChanged,
          // onTapOutside: FocusManager().primaryFocus?.parent!.unfocus(disposition: ),
          decoration: InputDecoration(
            suffixIcon: (widget.isPassword ?? false)
                ? widget.suffixIcon
                : const SizedBox(),
            // isDense: true,
            errorText: widget.errorText,
            contentPadding: EdgeInsets.symmetric(
                horizontal: Sizes().height(context, 0.01), vertical: 1),
            hintText: widget.hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            //label: Text(label!),
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(Sizes().height(context, 0.04)),
              borderSide: BorderSide(
                  color: theme.brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black26),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(Sizes().height(context, 0.04)),
              borderSide: BorderSide(
                  color: theme.brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black26),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(Sizes().height(context, 0.04)),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
        ),
        Space().height(context, 0.02)
      ],
    );
  }
}
