import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:flutter_multi_formatter/formatters/pos_input_formatter.dart';

abstract class InputFormatter {
  static MaskedInputFormatter get date => MaskedInputFormatter('00/00/0000');

  static PosInputFormatter get money => PosInputFormatter(
    decimalSeparator: DecimalPosSeparator.comma,
    thousandsSeparator: ThousandsPosSeparator.dot,
  );
}
