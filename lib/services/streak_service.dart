import 'package:shared_preferences/shared_preferences.dart';

class StreakService {
  static const String _streakKey = 'currentStreak';
  static const String _lastCompletedDateKey = 'lastCompletedDate';

  static Future<int> getStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_streakKey) ?? 0;
  }

  static Future<void> markGoalCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    final today = _todayKey();

    final lastDate = prefs.getString(_lastCompletedDateKey);
    int streak = prefs.getInt(_streakKey) ?? 0;

    if (lastDate == null) {
      streak = 1;
    } else {
      final last = DateTime.parse(lastDate);
      final diff = DateTime.now().difference(last).inDays;

      if (diff == 1) {
        streak += 1;
      } else if (diff > 1) {
        streak = 1;
      }
    }

    await prefs.setInt(_streakKey, streak);
    await prefs.setString(_lastCompletedDateKey, today);
  }

  static Future<void> resetStreakIfMissed() async {
    final prefs = await SharedPreferences.getInstance();
    final lastDate = prefs.getString(_lastCompletedDateKey);

    if (lastDate == null) return;

    final last = DateTime.parse(lastDate);
    final diff = DateTime.now().difference(last).inDays;

    if (diff > 1) {
      await prefs.setInt(_streakKey, 0);
    }
  }

  static String _todayKey() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day).toIso8601String();
  }
}
