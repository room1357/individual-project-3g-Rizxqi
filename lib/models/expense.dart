import 'package:intl/intl.dart';

class Expense {
  final String id;
  final String title;
  final double amount;
  final String categoryId; // kategori umum (contoh: Makanan, Transport)
  final DateTime date;
  final String? description; // nullable agar tidak wajib diisi
  final String? service; // opsional: kategori service jika ada
  final bool isIncome;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.categoryId,
    required this.date,
    this.description = '',
    this.service,
    this.isIncome = false,
  });

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
    id: json['id'] as String,
    title: json['title'] as String,
    amount: (json['amount'] as num).toDouble(),
    categoryId: json['categoryId'] as String,
    date: DateTime.parse(json['date'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'amount': amount,
    'categoryId': categoryId,
    'date': date.toIso8601String(),
  };

  // ✅ Format angka ke dalam Rupiah
  String get formattedAmount {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  // ✅ Format tanggal ke format lokal
  String get formattedDate {
    return DateFormat('dd MMM yyyy', 'id_ID').format(date);
  }

  // ✅ Ambil kategori final (prioritaskan service jika ada)
  String get displayCategory {
    return service ?? categoryId;
  }
}
