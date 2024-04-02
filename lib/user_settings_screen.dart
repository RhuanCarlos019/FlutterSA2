import 'package:shared_preferences/shared_preferences.dart';

class Configuracoes {
  static Future<void> setTheme(int theme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("theme", theme);
  }

  static Future<int> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("theme") ?? 0;
  }
}
