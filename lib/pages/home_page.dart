import 'package:flutter/material.dart';
import 'package:mk_expense_tracker/database/expense_database.dart';
import 'package:mk_expense_tracker/helper/helper_functions.dart';
import 'package:mk_expense_tracker/main.dart';
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

              // return a list tile
              return ListTile(
                title: Text(eachExpense.name),
                // uses helper function to format the given amount
                trailing: Text(formatAmount(eachExpense.amount)),
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
}
