import 'package:expense_app/data/extensions/date_time_extension.dart';
import 'package:expense_app/data/extensions/double_extension.dart';
import 'package:expense_app/data/extensions/string_extension.dart';
import 'package:expense_app/domain/models/expense.dart';
import 'package:expense_app/ui/components/barGraph/my_bar_graph.dart';
import 'package:expense_app/ui/components/custom_button.dart';
import 'package:expense_app/ui/components/my_list_tile.dart';
import 'package:expense_app/ui/components/no_expense.dart';
import 'package:expense_app/ui/pages/home/home_controller.dart';
import 'package:expense_app/ui/pages/home/widgets/custom_appbar.dart';
import 'package:expense_app/ui/pages/home/widgets/custom_drawer.dart';
import 'package:expense_app/ui/pages/home/widgets/custom_show_modal_bottom_sheet.dart';
import 'package:expense_app/utils/my_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

part 'widgets/_actions_button.dart';
part 'widgets/_expense_list.dart';
part 'widgets/_graphic.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late final TextEditingController nameController;
  late final TextEditingController amountController;
  late final TextEditingController dateController;
  late final AdvancedDrawerController drawerController;

  late final HomeController homeController;

  @override
  void initState() {
    _initFormController();

    drawerController = AdvancedDrawerController();

    _initHomeController();

    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    dateController.dispose();
    drawerController.dispose();
    super.dispose();
  }

  void _initFormController() {
    nameController = TextEditingController();
    amountController = TextEditingController();
    dateController = TextEditingController();
  }

  void _initHomeController() {
    homeController = HomeController.instance;
    homeController.getAllExpenses();

    /// TODO: Refatorar reatividade da interface.
    homeController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _cleanFormControllers() {
    nameController.clear();
    amountController.clear();
    dateController.clear();
  }

  void _createExpense({ExpenseType? type}) {
    _cleanFormControllers();

    customShowModalButtomSheet(
      context,
      expenseType: type,
      nameController: nameController,
      amountController: amountController,
      dateController: dateController,
      onPressed: () {
        if (nameController.text.isNotEmpty && amountController.text.isNotEmpty) {
          Navigator.pop(context);

          Expense expense = Expense(
            name: nameController.text,
            amount: amountController.text.unformatMoney,
            date: dateController.text.tryParse ?? DateTime.now(),
            typeIndex: type?.index ?? ExpenseType.expense.index,
          );

          homeController.addExpense(expense);

          _cleanFormControllers();
        }
      },
    );
  }

  void _editExpense(Expense expense, {ExpenseType? type}) {
    nameController.text = expense.name;
    amountController.text = expense.amount.formatMoney;
    dateController.text = expense.date.formatDate;

    customShowModalButtomSheet(
      context,
      nameController: nameController,
      amountController: amountController,
      dateController: dateController,
      buttomSheetType: ModalButtomSheetType.edit,
      expenseType: type,
      onPressed: () {
        if (nameController.text.isNotEmpty || amountController.text.isNotEmpty) {
          Navigator.pop(context);

          Expense newExpense = Expense(
            name: nameController.text.isNotEmpty ? nameController.text : expense.name,
            amount:
                amountController.text.isNotEmpty
                    ? amountController.text.unformatMoney
                    : expense.amount,
            date:
                dateController.text.isNotEmpty
                    ? (dateController.text.tryParse ?? expense.date)
                    : expense.date,
            typeIndex: expense.type.index,
          );

          homeController.editExpense(id: expense.id, expense: newExpense);

          _cleanFormControllers();
        }
      },
    );
  }

  void _deleteExpense(int id, {required ExpenseType type}) {
    final String typeName = type.isIncome ? 'Income' : 'Expense';

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Delete $typeName?'),
            content: const Column(mainAxisSize: MainAxisSize.min, children: <Widget>[]),
            actions: <Widget>[
              CustomButton(
                label: 'Cancel',
                onPressed: () => {Navigator.pop(context), _cleanFormControllers()},
              ),
              CustomButton(
                isDanger: true,
                label: 'Delete',
                onPressed:
                    () => {Navigator.pop(context), homeController.deleteExpense(id)},
              ),
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
      floatingActionButton: const _ActionsButton(),
      body: SafeArea(
        child:
            homeController.currentMonthExpenses.isNotEmpty
                ? _Body(child: _ExpenseList())
                : SingleChildScrollView(child: _Body(child: NoExpense())),
      ),
    ),
  );
}

class _Body extends StatelessWidget {
  const _Body({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final homeController =
        context.findAncestorStateOfType<HomePageState>()!.homeController;

    return Column(
      spacing: 15,
      children: <Widget>[
        // Appbar
        CustomAppbar(
          subTotalIncomes: homeController.calculateCurrentMonthExpenses(
            type: ExpenseType.income,
          ),
          subTotalExpenses: homeController.calculateCurrentMonthExpenses(
            type: ExpenseType.expense,
          ),
        ),

        // Bar graph
        _Graphic(),

        const SizedBox(height: 10),

        // Child
        child,
      ],
    );
  }
}
