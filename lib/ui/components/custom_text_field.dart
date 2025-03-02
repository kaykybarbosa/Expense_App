import 'package:expense_app/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.label,
    this.hintText,
    this.isRequiredFocus = false,
    this.controller,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatter,
    this.prefix,
    this.suffixIcon,
  });

  final String label;
  final String? hintText;
  final bool isRequiredFocus;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final TextInputFormatter? inputFormatter;
  final Widget? prefix;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) => TextField(
    autofocus: isRequiredFocus,
    controller: controller,
    decoration: InputDecoration(
      label: Text(label),
      prefix: prefix,
      suffixIcon: suffixIcon,
      hintText: hintText,
      hintStyle: TextStyle(color: MyColors.base300),
    ),
    keyboardType: keyboardType,
    textInputAction: textInputAction,
    textCapitalization: textCapitalization,
    inputFormatters: inputFormatter != null ? [inputFormatter!] : [],
  );
}
