import 'package:isar/isar.dart';

part 'expense.g.dart';

@Collection()
class Expense {
  Expense({
    required this.name,
    required this.amount,
    required this.date,
  });

  Id id = Isar.autoIncrement;
  final String name;
  final double amount;
  final DateTime date;
}
