import 'package:expense_app/utils/my_colors.dart';
import 'package:flutter/material.dart';

class NoExpense extends StatelessWidget {
  const NoExpense({super.key, required this.visible});

  final bool visible;

  @override
  Widget build(BuildContext context) => Visibility(
        visible: visible,
        child: Positioned(
          bottom: 40,
          left: 20,
          child: Column(
            children: [
              const Text(
                'No expenses',
                style: TextStyle(
                  fontSize: 22,
                  color: MyColors.base300,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Image.asset(
                'assets/empty_expense_.png',
                width: 350,
                height: 350,
                color: MyColors.base300,
              ),
            ],
          ),
        ),
      );
}
