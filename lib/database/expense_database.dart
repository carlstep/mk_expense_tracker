import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/expense.dart';

class ExpenseDatabase extends ChangeNotifier {
  static late Isar isar;
  List<Expense> _allExpenses = [];

//SETUP
// Initialize db
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([ExpenseSchema], directory: dir.path);
  }

//GETTERS
  // get list of allExpenses
  List<Expense> get allExpense => _allExpenses;

//OPERATIONS
// Create - add new expense
  Future<void> createNewExpense(Expense newExpense) async {
    // add to db
    await isar.writeTxn(() => isar.expenses.put(newExpense));

    // re-read from db
    await readExpenses();
  }

// Read - read an expense
  Future<void> readExpenses() async {
    // fetch all existing expenses from db
    List<Expense> fetchedExpenses = await isar.expenses.where().findAll();

    // give to local expense list
    _allExpenses.clear();
    _allExpenses.addAll(fetchedExpenses);

    // update UI
    notifyListeners();
  }

// Update - edit and update an existing expense

  Future<void> updateExpense(int id, Expense updatedExpense) async {
    // make sure udated expense has same id as exisitng one
    updatedExpense.id = id;

    // update in db
    await isar.writeTxn(() => isar.expenses.put(updatedExpense));

    // re-read from db
    await readExpenses();
  }

// Delete - remove expense from db
  Future<void> deleteExpense(int id) async {
    await isar.writeTxn(() => isar.expenses.delete(id));

    // re-read from db
    await readExpenses();
  }

//HELPER METHODS
}
