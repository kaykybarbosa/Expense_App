import 'dart:io';

import 'package:expense_app/dependency_injection/app_component.dart';
import 'package:expense_app/domain/models/expense.dart';
import 'package:expense_app/domain/models/monthly_summary.dart';

abstract class IExcelService {
  static IExcelService get instance => getIt<IExcelService>();

  Future<void> openExpenseReport(File file);

  Future<File?> createExpenseReport({
    required List<MonthlySummary> monthlySummary,
    required List<Expense> expenses,
  });
}
