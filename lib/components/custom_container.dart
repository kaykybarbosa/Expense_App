import 'package:expense_app/utils/constants.dart';
import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(vertical: 10),
    this.margin = const EdgeInsets.symmetric(horizontal: Constants.defaultMargin),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(Constants.borderRadius),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: theme.shadowColor,
            blurRadius: 5,
          )
        ],
      ),
      child: child,
    );
  }
}
