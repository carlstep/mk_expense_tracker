// some helpful functions to help with the app code

// convert string to a double

import 'package:intl/intl.dart';

double convertStringToDouble(String string) {
  double? amount = double.tryParse(string);

  // if amount is nothing return 0
  return amount ?? 0;
}

// format double to dollars and cents
String formatAmount(double amount) {
  final format = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
    decimalDigits: 2,
  );
  return format.format(amount);
}
