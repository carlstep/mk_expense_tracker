import 'package:isar/isar.dart';

// run this code to build /re-build ISAR file - dart run build_runner build

part 'expense.g.dart';

@collection
class Expense {
  Id id = Isar.autoIncrement;
  final String name;
  final double amount;
  final DateTime date;

  Expense({
    required this.name,
    required this.amount,
    required this.date,
  });
}
