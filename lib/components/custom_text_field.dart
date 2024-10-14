import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.label,
    this.isRequiredFocus = false,
    this.controller,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
  });

  final String label;
  final bool isRequiredFocus;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) => TextField(
        autofocus: isRequiredFocus,
        controller: controller,
        decoration: InputDecoration(label: Text(label)),
        keyboardType: keyboardType,
        textInputAction: textInputAction,
      );
}
