// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:mk_expense_tracker/helper/helper_functions.dart';

class MyListTile extends StatelessWidget {
  final String title;
  final String trailing;

  const MyListTile({
    super.key,
    required this.title,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: Text(trailing),
    );
  }
}
