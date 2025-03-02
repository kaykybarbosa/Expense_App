import 'package:flutter/material.dart';

class MyColors {
  MyColors._();

  // L I G H T - M O D E

  static Color primary = const Color(0xFF000000);
  static Color scaffoldColor = Colors.grey.shade300;

  static const Color base100 = Colors.white;
  static const Color base300 = Colors.grey;
  static Color base300Shade200 = Colors.grey.shade200;
  static Color base300Shade800 = Colors.grey.shade800;

  static Color alert = Colors.red;

  // D A R K - M O D E

  static const Color darkPrimary = Color(0xFFFFFFFF);
  static Color darkScaffoldColor = Colors.grey.shade900;

  static const Color darkBase100 = Colors.black;

  static const Color darkAlert = Color.fromARGB(218, 244, 55, 41);

  // A P P

  static const Color success = Color(0xFF4fc951);
  static const Color warn = Color(0xFFE0252B);
}
