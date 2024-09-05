import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/viewmodels/expense_viewmodel.dart';
import 'package:expense_tracker/views/homescreen.dart';
import 'package:expense_tracker/views/userdetails_view.dart';
import 'package:expense_tracker/views/splashscreen_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isDetailsCompleted = await _checkIfUserDetailsCompleted();
  runApp(MyApp(isDetailsCompleted: isDetailsCompleted));
}

Future<bool> _checkIfUserDetailsCompleted() async {
  final prefs = await SharedPreferences.getInstance();
  final name = prefs.getString('name');
  return name != null && name.isNotEmpty;
}

class MyApp extends StatelessWidget {
  final bool isDetailsCompleted;

  MyApp({required this.isDetailsCompleted});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ExpenseViewModel()),
      ],
      child: MaterialApp(
        title: 'Expense Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: isDetailsCompleted ? HomeScreen() : UserdetailsView(),
      ),
    );
  }
}
