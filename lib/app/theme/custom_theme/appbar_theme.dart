import 'package:expense_app/utils/constants.dart';
import 'package:expense_app/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EAppBarTheme {
  EAppBarTheme._();

  static AppBarTheme lightTheme = AppBarTheme(
    scrolledUnderElevation: 0,
    titleTextStyle: TextStyle(
      fontSize: Constants.largeFontSize,
      color: MyColors.primary,
    ),
    backgroundColor: Colors.transparent,
    systemOverlayStyle:  SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light, // For iphone
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: MyColors.base300Shade200,
    ),
  );

  static AppBarTheme darkTheme = AppBarTheme(
    scrolledUnderElevation: 0,
    titleTextStyle: TextStyle(
      fontSize: Constants.largeFontSize,
      color: MyColors.darkPrimary,
    ),
    backgroundColor: Colors.transparent,
    systemOverlayStyle:  SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark, // For iphone
      statusBarIconBrightness: Brightness.light,
      statusBarColor: MyColors.base300Shade800,
    ),
  );
}
