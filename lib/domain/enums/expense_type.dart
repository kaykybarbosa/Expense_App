enum ExpenseType { income, expense }

extension ExpenseTypeZ on ExpenseType {
  bool get isIncome => this == ExpenseType.income;
  bool get isExpense => this == ExpenseType.expense;
}
