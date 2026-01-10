import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static Future saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  static Future getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future saveLogin(String login) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_login', login);
  }

  static Future getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_login');
  }

  static Future clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
