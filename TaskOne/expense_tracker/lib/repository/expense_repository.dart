import 'package:expense_tracker/services/expense_database.dart';
import '../model/expense.dart';

class ExpenseRepository {
  final ExpenseDatabase _expenseDatabase = ExpenseDatabase.instance;

  Future<List<Expense>> getExpenses() async {
    return await _expenseDatabase.readAllExpenses();
  }

  Future<Expense> addExpense(Expense expense) async {
    return await _expenseDatabase.create(expense);
  }

  Future<int> updateExpense(Expense expense) async {
    return await _expenseDatabase.update(expense);
  }

  Future<int> deleteExpense(int id) async {
    return await _expenseDatabase.delete(id);
  }
}
