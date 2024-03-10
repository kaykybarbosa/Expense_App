import 'package:expense_app/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class ExpenseDatabase extends ChangeNotifier {
  static late Isar isar;
  final List<Expense> _allExpense = [];

  /*

  S E T U P

  */

  // initialize database
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([ExpenseSchema], directory: dir.path);
  }

  /*

  G E T T E R S

  */

  List<Expense> get allExpense => _allExpense;

  /*

  O P E R A T I O N S

  */

  // Create - add a new expense
  Future<void> createExpense(Expense expense) async {
    await isar.writeTxn(() => isar.expenses.put(expense));

    await getAllExpenses();
  }

  // Read - expense fom db
  Future<void> getAllExpenses() async {
    List<Expense> expenses = await isar.expenses.where().findAll();

    _allExpense.clear();
    _allExpense.addAll(expenses);

    notifyListeners();
  }

  // Update - edit an expense in db
  Future<void> updateExpense({required int id, required Expense expense}) async {
    expense.id = id;

    await isar.writeTxn(() => isar.expenses.put(expense));

    await getAllExpenses();
  }

  // Delete -  an expense
  Future<void> deleteExpense({required int id}) async {
    await isar.writeTxn(() => isar.expenses.delete(id));

    await getAllExpenses();
  }

  /*

  H E L P E R S

  */

  // calculate total expense for each month
  Future<Map<String, double>> calculateMonthlyTotals() async {
    await getAllExpenses();

    Map<String, double> monthlyTotals = {};

    for (var expense in _allExpense) {
      String yearMonth = '${expense.date.year}-${expense.date.month}';

      if (!monthlyTotals.containsKey(yearMonth)) {
        monthlyTotals[yearMonth] = 0;
      }

      monthlyTotals[yearMonth] = monthlyTotals[yearMonth]! + expense.amount;
    }

    return monthlyTotals;
  }

  // get start month
  int getStartMonth() {
    if (_allExpense.isEmpty) {
      return DateTime.now().month;
    }

    _allExpense.sort((a, b) => a.date.compareTo(b.date));

    return _allExpense.first.date.month;
  }

  // get start year
  int getStartYear() {
    if (_allExpense.isEmpty) {
      return DateTime.now().year;
    }

    _allExpense.sort((a, b) => a.date.compareTo(b.date));

    return _allExpense.first.date.year;
  }

  // calculate current month total
  Future<double> calculateCurrentMonthExpenses() async {
    await getAllExpenses();

    var now = DateTime.now();
    int currentMonth = now.month;
    int currentYear = now.year;

    List<Expense> currentMonthExpenses = _allExpense
        .where(
          (expense) => expense.date.month == currentMonth && expense.date.year == currentYear,
        )
        .toList();

    double total = currentMonthExpenses.fold(0, (sum, expense) => sum + expense.amount);

    return total;
  }
}
