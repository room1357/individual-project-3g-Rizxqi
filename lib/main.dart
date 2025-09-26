import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/expense_manager.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ExpenseManager(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense App',
      home: HomeScreen(),
    );
  }
}
