import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

abstract class InputFormatter {
  static MaskTextInputFormatter get date => MaskTextInputFormatter(
        mask: '##/##/####',
        type: MaskAutoCompletionType.lazy,
      );
}
