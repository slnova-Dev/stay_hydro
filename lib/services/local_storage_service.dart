import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _keyIntake = 'current_intake';
  static const String _keyGoal = 'daily_goal';
  static const String _keyDarkTheme = 'is_dark_theme';
  static const String _keyFasting = 'is_fasting_mode';

  /// Save intake
  static Future<void> saveIntake(int intake) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyIntake, intake);
  }

  /// Get intake
  static Future<int> getIntake() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyIntake) ?? 0;
  }

  /// Save daily goal
  static Future<void> saveGoal(int goal) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyGoal, goal);
  }

  /// Get daily goal
  static Future<int> getGoal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyGoal) ?? 2000;
  }

  /// Save theme
  static Future<void> saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDarkTheme, isDark);
  }

  /// Get theme
  static Future<bool> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyDarkTheme) ?? false;
  }

  /// Save fasting mode
  static Future<void> saveFasting(bool isFasting) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyFasting, isFasting);
  }

  /// Get fasting mode
  static Future<bool> getFasting() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyFasting) ?? false;
  }
}
