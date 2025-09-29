import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/expense_service.dart';

class AddExpenseScreen extends StatelessWidget {
  AddExpenseScreen({super.key});

  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final ValueNotifier<String> selectedCategory = ValueNotifier<String>(
    'Makanan',
  );

  final List<String> categories = const [
    'Makanan',
    'Transportasi',
    'Utilitas',
    'Hiburan',
    'Pendidikan',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Pengeluaran"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Judul
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Judul Pengeluaran",
                  hintText: "Contoh: Makan siang",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
              ),
              const SizedBox(height: 16),

              // Jumlah
              TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: "Jumlah (Rp)",
                  hintText: "Contoh: 25000",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                  prefixText: "Rp ",
                ),
              ),
              const SizedBox(height: 16),

              // Kategori
              ValueListenableBuilder<String>(
                valueListenable: selectedCategory,
                builder: (context, value, _) {
                  return DropdownButtonFormField<String>(
                    value: value,
                    decoration: const InputDecoration(
                      labelText: "Kategori",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.category),
                    ),
                    items:
                        categories
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(category),
                              ),
                            )
                            .toList(),
                    onChanged: (newValue) {
                      if (newValue != null) {
                        selectedCategory.value = newValue;
                      }
                    },
                  );
                },
              ),
              const SizedBox(height: 16),

              // Deskripsi
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Deskripsi",
                  hintText: "Contoh: Nasi goreng + es teh",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
              ),
              const SizedBox(height: 24),

              // Tombol simpan
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (titleController.text.isEmpty ||
                      amountController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Judul dan Jumlah wajib diisi!"),
                      ),
                    );
                    return;
                  }

                  final expense = Expense(
                    id: DateTime.now().toString(),
                    title: titleController.text,
                    amount: double.tryParse(amountController.text) ?? 0.0,
                    category: selectedCategory.value,
                    date: DateTime.now(),
                    description: descriptionController.text,
                  );

                  // 👉 Simpan ke service
                  ExpenseService.addExpense(expense);

                  // Balik ke layar sebelumnya
                  Navigator.pop(context, expense);
                },
                child: const Text(
                  "Tambah Pengeluaran",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
