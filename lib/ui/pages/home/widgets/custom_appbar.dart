import 'package:expense_app/data/extensions/double_extension.dart';
import 'package:expense_app/ui/pages/home/home_controller.dart';
import 'package:expense_app/ui/pages/home/home_page.dart';
import 'package:expense_app/utils/constants.dart';
import 'package:expense_app/utils/helper_functions.dart';
import 'package:expense_app/utils/my_colors.dart';
import 'package:expense_app/utils/my_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({
    super.key,
    required this.subTotalIncomes,
    required this.subTotalExpenses,
  });

  final double subTotalIncomes;
  final double subTotalExpenses;

  @override
  Widget build(BuildContext context) {
    final drawerController =
        context.findAncestorStateOfType<HomePageState>()!.drawerController;

    final homeController =
        context.findAncestorStateOfType<HomePageState>()!.homeController;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Constants.defaultMargin),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // AppBar
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // -- Icon
                Tooltip(
                  message: 'Menu',
                  child: InkWell(
                    onTap: drawerController.showDrawer,
                    child: const Icon(MyIcons.menu, size: 28),
                  ),
                ),

                // -- Current month
                Text(
                  getCurrentMonth(),
                  style: const TextStyle(
                    fontSize: Constants.defaultFontSize + 4,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                // -- Export excel
                Consumer<HomeController>(
                  builder: (_, _, _) {
                    final bool expensesIsNotEmpty = homeController.expenses.isNotEmpty;

                    return Tooltip(
                      message:
                          expensesIsNotEmpty ? 'Expense report' : 'No expenses recorded',
                      child: InkWell(
                        onTap: expensesIsNotEmpty ? homeController.expenseReport : null,
                        child:
                            homeController.expenseReportLoading
                                ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(),
                                )
                                : Icon(
                                  MyIcons.excel,
                                  size: 24,
                                  color:
                                      homeController.expenses.isEmpty
                                          ? MyColors.base300
                                          : null,
                                ),
                      ),
                    );
                  },
                ),
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
                  child: _DetailsExpense(
                    type: ExpenseType.income,
                    total: subTotalIncomes.formatAmount,
                  ),
                ),

                /// Expenses
                Expanded(
                  child: _DetailsExpense(
                    type: ExpenseType.expense,
                    total: subTotalExpenses.formatAmount,
                  ),
                ),
              ],
            ),
          ),
        ],
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
