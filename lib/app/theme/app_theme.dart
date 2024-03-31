import 'package:expense_app/app/theme/custom_theme/appbar_theme.dart';
import 'package:expense_app/app/theme/custom_theme/color_scheme_theme.dart';
import 'package:expense_app/app/theme/custom_theme/drawer_theme.dart';
import 'package:expense_app/app/theme/custom_theme/elevated_button_theme.dart';
import 'package:expense_app/app/theme/custom_theme/floating_action_button_theme.dart';
import 'package:expense_app/app/theme/custom_theme/text_theme.dart';
import 'package:expense_app/utils/my_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: EColorSchemeTheme.lightTheme,
        shadowColor: MyColors.base300.withOpacity(.2),
        appBarTheme: EAppBarTheme.lightTheme,
        textTheme: ETextTheme.lightTheme,
        floatingActionButtonTheme: EFloatingActionButtonTheme.lightTheme,
        dividerTheme: const DividerThemeData(color: MyColors.base100),
        elevatedButtonTheme: EElevatedButtonTheme.lightTheme,
        drawerTheme: EDrawerTheme.light,
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: EColorSchemeTheme.darkTheme,
        shadowColor: MyColors.base300.withOpacity(.1),
        appBarTheme: EAppBarTheme.darkTheme,
        textTheme: ETextTheme.darkTheme,
        floatingActionButtonTheme: EFloatingActionButtonTheme.darkTheme,
        dividerTheme: const DividerThemeData(color: MyColors.darkBase100),
        elevatedButtonTheme: EElevatedButtonTheme.darkTheme,
        drawerTheme: EDrawerTheme.dark,
      );
}
