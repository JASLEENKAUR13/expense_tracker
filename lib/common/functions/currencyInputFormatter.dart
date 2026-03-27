import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {

  final _formatter = NumberFormat('#,##,###', 'en_IN');

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue,
      TextEditingValue newValue,) {
    if (newValue.text.isEmpty) return newValue;

    final cleanText = newValue.text.replaceAll(',', '');
    final number = int.tryParse(cleanText);

    if (number == null) return newValue;

    final formatted = _formatter.format(number);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}