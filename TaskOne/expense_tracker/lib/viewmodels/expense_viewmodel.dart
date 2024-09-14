import 'package:expense_tracker/model/expense.dart';
import 'package:expense_tracker/repository/expense_repository.dart';
import 'package:expense_tracker/services/shared_preferences_helper.dart';
import 'package:flutter/material.dart';

class ExpenseViewModel extends ChangeNotifier {
  List<Expense> _expenses = [];
  final ExpenseRepository _expenseRepository = ExpenseRepository();
  final SharedPreferencesHelper _sharedPreferencesHelper = SharedPreferencesHelper();

  List<Expense> get expenses => _expenses;

  Future<void> loadExpenses() async {
    _expenses = await _expenseRepository.getExpenses();
    notifyListeners();
  }

  Future<void> addExpense(Expense expense) async {
    final newExpense = await _expenseRepository.addExpense(expense);
    _expenses.add(newExpense);
    notifyListeners();
  }

  Future<void> updateExpense(Expense expense) async {
    await _expenseRepository.updateExpense(expense);
    final index = _expenses.indexWhere((e) => e.id == expense.id);
    if (index != -1) {
      _expenses[index] = expense;
      notifyListeners();
    }
  }

  Future<void> deleteExpense(int id) async {
    await _expenseRepository.deleteExpense(id);
    _expenses.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  Future<void> saveBudget(double budget) async {
    await _sharedPreferencesHelper.saveBudget(budget);
  }

  Future<double?> getBudget() async {
    return await _sharedPreferencesHelper.getBudget();
  }

  Future<void> saveLastUsedCategory(String category) async {
    await _sharedPreferencesHelper.saveLastUsedCategory(category);
  }

  // Get the last used category from shared preferences
  Future<String?> getLastUsedCategory() async {
    return await _sharedPreferencesHelper.getLastUsedCategory();
  }

  // Get total spendings for a given month
  double getMonthlyTotal(DateTime month) {
    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 0);
    return _expenses
        .where((e) => e.date.isAfter(startOfMonth) && e.date.isBefore(endOfMonth))
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  // Get total spendings for each category
  Map<String, double> getCategoryTotals() {
    final totals = <String, double>{};
    for (var expense in _expenses) {
      if (!totals.containsKey(expense.category)) {
        totals[expense.category] = 0.0;
      }
      totals[expense.category] = totals[expense.category]! + expense.amount;
    }
    return totals;
  }

  // Get monthly totals for the past 12 months
  List<double> getYearlyTotals() {
    final now = DateTime.now();
    final totals = List.generate(12, (index) {
      final month = DateTime(now.year, now.month - index, 1);
      return getMonthlyTotal(month);
    });
    return totals.reversed.toList();
  }
}
