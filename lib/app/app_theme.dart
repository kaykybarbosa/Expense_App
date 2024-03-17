import 'package:expense_app/utils/constants.dart';
import 'package:expense_app/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData light(BuildContext context) => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: MyColors.primary,
          onPrimary: MyColors.base100,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light, // For iphone
            statusBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.transparent,
          ),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme).copyWith(
          bodyMedium: const TextStyle(fontSize: Constants.defaultFontSize),
        ),
        scaffoldBackgroundColor: MyColors.scaffoldColor,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: MyColors.base300Shade800,
          foregroundColor: MyColors.base100,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      );
}
