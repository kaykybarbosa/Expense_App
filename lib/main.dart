import 'package:expense_app/pages/home_page.dart';
import 'package:expense_app/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'database/expense_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ExpenseDatabase.initialize();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ExpenseDatabase(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Expense App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent),
          scaffoldBackgroundColor: MyColors.scaffoldColor,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: MyColors.base300Shade800,
            foregroundColor: MyColors.base100,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
      );
}
