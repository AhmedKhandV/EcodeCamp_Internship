import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static Future<Map<String, dynamic>> getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('name') ?? '';
    final occupation = prefs.getString('occupation') ?? '';
    final salary = prefs.getDouble('salary') ?? 0.0;
    return {
      'name': name,
      'occupation': occupation,
      'salary': salary,
    };
  }

  static Future<void> saveUserDetails(String name, String occupation, double salary) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('occupation', occupation);
    await prefs.setDouble('salary', salary);
  }
}
