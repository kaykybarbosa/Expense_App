import 'package:expense_app/app/expense_app.dart';
import 'package:expense_app/dependency_injection/app_component.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies();

  runApp(const ExpenseApp());
}
