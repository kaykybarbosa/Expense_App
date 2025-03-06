import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String get formatDate {
    final format = DateFormat('dd/MM/yyyy');

    return format.format(this);
  }

  String get formatDate2 {
    final format = DateFormat('dd/MM/yy');

    return format.format(this);
  }
}
