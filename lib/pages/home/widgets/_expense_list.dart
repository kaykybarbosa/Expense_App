part of '../home_page.dart';

class _ExpenseList extends StatelessWidget {
  const _ExpenseList();

  @override
  Widget build(BuildContext context) {
    final homeStateContext = context.findAncestorStateOfType<HomePageState>()!;
    final homeController = homeStateContext.homeController;

    return Expanded(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: homeController.currentMonthExpenses.length,
        itemBuilder: (_, index) {
          final int reversedIndex = homeController.currentMonthExpenses.length - index - 1;
          final Expense expense = homeController.currentMonthExpenses[reversedIndex];

          return MyListTile(
            expense: expense,
            onEditPressed: (context) => homeStateContext._editExpense(
              expense,
              type: expense.type,
            ),
            onDeletePressed: (context) => homeStateContext._deleteExpense(
              expense.id,
              type: expense.type,
            ),
          );
        },
      ),
    );
  }
}
