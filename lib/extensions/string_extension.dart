import 'package:intl/intl.dart';

extension StringExtension on String {
  DateTime? get tryParse {
    final format = DateFormat('dd/MM/yyyy');

    return format.tryParse(this);
  }
}
