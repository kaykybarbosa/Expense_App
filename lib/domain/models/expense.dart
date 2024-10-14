import 'package:expense_app/domain/enums/expense_type.dart';
import 'package:isar/isar.dart';

part 'expense.g.dart';

@Collection()
class Expense {
  Expense({
    required this.name,
    required this.amount,
    required this.date,
    ExpenseType? type,
  }) : type = type ?? ExpenseType.expense;

  Id id = Isar.autoIncrement;
  final String name;
  final double amount;
  final DateTime date;
  @enumerated
  final ExpenseType type;
}
