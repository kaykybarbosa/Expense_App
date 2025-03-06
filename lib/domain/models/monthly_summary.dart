class MonthlySummary {
  MonthlySummary({
    required this.year,
    required this.month,
    required this.income,
    required this.expense,
  });

  final int year;
  final int month;
  final double income;
  final double expense;

  @override
  String toString() => "Mês: $month/$year | Receita: $income | Despesa: $expense";
}
