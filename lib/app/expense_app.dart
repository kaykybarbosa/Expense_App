import 'package:expense_app/app/app_theme.dart';
import 'package:expense_app/pages/home_page.dart';
import 'package:flutter/material.dart';

class ExpenseApp extends StatelessWidget {
  const ExpenseApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Expense App',
        theme: AppTheme.light(context),
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
      );
}
