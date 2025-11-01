import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:pemrograman_mobile/screens/add_expenses_screen.dart';
import 'package:pemrograman_mobile/screens/edit_expense_screen.dart';
import 'package:pemrograman_mobile/services/expense_service.dart';
import '../models/expense.dart';
import '../services/category_service.dart';
import '../models/category.dart';
import 'package:pemrograman_mobile/widget/expense_item.dart';

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  final ExpenseService expenseService = ExpenseService();
  final categoryService = CategoryService();
  late final NumberFormat currency;
  final searchController = TextEditingController();
  Timer? _debounce;
  bool isLoading = true;
  final ValueNotifier<List<Expense>> filteredExpensesNotifier =
      ValueNotifier<List<Expense>>([]);
  final ValueNotifier<double> totalAllExpenseNotifier = ValueNotifier<double>(
    0.0,
  );
  final ValueNotifier<double> filteredTotalNotifier = ValueNotifier<double>(
    0.0,
  );
  final ValueNotifier<String> selectedCategoryIdNotifier =
      ValueNotifier<String>('Semua');
  List<Category> categories = [];
  List<Expense> expenses = [];
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    _initializeData();
  }

  @override
  void dispose() {
    // ✅ Update dispose agar lebih ringan
    _debounce?.cancel();
    searchController.dispose();
    filteredExpensesNotifier.dispose();
    totalAllExpenseNotifier.dispose();
    filteredTotalNotifier.dispose();
    selectedCategoryIdNotifier.dispose();
    super.dispose();
  }

  void _initializeData() {
    // ✅
    setState(() => isLoading = true);
    //await Future.delayed(const Duration(seconds: 2));
    if (categories.isEmpty) {
      categories = categoryService.getAll();
    }

    expenses = expenseService.getAllExpenses();
    totalAllExpenseNotifier.value = _calculateTotal(expenses);
    _filterExpenses();

    // ✅
    setState(() => isLoading = false);
  }

  void _onSearchChanged(String value) {
    setState(() => isSearching = true);
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _filterExpenses();
      setState(() => isSearching = false);
    });
  }

  void _filterExpenses() {
    // debugPrint('🔍 Filter dipanggil');

    final searchText = searchController.text.toLowerCase();
    final selectedCategory = selectedCategoryIdNotifier.value;

    final filtered =
        expenses.where((e) {
          final matchesSearch =
              searchText.isEmpty || e.title.toLowerCase().contains(searchText);
          final matchesCategory =
              selectedCategory == 'Semua' || e.categoryId == selectedCategory;
          return matchesSearch && matchesCategory;
        }).toList();

    filteredExpensesNotifier.value = filtered;
    filteredTotalNotifier.value = _calculateTotal(filtered);
  }

  double _calculateTotal(List<Expense> list) =>
      list.fold(0, (sum, e) => sum + e.amount);

  void _showExpenseDetails(Expense e) {
    final category = _getCategoryForExpense(e.categoryId); // ✅ Pakai helper

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
                Text("Kategori: ${category.name}"), // ✅ Pakai dari helper
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

  // Helper method untuk cari category
  Category _getCategoryForExpense(String categoryId) {
    return categoryService.getCategoryOrDefault(categoryId);
    // return categories.firstWhere(
    //   (cat) => cat.id == categoryId,
    //   orElse:
    //       () => Category(
    //         id: '0',
    //         name: 'Lain-lain',
    //         iconName: 'other',
    //         color: Colors.grey,
    //       ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
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
      body:
          isLoading
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      color: Colors.deepPurpleAccent,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Memuat data...',
                      style: GoogleFonts.poppins(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              )
              : Column(
                children: [
                  _GradientCard(
                    currency: currency,
                    totalAllExpenseNotifier: totalAllExpenseNotifier,
                  ),
                  _SearchBar(
                    controller: searchController,
                    onChanged: _onSearchChanged,
                    isSearching: isSearching,
                  ),
                  _CategoryChips(
                    categories: categories,
                    selectedCategoryIdNotifier: selectedCategoryIdNotifier,
                    onChanged: _filterExpenses,
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ValueListenableBuilder<List<Expense>>(
                      valueListenable: filteredExpensesNotifier,
                      builder: (context, filteredExpenses, _) {
                        if (filteredExpenses.isEmpty) {
                          return const Center(
                            child: Text('Belum ada pengeluaran'),
                          );
                        }
                        return ListView.builder(
                          itemCount: filteredExpenses.length,
                          itemBuilder: (ctx, i) {
                            final e = filteredExpenses[i];
                            final category = _getCategoryForExpense(
                              e.categoryId,
                            ); // ✅ Fetch 1x

                            return ExpenseItem(
                              expense: e,
                              category: category, // ✅ Pass ke widget
                              onTap: () => _showExpenseDetails(e),
                              onEdit: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => EditExpenseScreen(expense: e),
                                  ),
                                );
                                _initializeData();
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newExp = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
          );
          if (!mounted) return;
          if (newExp != null && newExp is Expense) {
            _initializeData();
            // ignore: use_build_context_synchronously
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
        backgroundColor: Colors.deepPurpleAccent,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}

class _GradientCard extends StatelessWidget {
  final NumberFormat currency;
  final ValueNotifier<double> totalAllExpenseNotifier;
  const _GradientCard({
    required this.currency,
    required this.totalAllExpenseNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: totalAllExpenseNotifier,
      builder: (context, total, _) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF7B61FF), Color(0xFFFB7BA2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Balance',
                style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 8),
              Text(
                currency.format(total),
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Expanded(
                    child: _MiniStat(label: 'Income', value: 'Rp 0'),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _MiniStat(
                      label: 'Expenses',
                      value: currency.format(
                        total,
                      ), // ✅ Pakai total dari ValueListenableBuilder
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
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

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool isSearching;
  const _SearchBar({
    required this.controller,
    required this.onChanged,
    this.isSearching = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: 'Cari pengeluaran...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon:
              isSearching
                  ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                  : null,
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
    );
  }
}

class _CategoryChips extends StatelessWidget {
  final List<Category> categories;
  final ValueNotifier<String> selectedCategoryIdNotifier;
  final VoidCallback onChanged;

  const _CategoryChips({
    required this.categories,
    required this.selectedCategoryIdNotifier,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final allCats = [
      Category(
        id: 'Semua',
        name: 'Semua',
        iconName: 'other',
        color: Colors.black54,
      ),
      ...categories,
    ];

    return ValueListenableBuilder<String>(
      valueListenable: selectedCategoryIdNotifier,
      builder: (context, selectedCategoryId, _) {
        return SizedBox(
          height: 46,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: allCats.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final cat = allCats[i];
              final selected = selectedCategoryId == cat.id;
              return ChoiceChip(
                label: Text(cat.name, style: GoogleFonts.poppins()),
                selected: selected,
                onSelected: (v) {
                  if (v) {
                    selectedCategoryIdNotifier.value = cat.id;
                    onChanged(); // ✅ Panggil tanpa argumen
                  }
                },
              );
            },
          ),
        );
      },
    );
  }
}
