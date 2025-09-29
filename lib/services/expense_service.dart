import '../models/expense.dart';

class ExpenseService {
  static final List<Expense> _expenses = [
    Expense(
      id: '1',
      title: 'Makan Siang',
      description: 'Nasi goreng + es teh',
      amount: 25000,
      category: 'Makanan',
      date: DateTime(2025, 9, 15),
    ),
    Expense(
      id: '2',
      title: 'Bensin',
      description: 'Isi Pertalite 2 liter',
      amount: 20000,
      category: 'Transportasi',
      date: DateTime(2025, 9, 14),
    ),
    Expense(
      id: '3',
      title: 'Netflix',
      description: 'Langganan bulanan',
      amount: 54000,
      category: 'Hiburan',
      date: DateTime(2025, 9, 10),
    ),
    Expense(
      id: '4',
      title: 'Listrik',
      description: 'Token PLN 100rb',
      amount: 100000,
      category: 'Utilitas',
      date: DateTime(2025, 9, 5),
    ),
    Expense(
      id: '5',
      title: 'Buku Kuliah',
      description: 'Pemrograman Mobile',
      amount: 75000,
      category: 'Pendidikan',
      date: DateTime(2025, 9, 1),
    ),
  ];

  // Ambil semua
  static List<Expense> getAll() => List.unmodifiable(_expenses);

  // Tambah
  static void addExpense(Expense expense) {
    _expenses.add(expense);
  }

  // Hapus
  static void deleteExpense(String id) {
    _expenses.removeWhere((e) => e.id == id);
  }

  // Update
  static void updateExpense(Expense updated) {
    final index = _expenses.indexWhere((e) => e.id == updated.id);
    if (index != -1) {
      _expenses[index] = updated;
    }
  }

  // Statistik
  static Map<String, double> getTotalByCategory() {
    final result = <String, double>{};
    for (var e in _expenses) {
      result[e.category] = (result[e.category] ?? 0) + e.amount;
    }
    return result;
  }

  static Expense? getHighestExpense() {
    if (_expenses.isEmpty) return null;
    return _expenses.reduce((a, b) => a.amount > b.amount ? a : b);
  }

  static List<Expense> getByMonth(int month, int year) {
    return _expenses
        .where((e) => e.date.month == month && e.date.year == year)
        .toList();
  }

  static List<Expense> search(String keyword) {
    final lower = keyword.toLowerCase();
    return _expenses.where((e) {
      return e.title.toLowerCase().contains(lower) ||
          e.description.toLowerCase().contains(lower) ||
          e.category.toLowerCase().contains(lower);
    }).toList();
  }

  static double getAverageDaily() {
    if (_expenses.isEmpty) return 0;
    final total = _expenses.fold(0.0, (sum, e) => sum + e.amount);
    final uniqueDays =
        _expenses
            .map((e) => '${e.date.year}-${e.date.month}-${e.date.day}')
            .toSet();
    return total / uniqueDays.length;
  }
}
