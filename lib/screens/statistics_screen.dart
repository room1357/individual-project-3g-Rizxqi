import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/expense_service.dart';
import '../utils/date_utils.dart';
import '../utils/currency_utils.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final _expenseService = ExpenseService();
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    final weeklyTotals = _expenseService.getWeeklyTotalsForMonth(
      selectedMonth,
      selectedYear,
    );

    // ✅ Hitung maksimum Y (dalam kelipatan 100rb)
    final double maxWeekly =
        weeklyTotals.isEmpty
            ? 0.0
            : weeklyTotals.reduce((a, b) => a > b ? a : b).toDouble();

    final double maxY = _expenseService.getNiceMaxY(maxWeekly);

    // ✅ Ambil awal minggu dan jumlah hari bulan
    final weekStarts = DateUtilsHelper.getWeekStartDays(
      selectedYear,
      selectedMonth,
    );
    final daysInMonth = DateUtilsHelper.getDaysInMonth(
      selectedYear,
      selectedMonth,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Statistik ${DateUtilsHelper.getMonthName(selectedMonth)}',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔹 Dropdown bulan
            DropdownButton<int>(
              value: selectedMonth,
              items: List.generate(12, (i) {
                return DropdownMenuItem(
                  value: i + 1,
                  child: Text(DateUtilsHelper.getMonthName(i + 1)),
                );
              }),
              onChanged: (v) => setState(() => selectedMonth = v!),
            ),
            const SizedBox(height: 20),

            // 🔹 Grafik
            Expanded(
              child:
                  weeklyTotals.isEmpty
                      ? const Center(child: Text('Tidak ada data bulan ini'))
                      : BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: maxY,
                          minY: 0,
                          barGroups:
                              weeklyTotals.asMap().entries.map((entry) {
                                final i = entry.key;
                                return BarChartGroupData(
                                  x: i + 1,
                                  barRods: [
                                    BarChartRodData(
                                      toY: entry.value,
                                      width: 18,
                                      borderRadius: BorderRadius.circular(6),
                                      color: Colors.indigo,
                                    ),
                                  ],
                                );
                              }).toList(),

                          // 🔹 Sumbu X dan Y
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (v, meta) {
                                  final weekIndex = v.toInt() - 1;
                                  if (weekIndex < 0 ||
                                      weekIndex >= weekStarts.length) {
                                    return const SizedBox.shrink();
                                  }
                                  final start = weekStarts[weekIndex];
                                  final end =
                                      (start + 6 > daysInMonth)
                                          ? daysInMonth
                                          : start + 6;
                                  final range = DateUtilsHelper.formatWeekRange(
                                    start,
                                    end,
                                    selectedMonth,
                                    selectedYear,
                                  );
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      range,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  );
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 100000, // ✅ kelipatan 100rb
                                reservedSize: 50,
                                getTitlesWidget: (v, meta) {
                                  if (v % 100000 != 0) {
                                    return const SizedBox.shrink();
                                  }
                                  return Text(
                                    CurrencyUtils.format(v),
                                    style: const TextStyle(fontSize: 10),
                                  );
                                },
                              ),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),

                          // 🔹 Grid & Border
                          gridData: FlGridData(
                            show: true,
                            horizontalInterval: 100000,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: Colors.grey.withOpacity(0.2),
                                strokeWidth: 1,
                              );
                            },
                          ),
                          borderData: FlBorderData(show: false),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
