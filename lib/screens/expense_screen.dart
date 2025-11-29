import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../models/expense.dart';
import '../models/category.dart';
import '../services/expense_service.dart';
import '../services/category_service.dart';
import '../screens/add_expenses_screen.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ExpenseScreenState createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  final ExpenseService _expenseService = ExpenseService();
  final CategoryService _categoryService = CategoryService(); // Asumsikan ada
  List<Expense> _expenses = [];
  List<Category> _categories = [];
  bool _isLoading = true;

  String selectedCategoryId = 'all'; // 'all' untuk semua, atau ID kategori
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _expenseService.loadExpenses();
    await _categoryService.loadCategories();
    setState(() {
      _expenses = _expenseService.getAllExpenses();
      _categories = _categoryService.getAll();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filter realtime berdasarkan search dan kategori
    final filteredExpenses =
        _expenses.where((expense) {
          final displayCategory =
              expense.displayCategory; // Menggunakan displayCategory dari model
          bool matchesSearch =
              searchController.text.isEmpty ||
              expense.title.toLowerCase().contains(
                searchController.text.toLowerCase(),
              ) ||
              displayCategory.toLowerCase().contains(
                searchController.text.toLowerCase(),
              ) ||
              (expense.description?.toLowerCase().contains(
                    searchController.text.toLowerCase(),
                  ) ??
                  false);

          bool matchesCategory =
              selectedCategoryId == 'all' ||
              expense.categoryId == selectedCategoryId;

          return matchesSearch && matchesCategory;
        }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('List Pengeluaran'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
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
                      onChanged: (_) => setState(() {}), // Refresh filter
                    ),
                  ),

                  // 📌 Category filter
                  SizedBox(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        // Tambah 'Semua'
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: const Text('Semua'),
                            selected: selectedCategoryId == 'all',
                            onSelected: (_) {
                              setState(() => selectedCategoryId = 'all');
                            },
                          ),
                        ),
                        // Kategori dari CategoryService
                        ..._categories.map((category) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(category.name),
                              selected: selectedCategoryId == category.id,
                              onSelected: (_) {
                                setState(
                                  () => selectedCategoryId = category.id,
                                );
                              },
                            ),
                          );
                        }),
                      ],
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
                        _buildStatCard(
                          'Jumlah',
                          '${filteredExpenses.length} item',
                        ),
                        _buildStatCard(
                          'Rata-rata',
                          'Rp ${_calculateAverage(filteredExpenses).toStringAsFixed(0)}',
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
                                final category = _categoryService
                                    .getCategoryOrDefault(expense.categoryId);
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 4,
                                  ),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: category.color
                                          .withOpacity(0.15),
                                      child: Icon(
                                        _getCategoryIcon(category.iconName),
                                        color: category.color,
                                      ),
                                    ),
                                    title: Text(expense.title),
                                    subtitle: Text(
                                      '${expense.displayCategory} • ${expense.formattedDate}',
                                    ),
                                    trailing: SizedBox(
                                      width: 120,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            expense.formattedAmount,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red[600],
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.edit,
                                              size: 20,
                                              color: Colors.blue,
                                            ),
                                            onPressed: () {
                                              _editExpense(context, expense);
                                            },
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                          ),
                                          const SizedBox(width: 4),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.delete,
                                              size: 20,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              _deleteExpense(expense);
                                            },
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap:
                                        () => _showExpenseDetails(
                                          context,
                                          expense,
                                        ),
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
            MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
          ).then((_) => _loadData()); // Reload setelah add
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

  // 📈 Hitung rata-rata harian (asumsi berdasarkan hari unik)
  double _calculateAverage(List<Expense> expenses) {
    if (expenses.isEmpty) return 0.0;
    final uniqueDays =
        expenses
            .map((e) => e.date.toIso8601String().split('T')[0])
            .toSet()
            .length;
    return uniqueDays > 0 ? _calculateTotal(expenses) / uniqueDays : 0.0;
  }

  // 🎭 Icon dari iconName
  IconData _getCategoryIcon(String iconName) {
    final Map<String, IconData> cupertinoIconsMap = {
      'housing': CupertinoIcons.house,
      'utilities': CupertinoIcons.bolt,
      'food_drink': CupertinoIcons.cart,
      'transportation': CupertinoIcons.car_detailed,
      'health': CupertinoIcons.heart,
      'savings': CupertinoIcons.briefcase,
      'entertainment': CupertinoIcons.game_controller,
      'shopping': CupertinoIcons.bag,
      'education': CupertinoIcons.book,
      'other': CupertinoIcons.question_circle,
    };
    return cupertinoIconsMap[iconName] ?? CupertinoIcons.question_circle;
  }

  // ✏️ Edit expense
  void _editExpense(BuildContext context, Expense expense) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
    ).then((_) => _loadData());
  }

  // 🗑️ Delete expense
  void _deleteExpense(Expense expense) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Hapus Pengeluaran?'),
            content: Text(
              'Apakah kamu yakin ingin menghapus "${expense.title}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () {
                  _expenseService.deleteExpense(expense.id);
                  _loadData();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pengeluaran dihapus')),
                  );
                },
                child: const Text('Hapus', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
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
                Text("Kategori: ${expense.displayCategory}"),
                Text("Tanggal: ${expense.formattedDate}"),
                Text("Deskripsi: ${expense.description ?? 'Tidak ada'}"),
                if (expense.service != null)
                  Text("Service: ${expense.service}"),
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
