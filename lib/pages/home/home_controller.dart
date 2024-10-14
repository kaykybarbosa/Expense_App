import 'package:expense_app/database/expense_database.dart';
import 'package:expense_app/domain/enums/expense_type.dart';
import 'package:expense_app/domain/models/expense.dart';
import 'package:expense_app/helper/helper_functions.dart';
import 'package:flutter/material.dart';

export 'package:expense_app/domain/enums/expense_type.dart';

class HomeController extends ChangeNotifier {
  final ExpenseDatabase _db = ExpenseDatabase();

  final List<Expense> _expenses = [];

  List<Expense> get expenses => _expenses;

  // get dates
  int currentMonth = DateTime.now().month;
  int currentYear = DateTime.now().year;

  // get start month
  int get startMonth {
    if (_expenses.isEmpty) {
      return DateTime.now().month;
    }

    _expenses.sort((a, b) => a.date.compareTo(b.date));

    return _expenses.first.date.month;
  }

  // get start year
  int get startYear {
    if (_expenses.isEmpty) {
      return DateTime.now().year;
    }

    _expenses.sort((a, b) => a.date.compareTo(b.date));

    return _expenses.first.date.year;
  }

  // calculate the number of months since the first month
  int monthCount() => calculateMonthCount(startYear, startMonth, currentYear, currentMonth);

  // only display the expense for the current month
  List<Expense> get currentMonthExpenses => _expenses
      .where(
        (expense) => expense.date.year == currentYear && expense.date.month == currentMonth,
      )
      .toList();

  // Calculate current month total based on the given [type].
  Future<double> calculateCurrentMonthExpenses({required ExpenseType type}) async {
    final now = DateTime.now();
    int currentMonth = now.month;
    int currentYear = now.year;

    List<Expense> currentMonthExpenses = _expenses
        .where(
          (expense) => expense.date.month == currentMonth && expense.date.year == currentYear && expense.type == type,
        )
        .toList();

    double total = currentMonthExpenses.fold(0, (sum, expense) => sum + expense.amount);

    return total;
  }

  // futures to load graph data & monthly total
  // create the list monthly summary
  Future<List<Map<String, dynamic>>> monthlySummary({required ExpenseType type}) async {
    List<Expense> incomes = [];
    List<Expense> expenses = [];

    for (final expense in _expenses) {
      if (expense.type.isIncome) {
        incomes.add(expense);
      } else {
        expenses.add(expense);
      }
    }

    Map<String, dynamic> monthlyTotalsIncomes = _calculateMonthlyTotals(expenses: incomes);
    Map<String, dynamic> monthlyTotalsExpenses = _calculateMonthlyTotals(expenses: expenses);

    return List.generate(
      monthCount(),
      (index) {
        int year = startYear + (startMonth + index - 1) ~/ 12;
        int month = (startMonth + index - 1) % 12 + 1;

        String yearMonthKey = '$year-$month';

        return {
          'incomes': monthlyTotalsIncomes[yearMonthKey] ?? 0.0,
          'expenses': monthlyTotalsExpenses[yearMonthKey] ?? 0.0,
        };
      },
    );
  }

  // calculate total expense for each month
  Map<String, double> _calculateMonthlyTotals({List<Expense> expenses = const []}) {
    Map<String, double> monthlyTotals = {};

    for (final expense in expenses) {
      String yearMonth = '${expense.date.year}-${expense.date.month}';

      if (!monthlyTotals.containsKey(yearMonth)) {
        monthlyTotals[yearMonth] = 0;
      }

      monthlyTotals[yearMonth] = monthlyTotals[yearMonth]! + expense.amount;
    }

    return monthlyTotals;
  }

  Future<void> getAllExpenses() async {
    List<Expense> expenses = await _db.getAllExpenses();

    _expenses.clear();
    _expenses.addAll(expenses);

    notifyListeners();
  }

  Future<void> addExpense(Expense expense) async => {
        await _db.createExpense(expense),
        await getAllExpenses(),
      };

  Future<void> editExpense({required int id, required Expense expense}) async => {
        await _db.updateExpense(id: id, expense: expense),
        await getAllExpenses(),
      };

  Future<void> deleteExpense(int id) async => {
        await _db.deleteExpense(id: id),
        await getAllExpenses(),
      };
}
