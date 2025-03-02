part of '../home_page.dart';

class _ActionsButton extends StatelessWidget {
  const _ActionsButton();

  @override
  Widget build(BuildContext context) {
    final homeContext = context.findAncestorStateOfType<HomePageState>()!;

    return SpeedDial(
      icon: MyIcons.add,
      children: <SpeedDialChild>[
        SpeedDialChild(
          onTap: () => homeContext._createExpense(type: ExpenseType.income),
          child: Icon(MyIcons.trendingUp, color: ExpenseType.income.color(context)),
          label: 'Income',
        ),
        SpeedDialChild(
          onTap: homeContext._createExpense,
          child: Icon(MyIcons.trendingDown, color: ExpenseType.expense.color(context)),
          label: 'Expense',
        ),
      ],
    );
  }
}
