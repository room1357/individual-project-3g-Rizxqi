import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../models/expense_manager.dart';
import 'add_expense_screen.dart';

class AdvancedExpenseListScreen extends StatefulWidget {
  const AdvancedExpenseListScreen({super.key}); // tetap tanpa manager

  @override
  _AdvancedExpenseListScreenState createState() =>
      _AdvancedExpenseListScreenState();
}

class _AdvancedExpenseListScreenState extends State<AdvancedExpenseListScreen> {
  String selectedCategory = 'Semua';
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final manager = context.watch<ExpenseManager>();
    final expenses = manager.expenses;

    // filter realtime
    final filteredExpenses =
        expenses.where((expense) {
          bool matchesSearch =
              searchController.text.isEmpty ||
              expense.title.toLowerCase().contains(
                searchController.text.toLowerCase(),
              ) ||
              expense.category.toLowerCase().contains(
                searchController.text.toLowerCase(),
              ) ||
              expense.description.toLowerCase().contains(
                searchController.text.toLowerCase(),
              );

          bool matchesCategory =
              selectedCategory == 'Semua' ||
              expense.category == selectedCategory;

          return matchesSearch && matchesCategory;
        }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengeluaran Advanced'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // 🔍 Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Cari pengeluaran...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}), // refresh filter
            ),
          ),

          // 📌 Category filter
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children:
                  [
                    'Semua',
                    'Makanan',
                    'Transportasi',
                    'Utilitas',
                    'Hiburan',
                    'Pendidikan',
                  ].map((category) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(category),
                        selected: selectedCategory == category,
                        onSelected: (_) {
                          setState(() => selectedCategory = category);
                        },
                      ),
                    );
                  }).toList(),
            ),
          ),

          // 📊 Statistik ringkasan
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard(
                  'Total',
                  'Rp ${_calculateTotal(filteredExpenses).toStringAsFixed(0)}',
                ),
                _buildStatCard('Jumlah', '${filteredExpenses.length} item'),
                _buildStatCard(
                  'Rata-rata',
                  'Rp ${manager.averageDaily.toStringAsFixed(0)}',
                ),
              ],
            ),
          ),

          // 📃 List pengeluaran
          Expanded(
            child:
                filteredExpenses.isEmpty
                    ? const Center(
                      child: Text('Tidak ada pengeluaran ditemukan'),
                    )
                    : ListView.builder(
                      itemCount: filteredExpenses.length,
                      itemBuilder: (context, index) {
                        final expense = filteredExpenses[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: _getCategoryColor(
                                expense.category,
                              ),
                              child: Icon(
                                _getCategoryIcon(expense.category),
                                color: Colors.white,
                              ),
                            ),
                            title: Text(expense.title),
                            subtitle: Text(
                              '${expense.category} • ${expense.formattedDate}',
                            ),
                            trailing: Text(
                              expense.formattedAmount,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red[600],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) =>
                      AddExpenseScreen(manager: context.read<ExpenseManager>()),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // 📊 Widget statistik
  Widget _buildStatCard(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // 💰 Hitung total
  double _calculateTotal(List<Expense> expenses) {
    return expenses.fold(0.0, (sum, e) => sum + e.amount);
  }

  // 🎭 Icon per kategori
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

  // 🎨 Warna per kategori
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
      builder:
          (_) => AlertDialog(
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
