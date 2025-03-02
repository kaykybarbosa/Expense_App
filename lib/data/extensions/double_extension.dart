import 'package:intl/intl.dart';

extension DoubleExtension on double {
  String get formatAmount => NumberFormat.currency(
    locale: "pt_BR",
    symbol: "R\$",
    decimalDigits: 2,
  ).format(this);
}
