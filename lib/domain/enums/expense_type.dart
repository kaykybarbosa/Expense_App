import 'package:expense_app/utils/my_colors.dart';
import 'package:expense_app/utils/my_icons.dart';
import 'package:flutter/material.dart';

enum ExpenseType {
  income(label: 'Incomes', icon: MyIcons.arrowDown),
  expense(label: 'Expenses', icon: MyIcons.arrowDown);

  const ExpenseType({required this.label, required this.icon});

  final String label;
  final IconData icon;

  // G E T T E R S //

  bool get isIncome => this == ExpenseType.income;

  bool get isExpense => this == ExpenseType.expense;

  Color color(BuildContext context) =>
      isIncome
          ? MyColors.success
          : Theme.of(context) //
          .colorScheme.errorContainer;
}
