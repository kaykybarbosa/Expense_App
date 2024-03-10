import 'package:expense_app/barGraph/my_bar_graph.dart';
import 'package:expense_app/components/my_list_tile.dart';
import 'package:expense_app/database/expense_database.dart';
import 'package:expense_app/helper/helper_functions.dart';
import 'package:expense_app/models/expense.dart';
import 'package:expense_app/utils/my_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController nameController;
  late TextEditingController amountController;

  // futures to load graph data & monthly total
  Future<Map<String, double>>? _monthlyTotalsFuture;
  Future<double>? _calculateCurrentMonthTotal;

  @override
  void initState() {
    nameController = TextEditingController();
    amountController = TextEditingController();

    getAllExpenses();
    refreshData();

    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    super.dispose();
  }

  void getAllExpenses() => {
        Provider.of<ExpenseDatabase>(
          context,
          listen: false,
        ).getAllExpenses(),
      };

  void refreshData() => {
        _monthlyTotalsFuture = Provider.of<ExpenseDatabase>(
          context,
          listen: false,
        ).calculateMonthlyTotals(),
        _calculateCurrentMonthTotal = Provider.of<ExpenseDatabase>(
          context,
          listen: false,
        ).calculateCurrentMonthExpenses(),
      };

  void createExpense() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: nameController,
              decoration: const InputDecoration(label: Text('Name')),
            ),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(label: Text('Amount')),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: <Widget>[
          _Button(
            label: 'Cancel',
            onPressed: () {
              Navigator.pop(context);

              nameController.clear();
              amountController.clear();
            },
          ),
          _Button(
            label: 'Save',
            onPressed: () {
              if (nameController.text.isNotEmpty && amountController.text.isNotEmpty) {
                Navigator.pop(context);

                Expense expense = Expense(
                  name: nameController.text,
                  amount: convertToDouble(amountController.text),
                  date: DateTime.now(),
                );

                context.read<ExpenseDatabase>().createExpense(expense);

                refreshData();

                nameController.clear();
                amountController.clear();
              }
            },
          )
        ],
      ),
    );
  }

  void editExpense(Expense expense) {
    nameController.text = expense.name;
    amountController.text = expense.amount.toString();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: nameController,
              decoration: const InputDecoration(label: Text('Name')),
            ),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(label: Text('Amount')),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: <Widget>[
          _Button(
            label: 'Cancel',
            onPressed: () {
              Navigator.pop(context);

              nameController.clear();
              amountController.clear();
            },
          ),
          _Button(
            label: 'Save',
            onPressed: () {
              if (nameController.text.isNotEmpty || amountController.text.isNotEmpty) {
                Navigator.pop(context);

                Expense newExpense = Expense(
                  name: nameController.text.isNotEmpty ? nameController.text : expense.name,
                  amount: amountController.text.isNotEmpty ? convertToDouble(amountController.text) : expense.amount,
                  date: DateTime.now(),
                );

                int oldId = expense.id;

                context.read<ExpenseDatabase>().updateExpense(id: oldId, expense: newExpense);

                refreshData();

                nameController.clear();
                amountController.clear();
              }
            },
          )
        ],
      ),
    );
  }

  void deleteExpense(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Expense?'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[],
        ),
        actions: [
          _Button(
            label: 'Cancel',
            onPressed: () {
              Navigator.pop(context);

              nameController.clear();
              amountController.clear();
            },
          ),
          _Button(
            label: 'Delete',
            onPressed: () {
              Navigator.pop(context);

              context.read<ExpenseDatabase>().deleteExpense(id: id);

              refreshData();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseDatabase>(builder: (_, value, __) {
      // get dates
      int startMonth = value.getStartMonth();
      int startYear = value.getStartYear();
      int currentMonth = DateTime.now().month;
      int currentYear = DateTime.now().year;

      // calculate the number of months since the first month
      int mountCont = calculateMonthCount(startYear, startMonth, currentYear, currentMonth);

      // only display the expense for the current month
      List<Expense> currentMonthExpenses = value.allExpense
          .where((expense) => expense.date.year == currentYear && expense.date.month == currentMonth)
          .toList();

      return Scaffold(
        appBar: AppBar(
          title: FutureBuilder(
            future: _calculateCurrentMonthTotal,
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('\$${snapshot.data!.toStringAsFixed(2)}'),
                    Text(getCurrentMonth()),
                  ],
                );
              } else {
                return const Text('Loading...');
              }
            }),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createExpense,
          child: const Icon(MyIcons.add),
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              // GRAPH BAR
              SizedBox(
                height: 250,
                child: FutureBuilder(
                  future: _monthlyTotalsFuture,
                  builder: (_, snapshot) {
                    // data is load
                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> monthlyTotals = snapshot.data ?? {};

                      // create the list monthly summary
                      List<double> monthlySummary = List.generate(
                        mountCont,
                        (index) {
                          int year = startYear + (startMonth + index - 1) ~/ 12;
                          int month = (startMonth + index - 1) % 12 + 1;

                          String yearMonthKey = '$year-$month';

                          return monthlyTotals[yearMonthKey] ?? 0.0;
                        },
                      );

                      return MyBarGraph(monthlySummary: monthlySummary, startMonth: startMonth);
                    }
                    // loading...
                    else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),

              const SizedBox(height: 25),

              // EXPENSE LIST
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: currentMonthExpenses.length,
                  itemBuilder: (_, index) {
                    var reversedIndex = currentMonthExpenses.length - index - 1;
                    var expense = currentMonthExpenses[reversedIndex];

                    return MyListTile(
                      title: expense.name,
                      trailing: formatAmount(expense.amount),
                      onEditPressed: (context) => editExpense(expense),
                      onDeletePressed: (context) => deleteExpense(expense.id),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _Button extends StatelessWidget {
  const _Button({required this.label, required this.onPressed});

  final Function onPressed;
  final String label;

  @override
  Widget build(BuildContext context) => MaterialButton(
        onPressed: () => onPressed(),
        child: Text(label),
      );
}
