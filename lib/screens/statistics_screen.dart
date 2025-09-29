import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/expense_service.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final totalByCategory = ExpenseService.getTotalByCategory();
    final highest = ExpenseService.getHighestExpense();
    final avgDaily = ExpenseService.getAverageDaily();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Statistik Pengeluaran"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // TODO: nanti dipakai untuk export CSV/PDF
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Export data coming soon 🚀")),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 🔹 Info ringkas
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Total Kategori: ${totalByCategory.length}"),
                      Text(
                        "Rata-rata Harian: Rp ${avgDaily.toStringAsFixed(0)}",
                      ),
                      if (highest != null)
                        Text(
                          "Pengeluaran Terbesar: ${highest.title} (Rp ${highest.amount})",
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 🔹 Pie Chart distribusi kategori
              const Text(
                "Distribusi per Kategori",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sections:
                        totalByCategory.entries.map((entry) {
                          final value = entry.value;
                          return PieChartSectionData(
                            value: value,
                            title: entry.key,
                            radius: 50,
                            titleStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 🔹 Bar Chart dummy bulanan
              const Text(
                "Pengeluaran per Bulan",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 250,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    barGroups: List.generate(6, (index) {
                      final month = DateTime.now().month - (5 - index);
                      final data = ExpenseService.getByMonth(
                        month,
                        DateTime.now().year,
                      );
                      final total = data.fold(0.0, (sum, e) => sum + e.amount);

                      return BarChartGroupData(
                        x: month,
                        barRods: [
                          BarChartRodData(
                            toY: total,
                            color: Colors.blue,
                            width: 16,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      );
                    }),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Text("Bln ${value.toInt()}");
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
