import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HistoryService {
  static const String _historyKey = 'water_history_data';

  // 1. پانی پینے کا ریکارڈ محفوظ کریں
  static Future<void> addToHistory(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    String today = DateTime.now().toString().split(' ')[0]; // آج کی تاریخ: 2026-04-11

    Map<String, int> history = await getHistory();
    
    // اگر آج کا ریکارڈ پہلے سے ہے تو اس میں پلس کریں، ورنہ نیا بنائیں
    history[today] = (history[today] ?? 0) + amount;

    // ڈیٹا کو سٹرنگ میں بدل کر محفوظ کریں
    await prefs.setString(_historyKey, json.encode(history));
  }

  // 2. تمام ہسٹری حاصل کریں
  static Future<Map<String, int>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(_historyKey);
    if (data == null) return {};
    
    Map<String, dynamic> decoded = json.decode(data);
    return decoded.map((key, value) => MapEntry(key, value as int));
  }

  // 3. پچھلے 7 دنوں کا ڈیٹا (گراف کے لیے)
  static Future<List<Map<String, dynamic>>> getLast7Days() async {
    Map<String, int> history = await getHistory();
    List<Map<String, dynamic>> last7Days = [];

    for (int i = 6; i >= 0; i--) {
      DateTime date = DateTime.now().subtract(Duration(days: i));
      String dateStr = date.toString().split(' ')[0];
      
      last7Days.add({
        'day': _getDayName(date.weekday), // مثلاً: Mon, Tue
        'amount': history[dateStr] ?? 0,
      });
    }
    return last7Days;
  }

  static String _getDayName(int day) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[day - 1];
  }
}