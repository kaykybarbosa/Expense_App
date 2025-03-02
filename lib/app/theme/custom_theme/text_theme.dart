import 'package:expense_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ETextTheme {
  ETextTheme._();

  static TextTheme lightTheme = TextTheme(
    bodyMedium: GoogleFonts.poppins(fontSize: Constants.defaultFontSize),
  );

  static TextTheme darkTheme = TextTheme(
    bodyMedium: GoogleFonts.poppins(fontSize: Constants.defaultFontSize),
  );
}
