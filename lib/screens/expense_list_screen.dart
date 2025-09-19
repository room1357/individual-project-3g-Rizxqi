import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../models/expense_manager.dart';

class ExpenseListScreen extends StatelessWidget {
  const ExpenseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expenses = ExpenseManager.expenses;
    final avgDaily = ExpenseManager.getAverageDaily(expenses);
    final highestExpense = ExpenseManager.getHighestExpense(expenses);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pengeluaran'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // 📊 Ringkasan
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard(
                  'Total',
                  'Rp ${expenses.fold(0.0, (s, e) => s + e.amount).toStringAsFixed(0)}',
                ),
                _buildStatCard('Jumlah', '${expenses.length} item'),
                _buildStatCard('Rata-rata', 'Rp ${avgDaily.toStringAsFixed(0)}'),
              ],
            ),
          ),
          if (highestExpense != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                "Tertinggi: ${highestExpense.title} - ${highestExpense.formattedAmount}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

          // 📃 List pengeluaran
          Expanded(
            child: ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final expense = expenses[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getCategoryColor(expense.category),
                      child: Icon(
                        _getCategoryIcon(expense.category),
                        color: Colors.white,
                      ),
                    ),
                    title: Text(expense.title),
                    subtitle: Text("${expense.category} • ${expense.formattedDate}"),
                    trailing: Text(
                      expense.formattedAmount,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    onTap: () => _showExpenseDetails(context, expense),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 📊 Widget ringkasan
  Widget _buildStatCard(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  // 🎭 Icon kategori
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Makanan':
        return Icons.fastfood;
      case 'Transportasi':
        return Icons.directions_car;
      case 'Utilitas':
        return Icons.lightbulb;
      case 'Hiburan':
        return Icons.movie;
      case 'Pendidikan':
        return Icons.school;
      default:
        return Icons.attach_money;
    }
  }

  // 🎨 Warna kategori
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Makanan':
        return Colors.orange;
      case 'Transportasi':
        return Colors.green;
      case 'Utilitas':
        return Colors.blue;
      case 'Hiburan':
        return Colors.purple;
      case 'Pendidikan':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  // 📋 Detail popup
  void _showExpenseDetails(BuildContext context, Expense expense) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(expense.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Jumlah: ${expense.formattedAmount}"),
            Text("Kategori: ${expense.category}"),
            Text("Tanggal: ${expense.formattedDate}"),
            Text("Deskripsi: ${expense.description}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tutup"),
          ),
        ],
      ),
    );
  }
}
