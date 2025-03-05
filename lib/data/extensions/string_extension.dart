import 'package:intl/intl.dart';

extension StringExtension on String {
  DateTime? get tryParse {
    final format = DateFormat('dd/MM/yyyy');

    return format.tryParse(this);
  }

  double get parseToDouble => double.tryParse(this) ?? 0;

  double get unformatMoney {
    NumberFormat format = NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2);

    return format.parse(this).toDouble();
  }

  
}
