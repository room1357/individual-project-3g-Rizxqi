import 'expense.dart';
import 'package:flutter/foundation.dart';

/// ----------------------------
/// Expense Manager
/// ----------------------------
class ExpenseManager extends ChangeNotifier {
  
  final List<Expense> _expenses = [];

  List<Expense> get expenses => List.unmodifiable(_expenses);

  void addExpense(Expense expense) {
    _expenses.add(expense);
    notifyListeners();
  }

  void removeExpense(Expense expense) {
    _expenses.remove(expense);
    notifyListeners();
  }

  void clearExpenses() {
    _expenses.clear();
    notifyListeners();
  }

  /// Total per kategori
  Map<String, double> get totalByCategory {
    final result = <String, double>{};
    for (var e in _expenses) {
      result[e.category] = (result[e.category] ?? 0) + e.amount;
    }
    return result;
  }

  /// Pengeluaran terbesar
  Expense? get highestExpense {
    if (_expenses.isEmpty) return null;
    return _expenses.reduce((a, b) => a.amount > b.amount ? a : b);
  }

  /// Pengeluaran per bulan & tahun
  List<Expense> getExpensesByMonth(int month, int year) {
    return _expenses
        .where((e) => e.date.month == month && e.date.year == year)
        .toList();
  }

  /// Cari pengeluaran by keyword
  List<Expense> searchExpenses(String keyword) {
    final lower = keyword.toLowerCase();
    return _expenses
        .where(
          (e) =>
              e.title.toLowerCase().contains(lower) ||
              e.description.toLowerCase().contains(lower) ||
              e.category.toLowerCase().contains(lower),
        )
        .toList();
  }

  /// 🔥 Rata-rata pengeluaran harian
  double get averageDaily {
    if (_expenses.isEmpty) return 0;

    final total = _expenses.fold(0.0, (sum, e) => sum + e.amount);

    // Hitung jumlah hari unik dari data
    final uniqueDays =
        _expenses
            .map((e) => '${e.date.year}-${e.date.month}-${e.date.day}')
            .toSet()
            .length;

    return uniqueDays == 0 ? 0 : total / uniqueDays;
  }
}
