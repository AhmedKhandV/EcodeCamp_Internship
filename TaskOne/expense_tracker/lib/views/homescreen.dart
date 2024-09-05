import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/model/expense.dart';
import 'package:expense_tracker/viewmodels/expense_viewmodel.dart';
import 'package:expense_tracker/views/add_edit_expense_screen.dart';
import 'package:expense_tracker/views/all_transactions_screen.dart';
import 'package:expense_tracker/views/user_preferences.dart'; // Import the UserPreferences helper class

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  double totalBudget = 1000.0; 
  String username = 'User'; 
  double salary = 0.0; 

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ExpenseViewModel>(context, listen: false).loadExpenses();
      _loadUserDetails(); 
    });
  }

  Future<void> _loadUserDetails() async {
    final userDetails = await UserPreferences.getUserDetails();
    setState(() {
      username = userDetails['name'];
      salary = userDetails['salary'];
      totalBudget = salary; 
    });
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(44)),
        ),
        builder: (context) => Container(
          height: MediaQuery.of(context).size.height * 0.72,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: AddEditExpenseScreen(),
        ),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AllTransactionsScreen()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 100,
        title: Row(
          children: [
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hi,', style: TextStyle(color: Colors.grey, fontSize: 16)),
                  Text(username, style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
      body: _selectedIndex == 0
          ? Consumer<ExpenseViewModel>(
        builder: (context, expenseViewModel, child) {
          List<Expense> sortedExpenses = List.from(expenseViewModel.expenses)
            ..sort((a, b) => b.date.compareTo(a.date));

          double totalBalance = sortedExpenses.fold(0.0, (sum, e) => sum + e.amount);
          double expenses = sortedExpenses.where((e) => e.amount < 0).fold(0.0, (sum, e) => sum + e.amount).abs();

          double progressValue = expenses / totalBudget;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFF183856),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: Text('Total Expenses', style: TextStyle(color: Colors.white70))),
                      SizedBox(height: 8),
                      Center(
                        child: Text(
                          '\$${totalBalance.toStringAsFixed(2)}',
                          style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 2, blurRadius: 5)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Monthly Budget', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text('Keep it up! You can save \$${(totalBudget - totalBalance).toStringAsFixed(2)} this month'),
                      SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: progressValue.clamp(0.0, 1.0), 
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Spent: \$${totalBalance.toStringAsFixed(2)}', style: TextStyle(color: Colors.red)),
                          Text('Left: \$${(totalBudget - totalBalance).toStringAsFixed(2)}', style: TextStyle(color: Colors.blue)),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Recent Transactions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AllTransactionsScreen()));
                      },
                      child: Text('See all', style: TextStyle(color: Colors.blue)),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Column(
                  children: List.generate(
                    sortedExpenses.take(3).length,
                        (index) {
                      final expense = sortedExpenses[index];
                      final color = _getCategoryColor(expense.category);
                      final icon = _getCategoryIcon(expense.category);

                      return Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: color,
                              child: Icon(icon, color: Colors.white),
                            ),
                            title: Text(expense.title),
                            subtitle: Text('${expense.date.toLocal().toString().split(' ')[0]}'),
                            trailing: Text(
                              '${expense.amount >= 0 ? '+' : '-'} \$${expense.amount.abs().toStringAsFixed(2)}',
                              style: TextStyle(color: color, fontWeight: FontWeight.bold),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddEditExpenseScreen(expense: expense),
                                ),
                              );
                            },
                          ),
                          Divider(),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      )
          : _selectedIndex == 2
          ? Container()
          : Container(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'See All'),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
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
}
