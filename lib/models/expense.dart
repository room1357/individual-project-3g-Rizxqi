import 'package:intl/intl.dart';

class Expense {
  final String id;
  final String title;
  final double amount;
  final String category; // kategori umum (contoh: Makanan, Transport)
  final DateTime date;
  final String? description; // nullable agar tidak wajib diisi
  final String? service; // opsional: kategori service jika ada

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.description,
    this.service,
  });

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
    return service ?? category;
  }
}
