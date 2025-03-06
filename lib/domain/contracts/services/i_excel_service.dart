import 'dart:io';

import 'package:expense_app/dependency_injection/app_component.dart';

abstract class IExcelService {
  static IExcelService get instance => getIt<IExcelService>();

  Future<void> openExpenseReport(File file);

  Future<File?> createExpenseReport();
}
