import 'package:intl/intl.dart';

class CurrencyFormatter {

  /// Full Indian Format → ₹ 1,20,000
  static final _inrFormatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: "₹ "

  );

  static String format(num amount) {
    return _inrFormatter.format(amount);
  }

  /// Compact Format → ₹ 1.2L / ₹ 3Cr
  static String compact(num amount) {
    if (amount >= 10000000) {
      return "₹ ${(amount / 10000000).toStringAsFixed(1)}Cr";
    }
    else if (amount >= 100000) {
      return "₹ ${(amount / 100000).toStringAsFixed(1)}L";
    }
    else if (amount >= 1000) {
      return "₹ ${(amount / 1000).toStringAsFixed(1)}K";
    }
    else {
      return "₹ ${amount.toStringAsFixed(0)}";
    }
  }

  /// Safe parsing from TextField
  static int parse(String text) {
    final clean = text.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(clean) ?? 0;
  }
}