import 'package:expense_app/components/barGraph/my_bar_graph.dart';
import 'package:expense_app/components/custom_button.dart';
import 'package:expense_app/components/my_list_tile.dart';
import 'package:expense_app/components/no_expense.dart';
import 'package:expense_app/dependency_injection/app_component.dart';
import 'package:expense_app/domain/models/expense.dart';
import 'package:expense_app/helper/helper_functions.dart';
import 'package:expense_app/pages/home/home_controller.dart';
import 'package:expense_app/pages/home/widgets/custom_appbar.dart';
import 'package:expense_app/pages/home/widgets/custom_drawer.dart';
import 'package:expense_app/pages/home/widgets/custom_show_modal_bottom_sheet.dart';
import 'package:expense_app/utils/my_colors.dart';
import 'package:expense_app/utils/my_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

part 'widgets/_actions_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late TextEditingController nameController;
  late TextEditingController amountController;
  late final AdvancedDrawerController drawerController;

  late HomeController homeController;

  void _cancelButton() {
    Navigator.pop(context);

    nameController.clear();
    amountController.clear();
  }

  void _createExpense({ExpenseType? type}) {
    nameController.clear();
    amountController.clear();

    customShowModalButtomSheet(
      context,
      expenseType: type,
      nameController: nameController,
      amountController: amountController,
      onPressed: () {
        if (nameController.text.isNotEmpty && amountController.text.isNotEmpty) {
          Navigator.pop(context);

          Expense expense = Expense(
            name: nameController.text,
            amount: convertToDouble(amountController.text),
            date: DateTime.now(),
            type: type,
          );

          homeController.addExpense(expense);

          nameController.clear();
          amountController.clear();
        }
      },
    );
  }

  void _editExpense(Expense expense, {ExpenseType? type}) {
    nameController.text = expense.name;
    amountController.text = expense.amount.toString();

    customShowModalButtomSheet(
      context,
      nameController: nameController,
      amountController: amountController,
      buttomSheetType: ModalButtomSheetType.edit,
      expenseType: type,
      onPressed: () {
        if (nameController.text.isNotEmpty || amountController.text.isNotEmpty) {
          Navigator.pop(context);

          Expense newExpense = Expense(
            name: nameController.text.isNotEmpty ? nameController.text : expense.name,
            amount: amountController.text.isNotEmpty ? convertToDouble(amountController.text) : expense.amount,
            date: expense.date,
          );

          int oldId = expense.id;

          homeController.editExpense(id: oldId, expense: newExpense);

          nameController.clear();
          amountController.clear();
        }
      },
    );
  }

  void _deleteExpense(int id, {required ExpenseType type}) {
    final String typeName = type.isIncome ? 'Income' : 'Expense';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete $typeName?'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[],
        ),
        actions: [
          CustomButton(
            label: 'Cancel',
            onPressed: () => _cancelButton(),
          ),
          CustomButton(
            isDanger: true,
            label: 'Delete',
            onPressed: () {
              Navigator.pop(context);

              homeController.deleteExpense(id);
            },
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    nameController = TextEditingController();
    amountController = TextEditingController();
    drawerController = AdvancedDrawerController();

    homeController = getIt<HomeController>();
    homeController.getAllExpenses();
    homeController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    drawerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).colorScheme.primaryContainer,
        ),
        child: AdvancedDrawer(
          openScale: .90,
          disabledGestures: true,
          drawer: const CustomDrawer(),
          controller: drawerController,
          animationCurve: Curves.easeInOut,
          backdrop: Container(color: Theme.of(context).shadowColor),
          child: Scaffold(
            floatingActionButton: const _ActionsButton(),
            body: SafeArea(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      // Appbar
                      CustomAppbar(
                        incomesFuture: homeController.calculateCurrentMonthExpenses(type: ExpenseType.income),
                        expensesFuture: homeController.calculateCurrentMonthExpenses(type: ExpenseType.expense),
                      ),

                      const SizedBox(height: 15),

                      // Graph bar
                      if (homeController.currentMonthExpenses.isNotEmpty)
                        SizedBox(
                          height: 250,
                          child: FutureBuilder(
                            future: homeController.monthlySummary(type: ExpenseType.expense),
                            builder: (_, snapshot) {
                              // -- data loaded
                              if (snapshot.connectionState == ConnectionState.done) {
                                return MyBarGraph(
                                  monthlySummary: snapshot.data!,
                                  startMonth: homeController.startMonth,
                                );
                              }
                              // -- loading...
                              else {
                                return const Center(child: CircularProgressIndicator());
                              }
                            },
                          ),
                        ),

                      const SizedBox(height: 25),

                      // Expense list
                      Expanded(
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: homeController.currentMonthExpenses.length,
                          itemBuilder: (_, index) {
                            final int reversedIndex = homeController.currentMonthExpenses.length - index - 1;
                            final Expense expense = homeController.currentMonthExpenses[reversedIndex];

                            return MyListTile(
                              expense: expense,
                              onEditPressed: (context) => _editExpense(
                                expense,
                                type: expense.type,
                              ),
                              onDeletePressed: (context) => _deleteExpense(
                                expense.id,
                                type: expense.type,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  /// No expenses image
                  NoExpense(visible: homeController.currentMonthExpenses.isEmpty),
                ],
              ),
            ),
          ),
        ),
      );
}
