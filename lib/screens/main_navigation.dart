import 'package:flutter/material.dart';
import '../widget/navbar.dart';
import 'add_expenses_screen.dart';
import 'home_screen.dart';
import 'statistics_screen.dart';
import 'expense_screen.dart';
import 'profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = const [
      HomeScreen(),
      StatisticsScreen(),
      ExpenseScreen(),
      ProfileScreen(),
    ];
  }

  void _onTap(int idx) {
    if (idx == _currentIndex) return;
    setState(() => _currentIndex = idx);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      // Center FAB acts as Add button (opens AddExpenseScreen)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
          ).then((_) => setState(() {}));
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
        tooltip: 'Add Expense',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Navbar(currentIndex: _currentIndex, onTap: _onTap),
    );
  }
}
