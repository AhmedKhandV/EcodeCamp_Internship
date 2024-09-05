import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/model/expense.dart';
import 'package:expense_tracker/viewmodels/expense_viewmodel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'add_edit_expense_screen.dart';

class AllTransactionsScreen extends StatefulWidget {
  @override
  _AllTransactionsScreenState createState() => _AllTransactionsScreenState();
}

class _AllTransactionsScreenState extends State<AllTransactionsScreen> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final expenseViewModel = Provider.of<ExpenseViewModel>(context);
    final expenses = expenseViewModel.expenses;

    // Sort expenses by date in descending order
    expenses.sort((a, b) => b.date.compareTo(a.date));

    if (expenses.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Analytics', style: TextStyle(fontFamily: 'Inter')),
          elevation: 0,
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(icon: Icon(Icons.pie_chart), text: 'Pie Chart'),
              Tab(icon: Icon(Icons.bar_chart), text: 'Bar Chart'),
            ],
          ),
        ),
        body: Center(
          child: Text(
            'No transactions available.',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
        ),
      );
    }

    double totalExpenses = expenses.fold(0.0, (sum, e) => sum + e.amount.abs());

    Map<String, double> categoryTotals = {};
    for (var expense in expenses) {
      final category = expense.category;
      final amount = expense.amount.abs();
      categoryTotals[category] = (categoryTotals[category] ?? 0) + amount;
    }

    List<PieChartSectionData> pieChartSections = categoryTotals.entries.map((entry) {
      final category = entry.key;
      final amount = entry.value;
      final percentage = totalExpenses > 0 ? (amount / totalExpenses) : 0;

      return PieChartSectionData(
        value: amount,
        title: '${(percentage * 100).toStringAsFixed(1)}%',
        color: _getCategoryColor(category),
        radius: 80,
        titleStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    List<BarChartGroupData> barChartGroups = categoryTotals.entries.map((entry) {
      final category = entry.key;
      final amount = entry.value;

      return BarChartGroupData(
        x: categoryTotals.keys.toList().indexOf(category),
        barRods: [
          BarChartRodData(
            toY: amount,
            color: _getCategoryColor(category),
            width: 20,
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
          ),
        ],
      );
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Analytics', style: TextStyle(fontFamily: 'Inter')),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.pie_chart), text: 'Pie Chart'),
            Tab(icon: Icon(Icons.bar_chart), text: 'Bar Chart'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Pie Chart with optimization
                AspectRatio(
                  aspectRatio: 1.0,
                  child: Card(
                    margin: EdgeInsets.all(16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: PieChart(
                        PieChartData(
                          sections: pieChartSections,
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 2,
                          centerSpaceRadius: 50,
                          centerSpaceColor: Colors.white,
                          startDegreeOffset: 270,
                        ),
                      ),
                    ),
                  ),
                ),
                // Bar Chart with optimization
                AspectRatio(
                  aspectRatio: 1.0,
                  child: Card(
                    margin: EdgeInsets.all(16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: BarChart(
                        BarChartData(
                          titlesData: FlTitlesData(
                            show: true,
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 60,
                                getTitlesWidget: (value, meta) {
                                  final intValue = value.toInt();
                                  return Text(
                                    '${(intValue / 100).toInt() * 100}', // Format to nearest 100
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  );
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) {
                                  final index = value.toInt();
                                  final category = categoryTotals.keys.toList()[index];
                                  return SideTitleWidget(
                                    axisSide: meta.axisSide,
                                    child: Text(
                                      category,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          borderData: FlBorderData(show: false),
                          gridData: FlGridData(
                            show: true,
                            drawHorizontalLine: true,
                            horizontalInterval: 100, // Set horizontal interval to 100
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: Colors.grey[300],
                                strokeWidth: 1,
                              );
                            },
                          ),
                          barGroups: barChartGroups,
                          alignment: BarChartAlignment.spaceAround,
                          minY: 100, // Start y-axis from 100
                          maxY: (categoryTotals.values.reduce((a, b) => a > b ? a : b) / 100).ceil() * 100, // Adjust maxY to be in hundreds
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey[300]),
          Expanded(
            child: ListView.separated(
              itemCount: expenses.length,
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey[300],
                height: 1,
                indent: 72,
                endIndent: 16,
              ),
              itemBuilder: (context, index) {
                final expense = expenses[index];
                final color = _getCategoryColor(expense.category);

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: color.withOpacity(0.2),
                    child: Icon(_getCategoryIcon(expense.category), color: color),
                  ),
                  title: Text(expense.title, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    '${expense.date.toLocal().toString().split(' ')[0]}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  trailing: Text(
                    '${expense.amount >= 0 ? '+' : '-'} \$${expense.amount.abs().toStringAsFixed(2)}',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddEditExpenseScreen(expense: expense),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Bills':
        return Colors.orangeAccent;
      case 'Transport':
        return Colors.green;
      case 'Entertainment':
        return Colors.orange;
      case 'Food':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Bills':
        return Icons.receipt;
      case 'Transport':
        return Icons.directions_car;
      case 'Entertainment':
        return Icons.movie;
      case 'Food':
        return Icons.restaurant;
      default:
        return Icons.category;
    }
  }
}
