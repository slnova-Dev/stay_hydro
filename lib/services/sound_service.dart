import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoundService {
  // ============ KEYS ============
  static const String _prefKey = 'selected_sound';
  static const String _customPathKey = 'custom_sound_path';
  static const String _modeKey = 'reminder_mode'; // Sound, Vibrate, etc.

  static const MethodChannel _channel = MethodChannel('stayhydro_sound_channel');

  // ============ SOUND OPTIONS ============
  // اردو کمنٹ: ایپ کی اپنی آوازیں
  static const Map<String, String> waterSounds = {
    'water_glass': 'Water Flow',
    'soft_knock': 'Soft Knock',
    'water_drop': 'Water Drop',
    'custom': 'Custom Sound (Device)',
  };

  // ============ GETTERS & SETTERS ============

  // آواز منتخب کرنے کے لیے
  static Future<void> setSound(String soundKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, soundKey);
  }

  static Future<String> getSound() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_prefKey) ?? 'water_glass';
  }

  // کسٹم فائل کا راستہ محفوظ کرنے کے لیے
  static Future<void> setCustomPath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_customPathKey, path);
  }

  static Future<String?> getCustomPath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_customPathKey);
  }

  // ریمائنڈر موڈ (Silent/Vibrate) سیٹ کرنے کے لیے
  static Future<void> setReminderMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_modeKey, mode);
  }

  static Future<String> getReminderMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_modeKey) ?? 'Sound + Vibrate';
  }

  // ==========================================
  // [SECTION: PLAY LOGIC]
  // اردو کمنٹ: آواز بجانے کا اصلی فنکشن (Phase 10.4 Updated)
  // ==========================================
// ==========================================
  // [FUNCTION: TRIGGER VIBRATION]
  // اردو کمنٹ: فون کو ایک بار تھرتھرانے کا فنکشن
  // ==========================================
  static Future<void> triggerVibration() async {
    try {
      // اینڈرائیڈ کو وائبریشن کا سگنل بھیجیں
      await _channel.invokeMethod('vibrate'); 
    } catch (e) {
      debugPrint("Vibration Error: $e");
    }
  }

  // ==========================================
  // [SECTION: PLAY LOGIC]
  // اردو کمنٹ: آواز اور وائبریشن کا مکمل پریویو لاجک
  // ==========================================
  static Future<void> playWaterSound() async {
    try {
      if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;

      final mode = await getReminderMode();
      
      // وائبریشن پریویو (اگر موڈ میں وائبریشن شامل ہو)
      if (mode.contains('Vibrate')) {
        triggerVibration();
      }

      // اگر سائلنٹ یا صرف وائبریشن ہے تو آواز نہ بجائیں
      if (mode == 'Silent' || mode == 'Vibrate only') return;

      final soundKey = await getSound();
      
      if (soundKey == 'custom') {
        final path = await getCustomPath();
        if (path != null && path.isNotEmpty) {
          // کسٹم فائل پلے کرنے کے لیے
          await _channel.invokeMethod('play_custom_file', {'path': path});
        }
      } else {
        // ڈیفالٹ آوازیں
        await _channel.invokeMethod('play_sound', {'sound': soundKey});
      }
    } catch (e) {
      debugPrint("Error in playWaterSound: $e");
    }
  }
}
// ==========================================