import 'package:flutter/material.dart';
import 'package:mk_expense_tracker/components/my_list_tile.dart';
import 'package:mk_expense_tracker/database/expense_database.dart';
import 'package:mk_expense_tracker/helper/helper_functions.dart';

import 'package:mk_expense_tracker/models/expense.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // text controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  // read expenses
  @override
  void initState() {
    Provider.of<ExpenseDatabase>(context, listen: false).readExpenses();

    super.initState();
  }

  // open delete box
  void openDeleteBox(Expense expense) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Expense'),
        // ignore: prefer_const_constructors
        content: Column(
          // MainAxisSize.min reduces the height of the column to its children
          mainAxisSize: MainAxisSize.min,
        ),
        actions: [
          // cancel button
          _cancelButton(),

          // save button
          _deleteExpenseButton(expense.id),
        ],
      ),
    );
  }

  // open edit expense box
  void openEditBox(Expense expense) {
    // prefill existing values
    String existingName = expense.name;
    String existingAmount = expense.amount.toString();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Expense'),
        content: Column(
          // MainAxisSize.min reduces the height of the column to its children
          mainAxisSize: MainAxisSize.min,
          children: [
            // user input >> expense name
            TextField(
              controller: nameController,
              decoration: InputDecoration(hintText: existingName),
            ),
            // user input >> expense amount
            TextField(
              controller: amountController,
              decoration: InputDecoration(hintText: existingAmount),
            ),
          ],
        ),
        actions: [
          // cancel button
          _cancelButton(),

          // save button
          _editExpenseButton(expense),
        ],
      ),
    );
  }

  // open new expense box
  void openNewExpense() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Expense'),
        content: Column(
          // MainAxisSize.min reduces the height of the column to its children
          mainAxisSize: MainAxisSize.min,
          children: [
            // user input >> expense name
            TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: 'Expense Name...'),
            ),
            // user input >> expense amount
            TextField(
              controller: amountController,
              decoration: const InputDecoration(hintText: 'Expense Amount...'),
            ),
          ],
        ),
        actions: [
          // cancel button
          _cancelButton(),

          // save button
          _createNewExpenseButton(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseDatabase>(
      builder: (context, value, child) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: openNewExpense,
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
            itemCount: value.allExpense.length,
            itemBuilder: (context, index) {
              // get individual expense
              Expense eachExpense = value.allExpense[index];

              // return a custom list tile
              // MyListTile requires title & trailing
              return MyListTile(
                title: eachExpense.name,
                trailing: formatAmount(eachExpense.amount),
                onEditPressed: (context) => openEditBox(eachExpense),
                onDeletePressed: (context) => openDeleteBox(eachExpense),
              );
            }),
      ),
    );
  }

  // cancel button
  Widget _cancelButton() {
    return MaterialButton(
      onPressed: () {
        // action for the cancel button
        Navigator.pop(context);
        // clear controllers
        nameController.clear();
        amountController.clear();
      },
      child: const Text('Cancel'),
    );
  }

  // save button
  Widget _createNewExpenseButton() {
    return MaterialButton(
      onPressed: () async {
        // action for the save button
        // only save if textfields are not empty

        if (nameController.text.isNotEmpty &&
            amountController.text.isNotEmpty) {
          // pop the box
          Navigator.pop(context);

          // create new expense
          Expense newExpense = Expense(
            name: nameController.text,
            // uses helper function to return a double
            amount: convertStringToDouble(amountController.text),
            date: DateTime.now(),
          );

          // save to db
          await context.read<ExpenseDatabase>().createNewExpense(newExpense);

          // clear controllers
          nameController.clear();
          amountController.clear();
        }

        nameController.clear();
        amountController.clear();
      },
      child: const Text('Save'),
    );
  }

  // update expense button
  Widget _editExpenseButton(Expense expense) {
    return MaterialButton(
      onPressed: () async {
        // action for the edit button
        // only save if one field has been changed

        if (nameController.text.isNotEmpty ||
            amountController.text.isNotEmpty) {
          // pop the box
          Navigator.pop(context);

          // create new updated expense
          Expense updatedExpense = Expense(
            name: nameController.text.isNotEmpty
                ? nameController.text
                : expense.name,

            // uses helper function to return a double
            amount: amountController.text.isNotEmpty
                ? convertStringToDouble(amountController.text)
                : expense.amount,
            date: DateTime.now(),
          );

          // old expense id
          int exisitngId = expense.id;

          // save to db
          await context
              .read<ExpenseDatabase>()
              .updateExpense(exisitngId, updatedExpense);

          // clear controllers
          nameController.clear();
          amountController.clear();
        }

        nameController.clear();
        amountController.clear();
      },
      child: const Text('Save'),
    );
  }

  // delete expense button
  Widget _deleteExpenseButton(int id) {
    return MaterialButton(
      onPressed: () async {
        // pop the box
        Navigator.pop(context);

        // delete expense from db
        await context.read<ExpenseDatabase>().deleteExpense(id);
      },
      child: const Text('Delete'),
    );
  }
}
