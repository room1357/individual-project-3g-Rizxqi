import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../models/expense.dart';
import '../models/category.dart';
import '../services/category_service.dart';

class ExpenseItem extends StatelessWidget {
  final Expense expense;
  final Category category; // ✅ Parameter dari parent
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ExpenseItem({
    super.key,
    required this.expense,
    required this.category, // ✅ Required
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey(expense.id),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        leading: CircleAvatar(
          backgroundColor: category.color.withOpacity(0.15),
          child: Icon(
            cupertinoIcons[category.iconName] ?? CupertinoIcons.question_circle,
            color: category.color,
            size: 22,
          ),
        ),
        title: Text(
          expense.title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '${category.name} • ${expense.formattedDate}',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              expense.formattedAmount,
              style: TextStyle(
                color: expense.isIncome ? Colors.green : Colors.redAccent,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 4),
            if (onEdit != null)
              IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: Colors.deepPurpleAccent,
                  size: 20,
                ),
                onPressed: onEdit,
                tooltip: 'Edit',
              ),
            if (onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                onPressed: onDelete,
                tooltip: 'Hapus',
              ),
          ],
        ),
      ),
    );
  }
}
