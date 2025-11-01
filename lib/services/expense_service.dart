import 'package:pemrograman_mobile/utils/date_utils.dart';

import '../models/expense.dart';

class ExpenseService {
  // ✅ Singleton instance
  static final ExpenseService _instance = ExpenseService._internal();
  factory ExpenseService() => _instance;
  ExpenseService._internal();

  // ✅ FIX: Sesuaikan categoryId dengan CategoryService
  final List<Expense> _expenses = [
    Expense(
      id: '1',
      title: 'Makan Siang',
      amount: 25000,
      date: DateTime.now(),
      categoryId: '1', // ✅ Sesuaikan dengan ID di CategoryService (Food)
    ),
    Expense(
      id: '2',
      title: 'Bensin Motor',
      amount: 15000,
      date: DateTime.now(),
      categoryId: '2', // ✅ Transport
    ),
    Expense(
      id: '3',
      title: 'Nonton Bioskop',
      amount: 50000,
      date: DateTime.now().subtract(const Duration(days: 1)),
      categoryId: '3', // ✅ Entertainment
    ),
  ];

  // ✅ Semua method sama seperti sebelumnya
  List<Expense> getAllExpenses() => List.unmodifiable(_expenses);

  void addExpense(Expense expense) {
    if (_expenses.any((e) => e.id == expense.id)) {
      throw Exception("Expense dengan ID ${expense.id} sudah ada!");
    }
    _expenses.add(expense);
  }

  void deleteExpense(String id) {
    _expenses.removeWhere((e) => e.id == id);
  }

  void updateExpense(Expense updatedExpense) {
    final index = _expenses.indexWhere((e) => e.id == updatedExpense.id);
    if (index != -1) {
      _expenses[index] = updatedExpense;
    } else {
      throw Exception(
        "Expense dengan ID ${updatedExpense.id} tidak ditemukan!",
      );
    }
  }

  // 🔹 Total pengeluaran per minggu
  List<double> getWeeklyTotalsForMonth(int month, int year) {
    final expenses = _expenses.where(
      (e) => e.date.month == month && e.date.year == year,
    );

    final _ = DateUtilsHelper.getDaysInMonth(year, month);
    final weekStarts = DateUtilsHelper.getWeekStartDays(year, month);
    final List<double> weeklyTotals = List.filled(weekStarts.length, 0);

    for (final e in expenses) {
      final weekIndex = ((e.date.day - 1) ~/ 7);
      weeklyTotals[weekIndex] += e.amount;
    }

    return weeklyTotals;
  }

  // 🔹 Hitung kelipatan Y-axis (100rb terdekat)
  double getNiceMaxY(double value) {
    if (value <= 0) return 100000;
    return ((value / 100000).ceil() * 100000).toDouble();
  }

  Expense? getById(String id) {
    try {
      return _expenses.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  double getTotalExpenses() {
    return _expenses.fold(0.0, (sum, e) => sum + e.amount);
  }

  List<Expense> getExpensesByCategory(String categoryId) {
    return _expenses.where((e) => e.categoryId == categoryId).toList();
  }

  int get count => _expenses.length;

  void clearAll() {
    _expenses.clear();
  }
}
