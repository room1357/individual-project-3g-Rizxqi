import 'expense.dart';

class LoopingExamples {
  // Contoh data dummy
  static List<Expense> expenses = [];

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
