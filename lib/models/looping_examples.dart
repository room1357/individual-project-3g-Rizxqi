import 'expense.dart';

class LoopingExamples {
  // Data dummy untuk latihan
  static List<Expense> sampleExpenses = [
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

  // Hitung total dengan fold
  static double calculateTotalFold() {
    return sampleExpenses.fold(0.0, (sum, e) => sum + e.amount);
  }

  // Cari berdasarkan kategori
  static List<Expense> filterByCategory(String category) {
    return sampleExpenses
        .where((e) => e.category.toLowerCase() == category.toLowerCase())
        .toList();
  }
}
