import 'dart:developer';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:expense_app/data/extensions/date_time_extension.dart';
import 'package:expense_app/domain/contracts/services/i_excel_service.dart';
import 'package:expense_app/domain/models/expense.dart';
import 'package:expense_app/ui/pages/home/home_controller.dart';
import 'package:expense_app/utils/helper_functions.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ExcelService implements IExcelService {
  ExcelService({required this.homeController});

  final HomeController homeController;

  @override
  Future<void> create() async {
    // Initialize excel
    Excel excel = Excel.createExcel();

    final List<MonthlySummary> monthlySummary = homeController.monthlySummary2();

    for (final monthly in monthlySummary) {
      final String currentMonth = getMonthByNumber(monthly.month - 1);
      Sheet sheet = excel['$currentMonth/${monthly.year}'];

      List<Expense> currentExpenses =
          homeController.expenses
              .where((e) => e.date.month == monthly.month && e.date.year == monthly.year)
              .toList();

      log('${monthly.toString()} - ${currentExpenses.length}', name: 'EXCEL_IMPL_2');

      final int kRowIndex = 3;
      for (var i = 0; i < currentExpenses.length; i++) {
        int rowIndex = i == 0 ? kRowIndex : kRowIndex + i;
        final Expense expense = currentExpenses[i];

        List<CellValue> dataList = [
          TextCellValue(expense.name),
          DoubleCellValue(expense.amount),
          TextCellValue(expense.date.formatDate),

          TextCellValue(expense.type.label),
        ];

        sheet.insertRowIterables(dataList, rowIndex);
      }
    }

    final List<int>? fileBytes = excel.save();
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = p.join('${directory.path}/expenses.xlsx');

    if (fileBytes != null) {
      File(filePath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);

      log('Arquivo salvo em: $filePath', name: 'EXCEL_IMPL_2');
    }
  }
}
