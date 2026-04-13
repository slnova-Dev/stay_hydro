import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoundService {
  static const String _prefKey = 'selected_sound';

  // MethodChannel will only be used on Android
  static const MethodChannel _channel = MethodChannel('luna_hydration_sound');

  static const Map<String, String> sounds = {
    'water_glass': 'Water Glass',
    'soft_knock': 'Soft Knock',
    'water_drop': 'Water Drop',
  };

  static Future<void> setSound(String soundKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, soundKey);
  }

  static Future<String> getSound() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_prefKey) ?? 'water_glass';
  }

  static Future<void> playWaterSound() async {
    if (kIsWeb) return;
    if (defaultTargetPlatform != TargetPlatform.android) return;

    try {
      final soundKey = await getSound();
      await _channel.invokeMethod('play_sound', {'sound': soundKey});
    } catch (_) {
      // Fail silently
    }
  }
}
