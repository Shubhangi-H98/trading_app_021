import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final _currencyFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  static String format(double value) => _currencyFormat.format(value);

  static String formatChange(double change, double changePercent) {
    final sign = change >= 0 ? '+' : '';
    return '$sign${change.toStringAsFixed(2)} ($sign${changePercent.toStringAsFixed(2)}%)';
  }

  static double roundTo2Decimals(double value) {
    return double.parse(value.toStringAsFixed(2));
  }
}