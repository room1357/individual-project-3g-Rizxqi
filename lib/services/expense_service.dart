import '../models/expense.dart';
import '../utils/date_utils.dart';

class ExpenseService {
  // ✅ Step 1: Buat instance tunggal (Singleton)
  static final ExpenseService _instance = ExpenseService._internal();

  // ✅ Step 2: Factory constructor agar bisa dipanggil dengan `ExpenseService()`
  factory ExpenseService() {
    return _instance;
  }

  // ✅ Step 3: Private constructor internal
  ExpenseService._internal();

  // ✅ Data sementara (dummy)
  final List<Expense> _expenses = [
    Expense(
      id: '1',
      title: 'Makan Siang',
      description: 'Nasi goreng + es teh',
      amount: 25000,
      category: 'Makanan',
      date: DateTime(2025, 10, 1),
    ),
    Expense(
      id: '2',
      title: 'Transport',
      description: 'Grab ke kampus',
      amount: 15000,
      category: 'Transportasi',
      date: DateTime(2025, 10, 8),
    ),
    Expense(
      id: '3',
      title: 'Langganan Spotify',
      description: '',
      amount: 54000,
      category: 'Hiburan',
      date: DateTime(2025, 10, 18),
    ),
  ];

  // 🔹 Getter semua data
  List<Expense> getAllExpenses() => List.unmodifiable(_expenses);

  // 🔹 Tambah pengeluaran baru
  void addExpense(Expense expense) {
    _expenses.add(expense);
  }

  // 🔹 Hapus pengeluaran berdasarkan ID
  void deleteExpense(String id) {
    _expenses.removeWhere((e) => e.id == id);
  }

  // 🔹 Update pengeluaran
  void updateExpense(Expense updated) {
    final index = _expenses.indexWhere((e) => e.id == updated.id);
    if (index != -1) _expenses[index] = updated;
  }

  // 🔹 Total pengeluaran per minggu
  List<double> getWeeklyTotalsForMonth(int month, int year) {
    final expenses = _expenses.where(
      (e) => e.date.month == month && e.date.year == year,
    );

    final daysInMonth = DateUtilsHelper.getDaysInMonth(year, month);
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

  // 🔹 Total semua pengeluaran
  double getTotalExpenses() {
    return _expenses.fold(0.0, (sum, e) => sum + e.amount);
  }
}
