import 'package:expense_app/utils/my_colors.dart';
import 'package:flutter/material.dart';

class EDrawerTheme {
  EDrawerTheme._();

  static DrawerThemeData light = DrawerThemeData(
    elevation: 0,
    backgroundColor: MyColors.scaffoldColor,
  );

  static DrawerThemeData dark = DrawerThemeData(
    elevation: 0,
    backgroundColor: MyColors.darkScaffoldColor,
  );
}
