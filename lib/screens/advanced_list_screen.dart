// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pemrograman_mobile/screens/add_expenses_screen.dart';
import 'package:pemrograman_mobile/screens/edit_expense_screen.dart';
import 'package:pemrograman_mobile/screens/statistics_screen.dart';
import 'package:pemrograman_mobile/services/expense_service.dart';
import '../models/expense.dart';
// import 'add_expense_screen.dart';
// import 'transaction_screen.dart';

class AdvancedListScreen extends StatefulWidget {
  const AdvancedListScreen({super.key});
  @override
  State<AdvancedListScreen> createState() => _AdvancedListScreenState();
}

final expenseService = ExpenseService(); // Singleton instance

class _AdvancedListScreenState extends State<AdvancedListScreen> {
  final expenseService = ExpenseService(); // gunakan singleton
  late List<Expense> expenses;
  List<Expense> filteredExpenses = [];
  String selectedCategory = 'Semua';
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    expenses = expenseService.getAllExpenses();
    filteredExpenses = List.from(expenses);
  }

  double _calculateTotal(List<Expense> exps) =>
      exps.fold(0.0, (s, e) => s + e.amount);

  void _filterExpenses() {
    setState(() {
      filteredExpenses =
          expenses.where((e) {
            final matchesSearch =
                searchController.text.isEmpty ||
                e.title.toLowerCase().contains(
                  searchController.text.toLowerCase(),
                );
            final matchesCat =
                selectedCategory == 'Semua' || e.category == selectedCategory;
            return matchesSearch && matchesCat;
          }).toList();
    });
  }

  Color _getCategoryColor(String cat) {
    switch (cat) {
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

  IconData _getCategoryIcon(String cat) {
    switch (cat) {
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

  void _showExpenseDetails(Expense e) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(e.title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Jumlah: ${e.formattedAmount}"),
                // tampilkan kategori dari service jika tersedia
                Text("Kategori: ${e.service ?? e.category}"),
                Text("Tanggal: ${e.formattedDate}"),
                if ((e.description ?? '').isNotEmpty)
                  Text("Deskripsi: ${e.description}"),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Tutup"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    final total = _calculateTotal(filteredExpenses);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      // transparent appbar so it looks like in the reference
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
        title: Text(
          'Hello, John Doe',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
        ],
      ),
      body: Column(
        children: [
          // Gradient card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF7B61FF), Color(0xFFFB7BA2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12.withValues(alpha: 0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Balance',
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  currency.format(total),
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _miniStat('Income', 'Rp 2.500.000')),
                    const SizedBox(width: 12),
                    Expanded(child: _miniStat('Expenses', 'Rp 800.000')),
                  ],
                ),
              ],
            ),
          ),

          // search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextField(
              controller: searchController,
              onChanged: (_) => _filterExpenses(),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Cari pengeluaran...',
                prefixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Categories horizontal like chips
          SizedBox(
            height: 46,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              children:
                  [
                    'Semua',
                    'Makanan',
                    'Transportasi',
                    'Utilitas',
                    'Hiburan',
                    'Pendidikan',
                  ].map((cat) {
                    final sel = selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(cat, style: GoogleFonts.poppins()),
                        selected: sel,
                        onSelected: (v) {
                          setState(() {
                            selectedCategory = cat;
                            _filterExpenses();
                          });
                        },
                        selectedColor: Colors.deepPurpleAccent.withValues(
                          alpha: 0.15,
                        ),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),

          const SizedBox(height: 8),

          // Expense list
          Expanded(
            child:
                filteredExpenses.isEmpty
                    ? const Center(child: Text('Belum ada pengeluaran'))
                    : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount: filteredExpenses.length,
                      itemBuilder: (ctx, i) {
                        final e = filteredExpenses[i];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12.withValues(alpha: 0.03),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ListTile(
                            onTap: () => _showExpenseDetails(e),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: _getCategoryColor(
                                  e.category,
                                ).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                _getCategoryIcon(e.category),
                                color: _getCategoryColor(e.category),
                              ),
                            ),
                            title: Text(
                              e.title,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              '${e.category} • ${e.formattedDate}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  e.formattedAmount,
                                  style: const TextStyle(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                  onPressed: () async {
                                    final updatedExpense = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) =>
                                                EditExpenseScreen(expense: e),
                                      ),
                                    );

                                    if (updatedExpense != null &&
                                        updatedExpense is Expense) {
                                      setState(() {
                                        expenses =
                                            expenseService.getAllExpenses();
                                        _filterExpenses();
                                      });

                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: const Text(
                                            'Pengeluaran berhasil diperbarui',
                                          ),
                                          backgroundColor:
                                              Colors.deepPurpleAccent.shade100,
                                          behavior: SnackBarBehavior.floating,
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),

      // Bottom center FAB + minimal bottom bar like reference
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: FloatingActionButton(
          onPressed: () async {
            final newExp = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
            );

            if (!mounted) return; // ✅ setelah await
            if (newExp != null && newExp is Expense) {
              setState(() {
                expenses = expenseService.getAllExpenses();
                _filterExpenses();
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Pengeluaran berhasil ditambahkan'),
                  backgroundColor: Colors.deepPurpleAccent.shade100,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
          elevation: 5,
          backgroundColor: Colors.deepPurpleAccent,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: Colors.white, size: 30),
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: Colors.white,
        elevation: 8,
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              Expanded(
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.grid_view_outlined),
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const StatisticsScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.bar_chart_outlined),
                ),
              ),
              Expanded(child: Container()), // center space for FAB
              Expanded(
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.pie_chart_outline),
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.person_outline),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _miniStat(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
