import 'package:expense_app/domain/enums/expense_type.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Expense {
  Expense({
    this.id = 0,
    required this.name,
    required this.amount,
    required this.date,
    required this.typeIndex,
  });

  @Id()
  int id;
  final String name;
  final double amount;
  @Property(type: PropertyType.date)
  final DateTime date;
  final int typeIndex;

  ExpenseType get type => ExpenseType.values[typeIndex];
}
