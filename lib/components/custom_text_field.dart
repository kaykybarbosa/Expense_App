import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.label,
    this.isRequiredFocus = false,
    this.focusNode,
    this.controller,
    this.keyboardType,
  });

  final String label;
  final bool isRequiredFocus;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextEditingController? controller;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    if (widget.isRequiredFocus) {
      _focusNode = FocusNode();
      _focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) => TextField(
        focusNode: widget.isRequiredFocus ? _focusNode : widget.focusNode,
        controller: widget.controller,
        decoration: InputDecoration(label: Text(widget.label)),
        keyboardType: widget.keyboardType,
      );
}
