import 'package:expense_app/data/database/expense_database.dart';
import 'package:expense_app/domain/enums/expense_type.dart';
import 'package:expense_app/domain/models/expense.dart';
import 'package:expense_app/utils/helper_functions.dart';
import 'package:flutter/material.dart';

export 'package:expense_app/domain/enums/expense_type.dart';

class HomeController extends ChangeNotifier {
  HomeController();

  final IExpenseDatabase _db = IExpenseDatabase.instance;

  final List<Expense> _expenses = [];

  List<Expense> get expenses => _expenses;

  // get dates
  int get _currentMonth => DateTime.now().month;
  int get _currentYear => DateTime.now().year;

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
  int get monthCount =>
      calculateMonthCount(startYear, startMonth, _currentYear, _currentMonth);

  // only display the expense for the current month
  List<Expense> get currentMonthExpenses =>
      _expenses
          .where(
            (expense) =>
                expense.date.year == _currentYear && expense.date.month == _currentMonth,
          )
          .toList();

  // Calculate current month total based on the given [type].
  double calculateCurrentMonthExpenses({required ExpenseType type}) {
    final now = DateTime.now();
    int currentMonth = now.month;
    int currentYear = now.year;

    List<Expense> currentMonthExpenses =
        _expenses
            .where(
              (expense) =>
                  expense.date.month == currentMonth &&
                  expense.date.year == currentYear && //
                  expense.type == type,
            )
            .toList();

    double total = currentMonthExpenses.fold(0, (sum, expense) => sum + expense.amount);

    return total;
  }

  // Futures to load graph data & monthly total
  // create the list monthly summary
  List<Map<String, dynamic>> monthlySummary() {
    List<Expense> incomes = [];
    List<Expense> expenses = [];

    for (final expense in _expenses) {
      if (expense.type.isIncome) {
        incomes.add(expense);
      } else {
        expenses.add(expense);
      }
    }

    Map<String, dynamic> monthlyTotalsIncomes = calculateMonthlyTotals(expenses: incomes);
    Map<String, dynamic> monthlyTotalsExpenses = calculateMonthlyTotals(
      expenses: expenses,
    );

    return List.generate(monthCount, (index) {
      int year = startYear + (startMonth + index - 1) ~/ 12;
      int month = (startMonth + index - 1) % 12 + 1;

      String yearMonthKey = '$year-$month';

      return {
        'incomes': monthlyTotalsIncomes[yearMonthKey] ?? 0.0,
        'expenses': monthlyTotalsExpenses[yearMonthKey] ?? 0.0,
      };
    });
  }

  /// Calcula o total de despesas para cada mês com base na lista fornecida.
  ///
  /// - **Percorre a lista de despesas** e agrupa os valores por mês e ano.
  /// - **Se o mês ainda não existir no mapa**, inicializa com zero.
  /// - **Soma os valores das despesas do mesmo mês**, acumulando o total.
  ///
  /// ### Parâmetros:
  /// - [expenses] → Lista de despesas a serem processadas. *(Padrão: lista vazia [])*
  ///
  /// ### Retorno:
  /// - Retorna um `Map<String, double>`, onde a chave representa o **mês e ano (`YYYY-MM`)**
  ///   e o valor representa o **total de despesas acumuladas** naquele período.
  ///
  /// ### Exemplo de Retorno:
  /// ```dart
  /// { "2024-01": 1200.50, "2024-02": 850.75 }
  /// ```
  Map<String, double> calculateMonthlyTotals({List<Expense> expenses = const []}) {
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
    List<Expense> expenses = _db.getAllExpenses;

    _expenses.clear();
    _expenses.addAll(expenses);

    notifyListeners();
  }

  Future<void> addExpense(Expense expense) async => {
    _db.createExpense(expense),
    await getAllExpenses(),
  };

  Future<void> editExpense({required int id, required Expense expense}) async => {
    _db.updateExpense(id: id, expense: expense),
    await getAllExpenses(),
  };

  Future<void> deleteExpense(int id) async => {
    _db.deleteExpense(id: id),
    await getAllExpenses(),
  };
}
