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
import 'package:expense_app/utils/my_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

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

  void _cancelButton() {
    Navigator.pop(context);

    nameController.clear();
    amountController.clear();
  }

  void createExpense() {
    nameController.clear();
    amountController.clear();

    customShowModalButtomSheet(
      context,
      nameController: nameController,
      amountController: amountController,
      onPressed: () {
        if (nameController.text.isNotEmpty && amountController.text.isNotEmpty) {
          Navigator.pop(context);

          Expense expense = Expense(
            name: nameController.text,
            amount: convertToDouble(amountController.text),
            date: DateTime.now(),
          );

          homeController.addExpense(expense);

          nameController.clear();
          amountController.clear();
        }
      },
    );
  }

  void editExpense(Expense expense) {
    nameController.text = expense.name;
    amountController.text = expense.amount.toString();

    customShowModalButtomSheet(
      context,
      nameController: nameController,
      amountController: amountController,
      type: ModalButtomSheetType.edit,
      onPressed: () {
        if (nameController.text.isNotEmpty || amountController.text.isNotEmpty) {
          Navigator.pop(context);

          Expense newExpense = Expense(
            name: nameController.text.isNotEmpty ? nameController.text : expense.name,
            amount: amountController.text.isNotEmpty ? convertToDouble(amountController.text) : expense.amount,
            date: DateTime.now(),
          );

          int oldId = expense.id;

          homeController.editExpense(id: oldId, expense: newExpense);

          nameController.clear();
          amountController.clear();
        }
      },
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
  Widget build(BuildContext context) => AdvancedDrawer(
        openScale: .90,
        disabledGestures: true,
        drawer: const CustomDrawer(),
        controller: drawerController,
        animationCurve: Curves.easeInOut,
        backdrop: Container(color: Theme.of(context).shadowColor),
        child: Scaffold(
          appBar: CustomAppBar(future: homeController.calculateCurrentMonthExpenses()),
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
                        future: homeController.monthlySummary(),
                        builder: (_, snapshot) {
                          // data is load
                          if (snapshot.connectionState == ConnectionState.done) {
                            return MyBarGraph(
                              monthlySummary: snapshot.data ?? [],
                              startMonth: homeController.startMonth,
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
                        itemCount: homeController.currentMonthExpenses.length,
                        itemBuilder: (_, index) {
                          var reversedIndex = homeController.currentMonthExpenses.length - index - 1;
                          var expense = homeController.currentMonthExpenses[reversedIndex];

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
                NoExpense(visible: homeController.currentMonthExpenses.isEmpty)
              ],
            ),
          ),
        ),
      );
}
