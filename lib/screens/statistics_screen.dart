// lib/screens/statistics_screen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/expense.dart';
import '../services/expense_service.dart';
import '../services/category_service.dart';
import '../utils/currency_utils.dart';
import '../utils/date_utils.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final ExpenseService _expenseService = ExpenseService();
  final CategoryService _categoryService = CategoryService();

  List<Expense> expenses = [];
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;
  String selectedPeriod = 'Monthly'; // Weekly, Monthly, Yearly
  bool isLoading = true;

  double totalExpense = 0;
  double totalIncome = 0;
  Map<String, double> categoryExpenses = {};

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    setState(() => isLoading = true);

    // Load expenses and categories
    await _expenseService.loadExpenses();
    await _categoryService.loadCategories();
    final allExpenses = _expenseService.getAllExpenses();

    // Filter by period
    final filteredExpenses = _filterByPeriod(allExpenses);

    // Calculate totals
    double expense = 0;
    double income = 0;
    Map<String, double> catExp = {};

    for (var exp in filteredExpenses) {
      if (exp.isIncome) {
        income += exp.amount;
      } else {
        expense += exp.amount;
        final catName =
            exp.service ??
            _categoryService.getCategoryOrDefault(exp.categoryId).name;
        catExp[catName] = (catExp[catName] ?? 0) + exp.amount;
      }
    }

    setState(() {
      expenses = filteredExpenses;
      totalExpense = expense;
      totalIncome = income;
      categoryExpenses = catExp;
      isLoading = false;
    });
  }

  List<Expense> _filterByPeriod(List<Expense> expenses) {
    return expenses.where((exp) {
      if (selectedPeriod == 'Monthly') {
        return exp.date.month == selectedMonth && exp.date.year == selectedYear;
      }
      return exp.date.year == selectedYear;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Get weekly totals using ExpenseService
    final weeklyTotals = _expenseService.getWeeklyTotalsForMonth(
      selectedMonth,
      selectedYear,
    );

    // Calculate max Y value
    final double maxWeekly =
        weeklyTotals.isEmpty
            ? 0.0
            : weeklyTotals.reduce((a, b) => a > b ? a : b).toDouble();
    final double maxY = _expenseService.getNiceMaxY(maxWeekly);

    // Get week start days
    final weekStarts = DateUtilsHelper.getWeekStartDays(
      selectedYear,
      selectedMonth,
    );
    final daysInMonth = DateUtilsHelper.getDaysInMonth(
      selectedYear,
      selectedMonth,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Header
                    Text(
                      'Statistics ${DateUtilsHelper.getMonthName(selectedMonth)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3142),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Month Selector
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: DropdownButton<int>(
                        value: selectedMonth,
                        isExpanded: true,
                        underline: const SizedBox(),
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: List.generate(12, (i) {
                          return DropdownMenuItem(
                            value: i + 1,
                            child: Text(
                              DateUtilsHelper.getMonthName(i + 1),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }),
                        onChanged: (v) {
                          setState(() => selectedMonth = v!);
                          _loadStatistics();
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Summary Cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildSummaryCard(
                            'Total Income',
                            totalIncome,
                            Icons.arrow_downward,
                            const Color(0xFF4ECB71),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildSummaryCard(
                            'Total Expense',
                            totalExpense,
                            Icons.arrow_upward,
                            const Color(0xFFFF6B6B),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Bar Chart
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Weekly Spending Overview',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3142),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 250,
                            child:
                                weeklyTotals.isEmpty
                                    ? const Center(
                                      child: Text('No data for this month'),
                                    )
                                    : BarChart(
                                      BarChartData(
                                        alignment:
                                            BarChartAlignment.spaceAround,
                                        maxY: maxY,
                                        minY: 0,
                                        barGroups:
                                            weeklyTotals.asMap().entries.map((
                                              entry,
                                            ) {
                                              final i = entry.key;
                                              return BarChartGroupData(
                                                x: i + 1,
                                                barRods: [
                                                  BarChartRodData(
                                                    toY: entry.value,
                                                    width: 18,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          6,
                                                        ),
                                                    gradient:
                                                        const LinearGradient(
                                                          colors: [
                                                            Color(0xFF6C63FF),
                                                            Color(0xFF5A52D5),
                                                          ],
                                                          begin:
                                                              Alignment
                                                                  .bottomCenter,
                                                          end:
                                                              Alignment
                                                                  .topCenter,
                                                        ),
                                                  ),
                                                ],
                                              );
                                            }).toList(),
                                        titlesData: FlTitlesData(
                                          bottomTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              getTitlesWidget: (v, meta) {
                                                final weekIndex = v.toInt() - 1;
                                                if (weekIndex < 0 ||
                                                    weekIndex >=
                                                        weekStarts.length) {
                                                  return const SizedBox.shrink();
                                                }
                                                final start =
                                                    weekStarts[weekIndex];
                                                final end =
                                                    (start + 6 > daysInMonth)
                                                        ? daysInMonth
                                                        : start + 6;
                                                final range =
                                                    DateUtilsHelper.formatWeekRange(
                                                      start,
                                                      end,
                                                      selectedMonth,
                                                      selectedYear,
                                                    );
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        top: 8,
                                                      ),
                                                  child: Text(
                                                    range,
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          leftTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              interval: 100000,
                                              reservedSize: 60,
                                              getTitlesWidget: (v, meta) {
                                                if (v % 100000 != 0) {
                                                  return const SizedBox.shrink();
                                                }
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        right: 8,
                                                      ),
                                                  child: Text(
                                                    CurrencyUtils.format(v),
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          rightTitles: const AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: false,
                                            ),
                                          ),
                                          topTitles: const AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: false,
                                            ),
                                          ),
                                        ),
                                        gridData: FlGridData(
                                          show: true,
                                          horizontalInterval: 100000,
                                          getDrawingHorizontalLine: (value) {
                                            return FlLine(
                                              color: Colors.grey.withOpacity(
                                                0.2,
                                              ),
                                              strokeWidth: 1,
                                            );
                                          },
                                          drawVerticalLine: false,
                                        ),
                                        borderData: FlBorderData(show: false),
                                        barTouchData: BarTouchData(
                                          enabled: true,
                                          touchTooltipData: BarTouchTooltipData(
                                            getTooltipItem: (
                                              group,
                                              groupIndex,
                                              rod,
                                              rodIndex,
                                            ) {
                                              return BarTooltipItem(
                                                CurrencyUtils.format(rod.toY),
                                                const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Category Breakdown
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Expense by Category',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3142),
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (categoryExpenses.isEmpty)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Text('No data available'),
                              ),
                            )
                          else
                            ...categoryExpenses.entries.map((entry) {
                              final percentage =
                                  totalExpense > 0
                                      ? (entry.value / totalExpense * 100)
                                      : 0.0;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: _buildCategoryItem(
                                  entry.key,
                                  entry.value,
                                  percentage,
                                ),
                              );
                            }).toList(),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    double amount,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          const SizedBox(height: 4),
          Text(
            CurrencyUtils.format(amount),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3142),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String category, double amount, double percentage) {
    final colors = [
      const Color(0xFF6C63FF),
      const Color(0xFFFF6B6B),
      const Color(0xFF4ECB71),
      const Color(0xFFFFA502),
      const Color(0xFF9C88FF),
    ];
    final color = colors[category.hashCode % colors.length];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  category,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3142),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  CurrencyUtils.format(amount),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
                  ),
                ),
                Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
