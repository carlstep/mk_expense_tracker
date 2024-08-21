import 'package:flutter/material.dart';
import 'package:mk_expense_tracker/database/expense_database.dart';
import 'package:provider/provider.dart';

import 'pages/home_page.dart';

void main() async {
  // initilize isar
  WidgetsFlutterBinding.ensureInitialized();

  // initialize db
  await ExpenseDatabase.initialize();
  runApp(ChangeNotifierProvider(
    create: (context) => ExpenseDatabase(),
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}
