import 'package:expense_app/domain/enums/expense_type.dart';
import 'package:expense_app/ui/pages/home/home_page.dart';
import 'package:expense_app/utils/constants.dart';
import 'package:expense_app/utils/helper_functions.dart';
import 'package:expense_app/utils/my_colors.dart';
import 'package:expense_app/utils/my_icons.dart';
import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key, this.incomesFuture, this.expensesFuture});

  final Future<double?>? incomesFuture;
  final Future<double?>? expensesFuture;

  @override
  Widget build(BuildContext context) {
    final homeContext = context.findAncestorStateOfType<HomePageState>()!;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Constants.defaultMargin),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // AppBar
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  // -- Icon
                  InkWell(
                    onTap: () => homeContext.drawerController.showDrawer(),
                    child: const Icon(MyIcons.menu, size: 28),
                  ),

                  // -- Current month
                  Expanded(
                    child: Center(
                      child: Text(
                        getCurrentMonth(),
                        style: const TextStyle(
                          fontSize: Constants.defaultFontSize + 4,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 22),
                ],
              ),
            ),

            /// Incomes and Expenses
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Row(
                spacing: 10,
                children: <Widget>[
                  /// Incomes
                  Expanded(
                    child: FutureBuilder(
                      future: incomesFuture,
                      builder: (_, snapshot) {
                        String? total;

                        if (snapshot.connectionState == ConnectionState.done) {
                          total = formatAmount(snapshot.data ?? 0);
                        } else {
                          total = '...';
                        }

                        return _DetailsExpense(type: ExpenseType.income, total: total);
                      },
                    ),
                  ),

                  /// Expenses
                  Expanded(
                    child: FutureBuilder(
                      future: expensesFuture,
                      builder: (_, snapshot) {
                        String? total;

                        if (snapshot.connectionState == ConnectionState.done) {
                          total = formatAmount(snapshot.data ?? 0);
                        } else {
                          total = '...';
                        }

                        return _DetailsExpense(type: ExpenseType.expense, total: total);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailsExpense extends StatelessWidget {
  const _DetailsExpense({required this.type, this.total});

  final ExpenseType type;
  final String? total;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // icon
        Container(
          decoration: BoxDecoration(
            color: type.color(context),
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.all(6),
          child: Icon(type.icon, color: MyColors.base100),
        ),
        // label
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                type.label,
                style: const TextStyle(
                  color: MyColors.base300,
                  fontSize: Constants.defaultFontSize - 1,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                total ?? '0,00',
                style: TextStyle(
                  color: type.color(context),
                  fontSize: Constants.defaultFontSize + 2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
