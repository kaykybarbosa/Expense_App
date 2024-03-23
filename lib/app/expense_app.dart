import 'package:expense_app/app/routes/app_pages.dart';
import 'package:expense_app/app/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ExpenseApp extends StatelessWidget {
  const ExpenseApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        title: 'Expense App',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        debugShowCheckedModeBanner: false,
        routerConfig: AppPages.pages,
      );
}
