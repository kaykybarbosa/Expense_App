import 'package:expense_app/utils/my_colors.dart';
import 'package:flutter/material.dart';

class EFloatingActionButtonTheme {
  EFloatingActionButtonTheme._();

  static FloatingActionButtonThemeData lightTheme = FloatingActionButtonThemeData(
    backgroundColor: MyColors.base300Shade800,
    foregroundColor: MyColors.base100,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  );

  static FloatingActionButtonThemeData darkTheme = FloatingActionButtonThemeData(
    backgroundColor: MyColors.base300Shade200,
    foregroundColor: MyColors.darkBase100,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  );
}
