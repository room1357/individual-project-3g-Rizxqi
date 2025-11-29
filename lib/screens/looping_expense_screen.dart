import 'package:flutter/material.dart';
import '../models/looping_examples.dart';
import '../models/expense.dart';

class LoopingExamplesScreen extends StatelessWidget {
  const LoopingExamplesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Expense> sample = LoopingExamples.sampleExpenses;
    final double total = LoopingExamples.calculateTotalFold();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Latihan Looping"),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.orange.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Dummy",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Rp ${total.toStringAsFixed(0)}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: sample.length,
              itemBuilder: (context, index) {
                final expense = sample[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.receipt_long,
                      color: Colors.deepOrange,
                    ),
                    title: Text(expense.title),
                    subtitle: Text(
                      "${expense.category} • ${expense.formattedDate}\n${expense.description}",
                    ),
                    isThreeLine: true,
                    trailing: Text(
                      expense.formattedAmount,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
