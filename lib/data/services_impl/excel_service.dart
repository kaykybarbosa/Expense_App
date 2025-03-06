import 'dart:io';

import 'package:excel/excel.dart';
import 'package:expense_app/data/extensions/date_time_extension.dart';
import 'package:expense_app/data/extensions/double_extension.dart';
import 'package:expense_app/domain/contracts/services/i_excel_service.dart';
import 'package:expense_app/domain/models/expense.dart';
import 'package:expense_app/ui/pages/home/home_controller.dart';
import 'package:expense_app/utils/helper_functions.dart';
import 'package:expense_app/utils/my_colors.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ExcelService implements IExcelService {
  ExcelService({required this.homeController});

  final HomeController homeController;

  @override
  Future<void> openExpenseReport(File file) async {
    try {
      await OpenFile.open(file.path);
    } catch (_) {}
  }

  @override
  Future<File?> createExpenseReport() async {
    // Initialize excel
    final Excel excel = Excel.createExcel();
    final CellStyle cellStyle = CellStyle(
      bold: true,
      horizontalAlign: HorizontalAlign.Center,
    );

    final List<MonthlySummary> monthlySummary = homeController.monthlySummary2();

    for (final monthly in monthlySummary) {
      // Expenses
      List<Expense> currentExpenses =
          homeController.expenses
              .where((e) => e.date.month == monthly.month && e.date.year == monthly.year)
              .toList();

      if (currentExpenses.isEmpty) continue;

      // Sheet
      final String currentMonth = getMonthByNumber(monthly.month - 1);
      final Sheet sheet = excel['$currentMonth/${monthly.year}'];

      // Incomes subtotal
      final double incomesSubTotal = _calculateExpenses(
        expenses: currentExpenses,
        type: ExpenseType.income,
      );
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1))
        ..value = TextCellValue('Incomes')
        ..cellStyle = cellStyle;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 2))
        ..value = TextCellValue(incomesSubTotal.formatAmount)
        ..cellStyle = cellStyle.copyWith(
          fontColorHexVal: ExcelColor.fromHexString(MyColors.successHex),
        );

      // Expenses subtotal
      final double expenseSubTotal = _calculateExpenses(
        expenses: currentExpenses,
        type: ExpenseType.expense,
      );
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 1))
        ..value = TextCellValue('Expenses')
        ..cellStyle = cellStyle;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 2))
        ..value = TextCellValue(expenseSubTotal.formatAmount)
        ..cellStyle = cellStyle.copyWith(
          fontColorHexVal: ExcelColor.fromHexString(MyColors.warnHex),
        );

      // Sheet header
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 4))
        ..value = TextCellValue('Name')
        ..cellStyle = cellStyle;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 4))
        ..value = TextCellValue('Ammount')
        ..cellStyle = cellStyle;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 4))
        ..value = TextCellValue('Date')
        ..cellStyle = cellStyle;

      // Setting values
      final int initialRowIndex = 6;
      for (var i = 0; i < currentExpenses.length; i++) {
        int rowIndex = i == 0 ? initialRowIndex : initialRowIndex + i;
        final Expense expense = currentExpenses[i];

        List<CellValue> dataList = [
          TextCellValue(expense.name),
          TextCellValue(expense.amount.formatAmount),
          TextCellValue(expense.date.formatDate2),
        ];

        // -- Insert values
        sheet.insertRowIterables(dataList, rowIndex);

        // -- Ammount style
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
            .cellStyle = CellStyle(
          fontColorHex: ExcelColor.fromHexString(
            (expense.type.isIncome ? MyColors.successHex : MyColors.warnHex),
          ),
        );

        // -- Date style
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex))
            .cellStyle = CellStyle(
          numberFormat: NumFormat.defaultDate,
          horizontalAlign: HorizontalAlign.Center,
        );
      }
    }

    // Deleting sheet that is created automatically.
    excel.delete('Sheet1');

    return _saveExcel(excel.save());
  }

  Future<File?> _saveExcel(List<int>? fileBytes) async {
    final Directory? directory =
        Platform.isAndroid
            ? await getDownloadsDirectory()
            : await getApplicationDocumentsDirectory();

    if (fileBytes != null) {
      final File file =
          File(p.join('${directory?.path}/expenses.xlsx'))
            ..createSync(recursive: true)
            ..writeAsBytesSync(fileBytes);

      return file;
    }

    return null;
  }

  double _calculateExpenses({required List<Expense> expenses, ExpenseType? type}) {
    List<Expense> currentExpenses = expenses;

    if (type != null) {
      currentExpenses = expenses.where((expense) => expense.type == type).toList();
    }

    return currentExpenses.fold(0, (sum, expense) => sum + expense.amount);
  }
}
