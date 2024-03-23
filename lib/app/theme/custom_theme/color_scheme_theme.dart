import 'package:expense_app/utils/my_colors.dart';
import 'package:flutter/material.dart';

class EColorSchemeTheme {
  EColorSchemeTheme._();

  static ColorScheme lightTheme = ColorScheme.light(
    primary: MyColors.primary,
    onPrimary: MyColors.base100,
    background: MyColors.scaffoldColor,
    primaryContainer: MyColors.base300Shade200,
    secondaryContainer: MyColors.base300Shade800,
    onSecondaryContainer: MyColors.base300,
    errorContainer: MyColors.alert,
  );

  static ColorScheme darkTheme = ColorScheme.dark(
    primary: MyColors.darkPrimary,
    onPrimary: MyColors.darkBase100,
    background: MyColors.darkScaffoldColor,
    primaryContainer: MyColors.base300Shade800,
    secondaryContainer: MyColors.base300Shade200,
    onSecondaryContainer: MyColors.base300,
    errorContainer: MyColors.darkAlert,
  );
}
