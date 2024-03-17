import 'package:expense_app/barGraph/my_bar_graph.dart';
import 'package:expense_app/components/my_list_tile.dart';
import 'package:expense_app/components/no_expense.dart';
import 'package:expense_app/helper/helper_functions.dart';
import 'package:expense_app/models/expense.dart';
import 'package:expense_app/pages/home_controller.dart';
import 'package:expense_app/utils/my_icons.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController nameController;
  late TextEditingController amountController;

  late HomeController _homeController;

  @override
  void initState() {
    nameController = TextEditingController();
    amountController = TextEditingController();

    _homeController = HomeController();
    _homeController.getAllExpenses();
    _homeController.addListener(() => setState(() {}));

    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    super.dispose();
  }

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

                _homeController.addExpense(expense);

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

                _homeController.editExpense(id: oldId, expense: newExpense);

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

              _homeController.deleteExpense(id);
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: FutureBuilder(
              future: _homeController.calculateCurrentMonthExpenses(),
              builder: (_, snapshot) {
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
        floatingActionButton: FloatingActionButton(
          onPressed: createExpense,
          child: const Icon(MyIcons.add),
        ),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  // GRAPH BAR
                  SizedBox(
                    height: 250,
                    child: FutureBuilder(
                      future: _homeController.monthlySummary(),
                      builder: (_, snapshot) {
                        // data is load
                        if (snapshot.connectionState == ConnectionState.done) {
                          return MyBarGraph(
                            monthlySummary: snapshot.data ?? [],
                            startMonth: _homeController.startMonth,
                          );
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
                      itemCount: _homeController.currentMonthExpenses.length,
                      itemBuilder: (_, index) {
                        var reversedIndex = _homeController.currentMonthExpenses.length - index - 1;
                        var expense = _homeController.currentMonthExpenses[reversedIndex];

                        return MyListTile(
                          expense: expense,
                          onEditPressed: (context) => editExpense(expense),
                          onDeletePressed: (context) => deleteExpense(expense.id),
                        );
                      },
                    ),
                  ),
                ],
              ),
              NoExpense(visible: _homeController.currentMonthExpenses.isEmpty)
            ],
          ),
        ),
      );
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
