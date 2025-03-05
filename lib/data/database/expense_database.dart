import 'package:expense_app/dependency_injection/app_component.dart';
import 'package:expense_app/domain/models/expense.dart';
import 'package:expense_app/objectbox.g.dart';
import 'package:path_provider/path_provider.dart';

abstract class IExpenseDatabase {
  static Future<Store> get initialize async {
    final docsDir = await getApplicationDocumentsDirectory();
    return await openStore(directory: '${docsDir.path}/objectBox');
  }

  static IExpenseDatabase get instance => getIt<IExpenseDatabase>();

  List<Expense> get getAllExpenses;

  void createExpense(Expense expense);

  void updateExpense({required int id, required Expense expense});

  void deleteExpense({required int id});
}

class ExpenseDatabase implements IExpenseDatabase {
  ExpenseDatabase({required this.store});

  final Store store;

  /*

  O P E R A T I O N S

  */

  // Read - expense fom db
  @override
  List<Expense> get getAllExpenses {
    final expenseBox = store.box<Expense>();

    final query = expenseBox.query().order(Expense_.date).build();
    final List<Expense> allExpenses = query.find();
    query.close();

    return allExpenses;
  }

  // Create - add a new expense
  @override
  void createExpense(Expense expense) {
    final expenseBox = store.box<Expense>();

    expenseBox.put(expense);
  }

  // Update - edit an expense in db
  @override
  void updateExpense({required int id, required Expense expense}) {
    final expenseBox = store.box<Expense>();

    expense.id = id;

    expenseBox.put(expense);
  }

  // Delete -  an expense
  @override
  void deleteExpense({required int id}) => store.box<Expense>().remove(id);
}
