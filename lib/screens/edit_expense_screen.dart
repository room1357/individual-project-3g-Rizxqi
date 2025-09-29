import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/expense_service.dart';

class EditExpenseScreen extends StatelessWidget {
  final Expense expense;
  EditExpenseScreen({super.key, required this.expense});

  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // isi awal
    titleController.text = expense.title;
    amountController.text = expense.amount.toString();
    descriptionController.text = expense.description;

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Pengeluaran")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Judul"),
            ),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(labelText: "Jumlah"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: "Deskripsi"),
            ),
            ElevatedButton(
              onPressed: () {
                final updated = Expense(
                  id: expense.id,
                  title: titleController.text,
                  amount: double.tryParse(amountController.text) ?? 0,
                  category: expense.category,
                  date: expense.date,
                  description: descriptionController.text,
                );

                ExpenseService.deleteExpense(expense.id);
                ExpenseService.addExpense(updated);

                Navigator.pop(context);
              },
              child: const Text("Update"),
            ),
          ],
        ),
      ),
    );
  }
}
