// some helpful functions to help with the app code

// convert string to a double

double convertStringToDouble(String string) {
  double? amount = double.tryParse(string);

  // if amount is nothing return 0
  return amount ?? 0;
}
