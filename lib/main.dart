import 'package:expense_app/app/expense_app.dart';
import 'package:expense_app/pages/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'database/expense_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ExpenseDatabase.initialize();

  runApp(
    ChangeNotifierProvider(
      create: (_) => HomeController(),
      child: const ExpenseApp(),
    ),
  );
}
