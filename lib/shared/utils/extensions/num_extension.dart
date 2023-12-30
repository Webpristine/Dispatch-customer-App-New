import 'package:intl/intl.dart';

extension NumExtension on num {
  String formatCurrency({int decimal = 2, String symbol = '₹'}) =>
      NumberFormat.currency(
        symbol: symbol,
        locale: 'en_IN',
        decimalDigits: decimal,
      ).format(this);

  String formatCompactCurrency({
    int decimal = 4,
    String symbol = '₹',
    String locale = 'en_US',
  }) =>
      NumberFormat.compactCurrency(
        symbol: symbol,
        locale: locale,
        decimalDigits: decimal,
      ).format(this);

  bool get isInt => (this % 1) == 0;

  num toPrecision(int n) => num.parse(toStringAsFixed(n));
}
