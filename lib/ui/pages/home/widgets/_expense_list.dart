part of '../home_page.dart';

class _ExpenseList extends StatefulWidget {
  const _ExpenseList();

  @override
  State<_ExpenseList> createState() => _ExpenseListState();
}

class _ExpenseListState extends State<_ExpenseList> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeStateContext = context.findAncestorStateOfType<HomePageState>()!;
    final homeController = homeStateContext.homeController;

    return Expanded(
      child: Scrollbar(
        controller: _scrollController,
        child: ListView.builder(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          itemCount: homeController.currentMonthExpenses.length,
          itemBuilder: (_, index) {
            final int reversedIndex =
                homeController.currentMonthExpenses.length - index - 1;
            final Expense expense = homeController.currentMonthExpenses[reversedIndex];

            return MyListTile(
              expense: expense,
              onEditPressed:
                  (context) => homeStateContext._editExpense(expense, type: expense.type),
              onDeletePressed:
                  (context) =>
                      homeStateContext._deleteExpense(expense.id, type: expense.type),
            );
          },
        ),
      ),
    );
  }
}
