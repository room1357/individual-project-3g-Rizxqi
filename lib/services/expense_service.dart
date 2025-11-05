import 'package:pemrograman_mobile/services/auth_service.dart';
import 'package:pemrograman_mobile/services/storage_service.dart';
import 'package:pemrograman_mobile/utils/date_utils.dart';

import '../models/expense.dart';

class ExpenseService {
  // ✅ Singleton instance
  static final ExpenseService _instance = ExpenseService._internal();
  factory ExpenseService() => _instance;
  ExpenseService._internal();

  // ✅ FIX: Sesuaikan categoryId dengan CategoryService
  final List<Expense> _expenses = [
    // Expense(
    //   id: '1',
    //   title: 'Makan Siang',
    //   amount: 25000,
    //   date: DateTime.now(),
    //   categoryId: '1', // ✅
    // ),
  ];
  final _storage = StorageService();

  Future<void> loadExpenses() async {
    final user = AuthService.instance.getCurrentUser();
    if (user == null) return;

    final data = await _storage.loadData('expenses_${user.username}');
    _expenses.clear();
    _expenses.addAll(data.map((e) => Expense.fromJson(e)).toList());
  }

  // ✅ Semua method sama seperti sebelumnya
  Future<void> saveExpenses() async {
    final user = AuthService.instance.getCurrentUser();
    if (user == null) return;

    await _storage.saveData(
      'expenses_${user.username}',
      _expenses.map((e) => e.toJson()).toList(),
    );
  }

  List<Expense> getAllExpenses() => List.unmodifiable(_expenses);

  Future<void> addExpense(Expense expense) async {
    _expenses.add(expense);
    await saveExpenses();
  }

  Future<void> deleteExpense(String id) async {
    _expenses.removeWhere((e) => e.id == id);
    await saveExpenses();
  }

  Future<void> updateExpense(Expense updatedExpense) async {
    final index = _expenses.indexWhere((e) => e.id == updatedExpense.id);
    if (index != -1) {
      _expenses[index] = updatedExpense;
      await saveExpenses();
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
