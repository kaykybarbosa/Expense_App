import 'dart:developer';

import 'package:expense_app/models/expense.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class ExpenseDatabase {
  static late Isar isar;

  /*

  S E T U P

  */

  // initialize database
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([ExpenseSchema], directory: dir.path);
  }

  /*

  O P E R A T I O N S

  */

  // Create - add a new expense
  Future<void> createExpense(Expense expense) async {
    await isar.writeTxn(() async => await isar.expenses.put(expense));

    log('ADICIONOU EXPENSE', name: 'GRAPH TEST');
  }

  // Read - expense fom db
  Future<List<Expense>> getAllExpenses() async => await isar.expenses.where().findAll();

  // Update - edit an expense in db
  Future<void> updateExpense({required int id, required Expense expense}) async {
    expense.id = id;

    await isar.writeTxn(() async => await isar.expenses.put(expense));
  }

  // Delete -  an expense
  Future<void> deleteExpense({required int id}) async {
    await isar.writeTxn(() async => await isar.expenses.delete(id));
  }
}
