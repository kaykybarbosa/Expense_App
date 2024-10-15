import 'package:expense_app/utils/my_colors.dart';
import 'package:flutter/material.dart';

class NoExpense extends StatelessWidget {
  const NoExpense({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Text(
          'No expenses',
          style: TextStyle(
            fontSize: 21,
            color: MyColors.base300,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        Image.asset(
          'assets/empty_expense_.png',
          width: size.width * .7,
          height: size.width * .7,
          color: MyColors.base300,
          fit: BoxFit.cover,
        ),
      ],
    );
  }
}
