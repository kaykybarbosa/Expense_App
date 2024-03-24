import 'package:expense_app/app/routes/app_pages.dart';
import 'package:expense_app/app/theme/app_theme.dart';
import 'package:expense_app/dependency_injection/app_component.dart';
import 'package:expense_app/pages/settings/controllers/theme_controller.dart';
import 'package:flutter/material.dart';

class ExpenseApp extends StatefulWidget {
  const ExpenseApp({super.key});

  @override
  State<ExpenseApp> createState() => _ExpenseAppState();
}

class _ExpenseAppState extends State<ExpenseApp> {
  late ThemeController _themeController;

  @override
  void initState() {
    super.initState();
    _themeController = getIt<ThemeController>();
    _themeController.getThemeMode();
    _themeController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        title: 'Expense App',
        themeMode: _themeController.themeMode,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        routerConfig: AppPages.pages,
        debugShowCheckedModeBanner: false,
      );
}
