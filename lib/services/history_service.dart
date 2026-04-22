import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// ==========================================
// [MODEL: WATER INTAKE ENTRY]
// ہر انفرادی انٹری (گھونٹ) کا ڈھانچہ
// ==========================================
class IntakeEntry {
  final String time;     // وقت (مثلاً 10:30 AM)
  final int amount;      // مقدار (ml)
  final String type;     // قسم (پانی، چائے وغیرہ - فی الحال صرف پانی)

  IntakeEntry({required this.time, required this.amount, this.type = 'Water'});

  // ڈیٹا کو محفوظ کرنے کے لیے Map میں بدلنا
  Map<String, dynamic> toJson() => {
        'time': time,
        'amount': amount,
        'type': type,
      };

  // محفوظ شدہ ڈیٹا سے واپس آبجیکٹ بنانا
  factory IntakeEntry.fromJson(Map<String, dynamic> json) => IntakeEntry(
        time: json['time'],
        amount: json['amount'],
        type: json['type'] ?? 'Water',
      );
}

// ==========================================
// [SERVICE: HISTORY SERVICE]
// ڈیٹا کو محفوظ کرنے اور نکالنے کا مین انجن
// ==========================================
class HistoryService {
  static const String _historyKey = 'water_history_data_v2'; // ورژن 2 تاکہ ڈیٹا مکس نہ ہو

  // ------------------------------------------
  // 1. [ACTION: ADD TO HISTORY]
  // نیا ریکارڈ محفوظ کرنا (آج کی تاریخ کے حساب سے)
  // ------------------------------------------
  static Future<void> addToHistory(int amount, String time) async {
    final prefs = await SharedPreferences.getInstance();
    String today = DateTime.now().toString().split(' ')[0]; // فارمیٹ: 2026-04-14

    // موجودہ تمام ہسٹری لوڈ کریں
    Map<String, dynamic> allHistory = await _getAllRawHistory();

    // اگر آج کی تاریخ کا فولڈر نہیں ہے تو بنائیں
    if (!allHistory.containsKey(today)) {
      allHistory[today] = {'total': 0, 'logs': []};
    }

    // آج کا ڈیٹا اپ ڈیٹ کریں
    allHistory[today]['total'] = (allHistory[today]['total'] ?? 0) + amount;
    
    // تفصیلی لاگ (Logs) میں اضافہ کریں
    List logs = allHistory[today]['logs'] ?? [];
    logs.add(IntakeEntry(time: time, amount: amount).toJson());
    allHistory[today]['logs'] = logs;

    // فائنل ڈیٹا محفوظ کریں
    await prefs.setString(_historyKey, json.encode(allHistory));
  }

  // ------------------------------------------
  // 2. [GETTER: TODAY LOGS]
  // آج کے تمام "گھونٹ" کی لسٹ حاصل کرنا
  // ------------------------------------------
  static Future<List<IntakeEntry>> getTodayLogs() async {
    String today = DateTime.now().toString().split(' ')[0];
    Map<String, dynamic> allHistory = await _getAllRawHistory();

    if (allHistory.containsKey(today) && allHistory[today]['logs'] != null) {
      List logs = allHistory[today]['logs'];
      return logs.map((item) => IntakeEntry.fromJson(item)).toList().reversed.toList(); // نئی انٹری اوپر دکھانے کے لیے
    }
    return [];
  }

  // ------------------------------------------
  // 3. [GETTER: LAST 7 DAYS DATA]
  // گراف (Chart) کے لیے پچھلے 7 دنوں کا ڈیٹا
  // ------------------------------------------
  static Future<List<Map<String, dynamic>>> getLast7Days() async {
    Map<String, dynamic> allHistory = await _getAllRawHistory();
    List<Map<String, dynamic>> last7Days = [];

    for (int i = 6; i >= 0; i--) {
      DateTime date = DateTime.now().subtract(Duration(days: i));
      String dateStr = date.toString().split(' ')[0];
      
      int amount = 0;
      if (allHistory.containsKey(dateStr)) {
        amount = allHistory[dateStr]['total'] ?? 0;
      }

      last7Days.add({
        'day': _getDayName(date.weekday),
        'amount': amount,
        'fullDate': dateStr,
      });
    }
    return last7Days;
  }

  // ------------------------------------------
  // 4. [HELPER: INTERNAL DATA FETCH]
  // تمام کچا ڈیٹا نکالنے کا اندرونی فنکشن
  // ------------------------------------------
  static Future<Map<String, dynamic>> _getAllRawHistory() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(_historyKey);
    if (data == null) return {};
    return json.decode(data);
  }

  static String _getDayName(int day) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[day - 1];
  }

  // ------------------------------------------
  // 5. [GETTER: QUICK STATS]
  // ایوریج اور بیسٹ ڈے وغیرہ کا حساب لگانا
  // ------------------------------------------
  static Future<Map<String, dynamic>> getQuickStats() async {
    List<Map<String, dynamic>> last7Days = await getLast7Days();
    
    int totalInWeek = 0;
    int bestDayAmount = 0;
    int daysWithData = 0;
    int goalReachedDays = 0;

    for (var day in last7Days) {
      int amt = day['amount'];
      totalInWeek += amt;
      if (amt > bestDayAmount) bestDayAmount = amt;
      if (amt > 0) daysWithData++;
      // ==========================================
      // [LOGIC LOCK: COMPLETION CALCULATION]
      // اگر یوزر نے 2000ml کا ہدف پورا کیا ہے
      // ==========================================
      if (amt >= 2000) goalReachedDays++;
    }

    return {
      'average': daysWithData > 0 ? (totalInWeek / daysWithData).round() : 0,
      'bestDay': bestDayAmount,
      // ہفتے کے 7 دنوں میں سے کتنے فیصد ہدف پورا ہوا
      'completionRate': ((goalReachedDays / 7) * 100).round(), 
    };
  }
}