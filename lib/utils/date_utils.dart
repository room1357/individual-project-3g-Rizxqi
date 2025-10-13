import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String get monthName {
    const monthNames = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return monthNames[month - 1];
  }

  String get formattedFull {
    return DateFormat('EEE, dd MMM yyyy', 'id_ID').format(this);
  }

  String get shortMonth {
    const shortNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return shortNames[month - 1];
  }
}

class DateUtilsHelper {
  /// ✅ Jumlah hari dalam bulan
  static int getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  /// ✅ Ambil list tanggal awal setiap minggu dalam bulan
  /// Contoh output: [1, 8, 15, 22, 29]
  static List<int> getWeekStartDays(int year, int month) {
    final daysInMonth = getDaysInMonth(year, month);
    final List<int> starts = [];
    for (int i = 1; i <= daysInMonth; i += 7) {
      starts.add(i);
    }
    return starts;
  }

  /// ✅ Nama bulan by angka
  static String getMonthName(int month) {
    const names = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return names[month - 1];
  }

  /// ✅ Format rentang tanggal (misal: 1–7 Okt 2025)
  static String formatWeekRange(int start, int end, int month, int year) {
    final startDate = DateTime(year, month, start);
    final endDate = DateTime(year, month, end);
    final fmt = DateFormat('d MMM', 'id_ID');
    return '${fmt.format(startDate)} – ${fmt.format(endDate)}';
  }
}
