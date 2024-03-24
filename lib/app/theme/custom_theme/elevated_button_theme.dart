import 'package:expense_app/utils/constants.dart';
import 'package:expense_app/utils/my_colors.dart';
import 'package:flutter/material.dart';

class EElevatedButtonTheme {
  EElevatedButtonTheme._();

  static ElevatedButtonThemeData lightTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: MyColors.base300Shade800,
      foregroundColor: MyColors.base100,
      padding: const EdgeInsets.symmetric(vertical: 15),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(Constants.borderRadius)),
      ),
    ),
  );

  static ElevatedButtonThemeData darkTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: MyColors.base300Shade200,
      foregroundColor: MyColors.darkBase100,
      padding: const EdgeInsets.symmetric(vertical: 15),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(Constants.borderRadius)),
      ),
    ),
  );
}
