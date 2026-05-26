import 'package:flutter/services.dart';
import 'package:oneship_customer/core/utils/utils.dart';

class CurrencyTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final amount = Utils.parseCurrencyInput(newValue.text);
    if (amount == 0 && newValue.text.isEmpty) {
      return const TextEditingValue();
    }

    final formatted = Utils.formatCurrencyInput(amount);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
