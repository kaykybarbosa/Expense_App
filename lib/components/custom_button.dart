import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isDanger = false,
  });

  final String label;
  final Function onPressed;
  final bool isDanger;

  @override
  Widget build(BuildContext context) => MaterialButton(
        onPressed: () => onPressed(),
        highlightColor: isDanger ? Theme.of(context).colorScheme.errorContainer.withOpacity(.3) : null,
        child: Text(
          label,
          style: isDanger ? TextStyle(color: Theme.of(context).colorScheme.errorContainer) : null,
        ),
      );
}
