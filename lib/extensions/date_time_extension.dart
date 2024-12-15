import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String get formatDate {
    final format = DateFormat('dd/MM/yyyy');

    return format.format(this);
  }
}
