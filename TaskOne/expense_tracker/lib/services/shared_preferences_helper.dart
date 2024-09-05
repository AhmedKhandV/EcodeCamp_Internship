import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String _keyBudget='budget';
  static const String _keyLastUsedCategory='lastUsedCategory';

  Future<void>saveBudget(double budget) async
  {
    final prefs=await SharedPreferences.getInstance();
    await prefs.setDouble(_keyBudget, budget);
  }
   Future<double?> getBudget() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_keyBudget);
  }

  Future<void> saveLastUsedCategory(String category) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLastUsedCategory, category);
  }

  Future<String?> getLastUsedCategory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLastUsedCategory);
  }
}