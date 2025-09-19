import 'expense.dart';

class LoopingExamples {
  // Contoh data dummy
  static List<Expense> expenses = [
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
  ];

  // 1. Menghitung total dengan berbagai cara
  static double calculateTotalTraditional(List<Expense> expenses) {
    double total = 0;
    for (int i = 0; i < expenses.length; i++) {
      total += expenses[i].amount;
    }
    return total;
  }

  static double calculateTotalForIn(List<Expense> expenses) {
    double total = 0;
    for (Expense expense in expenses) {
      total += expense.amount;
    }
    return total;
  }

  static double calculateTotalForEach(List<Expense> expenses) {
    double total = 0;
    expenses.forEach((expense) {
      total += expense.amount;
    });
    return total;
  }

  static double calculateTotalFold(List<Expense> expenses) {
    return expenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  static double calculateTotalReduce(List<Expense> expenses) {
    if (expenses.isEmpty) return 0;
    return expenses.map((e) => e.amount).reduce((a, b) => a + b);
  }

  // 2. Mencari item dengan berbagai cara
  static Expense? findExpenseTraditional(List<Expense> expenses, String id) {
    for (int i = 0; i < expenses.length; i++) {
      if (expenses[i].id == id) {
        return expenses[i];
      }
    }
    return null;
  }

  static Expense? findExpenseWhere(List<Expense> expenses, String id) {
    try {
      return expenses.firstWhere((expense) => expense.id == id);
    } catch (e) {
      return null;
    }
  }

  // 3. Filtering dengan berbagai cara
  static List<Expense> filterByCategoryManual(
    List<Expense> expenses,
    String category,
  ) {
    List<Expense> result = [];
    for (Expense expense in expenses) {
      if (expense.category.toLowerCase() == category.toLowerCase()) {
        result.add(expense);
      }
    }
    return result;
  }

  static List<Expense> filterByCategoryWhere(
    List<Expense> expenses,
    String category,
  ) {
    return expenses
        .where(
          (expense) => expense.category.toLowerCase() == category.toLowerCase(),
        )
        .toList();
  }
}

class ExpenseManager {
  static List<Expense> expenses = [
    Expense(
      id: '1', // ⬅️ Tambahkan id unik
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

  // 1. Mendapatkan total pengeluaran per kategori
  static Map<String, double> getTotalByCategory(List<Expense> expenses) {
    Map<String, double> result = {};
    for (var expense in expenses) {
      result[expense.category] =
          (result[expense.category] ?? 0) + expense.amount;
    }
    return result;
  }

  // 2. Mendapatkan pengeluaran tertinggi
  static Expense? getHighestExpense(List<Expense> expenses) {
    if (expenses.isEmpty) return null;
    return expenses.reduce((a, b) => a.amount > b.amount ? a : b);
  }

  // 3. Mendapatkan pengeluaran bulan tertentu
  static List<Expense> getExpensesByMonth(
    List<Expense> expenses,
    int month,
    int year,
  ) {
    return expenses
        .where(
          (expense) => expense.date.month == month && expense.date.year == year,
        )
        .toList();
  }

  // 4. Mencari pengeluaran berdasarkan kata kunci
  static List<Expense> searchExpenses(List<Expense> expenses, String keyword) {
    String lowerKeyword = keyword.toLowerCase();
    return expenses
        .where(
          (expense) =>
              expense.title.toLowerCase().contains(lowerKeyword) ||
              expense.description.toLowerCase().contains(lowerKeyword) ||
              expense.category.toLowerCase().contains(lowerKeyword),
        )
        .toList();
  }

  // 5. Mendapatkan rata-rata pengeluaran harian
  static double getAverageDaily(List<Expense> expenses) {
    if (expenses.isEmpty) return 0;

    double total = expenses.fold(0, (sum, expense) => sum + expense.amount);

    // Hitung jumlah hari unik
    Set<String> uniqueDays =
        expenses
            .map(
              (expense) =>
                  '${expense.date.year}-${expense.date.month}-${expense.date.day}',
            )
            .toSet();

    return total / uniqueDays.length;
  }
}
