import 'dart:math';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;

// ==========================================
// سیکشن 1: نوٹیفیکیشن سروس کلاس
// ==========================================
class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static const String _soundPrefKey = 'selected_sound';
  static const String _intervalKey = 'interval_minutes';
  static const String _scheduleFlagKey = 'hourly_scheduled';
  static const String _lastScheduledTimeKey = 'last_scheduled_time';
  static const String _sleepStartHourKey = 'sleep_start_hour';
  static const String _sleepStartMinuteKey = 'sleep_start_minute';
  static const String _sleepEndHourKey = 'sleep_end_hour';
  static const String _sleepEndMinuteKey = 'sleep_end_minute';

  static const String _channelId = 'water_hourly';
  static const String _channelName = 'Water Reminder';
  static const String _channelDescription = 'Hourly hydration reminders';

  // ⭐ Random Notification Messages
  static const List<String> _randomMessages = [
    'Drink water 💧',
    'Hydration time 💧',
    'Stay hydrated 💧',
    'Water break 💧',
    "Let's take a sip 💧",
    "It's time to drink 💧",
    'Take a water moment 💧',
    'Refresh with water 💧',
    'Hydrate your body 💧',
    'Give your body some water 💧',
    'Small sip, big benefit 💧',
    'Stay Cool, Stay Hydrated 💧',
    'Body Recharge Time 💧',
    'Water Calling! 💧',
    'Your Daily Sip 💧',
    'Pure Refreshment 💧',
    'Hello, Hydration! 💧',
    'Quick Water Break 💧',
    'Keep Flowing! 💧',
    'Sip & Shine 💧',
    'H2O Alert 💧',
    'Thirsty? Drink Up! 💧',
    'Boost Your Energy 💧',
    'Time for Clarity 💧',
    'Wellness in a Glass 💧',
  ];
  static const List<String> _randomBodies = [
    'Your body needs hydration right now!',
    'A quick sip can make a big difference.',
    'Keep your energy up — drink water!',
    'Time for a refreshing break with water.',
    'One glass closer to your daily goal 💧',
    'Stay fresh and focused — hydrate!',
    'Water is your best friend today.',
    'Take a moment to sip and smile.',
    'Your cells are thirsty — help them out!',
    'Small habit, big health benefits.',
    'Drink up and feel great!',
    'Keep the water flowing all day.',
    'You’ve got this — one sip at a time.',
    'Hydration = better mood and focus 💧',
    'Don’t wait till thirsty — drink now! 💧',
    'A hydrated brain is a smart brain! 🧠',
    'Water helps your skin glow. Take a sip! ✨',
    'Feeling tired? Water might be the answer.',
    'Keep your metabolism moving with H2O.',
    'Water: The zero-calorie energy drink! ⚡',
    'Your kidneys will thank you for this sip.',
    'Stay balanced, stay healthy. Drink water.',
    'Fuel your workout with proper hydration.',
    'A glass of water a day keeps fatigue away!',
    'Refresh your mind with a cool drink of water.',
    'Your heart pumps easier when you are hydrated.',
    'Flush out the toxins with a quick water break.',
    'Simple rule: Drink water, stay awesome! 😎',
    'Every drop counts towards your health.',
    'Be kind to your body—give it water.',
  ];
  static final Random _random = Random();

  // ============ TIMEZONE ============
  static Future<void> _configureLocalTimeZone() async {
    tzdata.initializeTimeZones();
    try {
      // ⭐ Fixed without any extra package:
      // This will correctly identify 'Asia/Karachi' based on device clock
      final String timeZoneName = DateTime.now().timeZoneName; 
      
      // If timeZoneName is PST or PKT, we need to map it correctly
      if (timeZoneName == 'PKT' || timeZoneName == 'PST') {
          tz.setLocalLocation(tz.getLocation('Asia/Karachi'));
      } else {
          tz.setLocalLocation(tz.getLocation(timeZoneName));
      }
    } catch (e) {
      // Strict Fallback for Pakistan
      tz.setLocalLocation(tz.getLocation('Asia/Karachi'));
    }
  }

  // ============ INIT ============
  static Future<void> init() async {
    if (_initialized) return;

    if (kIsWeb) {
      _initialized = true;
      return;
    }

    await _configureLocalTimeZone();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const settings = InitializationSettings(android: androidSettings);

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) async {

        // ⭐ Fixed: Null safe check for ID
        if ((response.id ?? 0) < 100) return;

        if (kDebugMode) {
          debugPrint('Notification tapped: ${response.id}');
        }
      },
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    await recreateReminderChannel();

    _initialized = true;
  }

  // ============ SOUND ============
  static Future<String> _getSelectedSound() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_soundPrefKey) ?? 'water_glass';
  }

  static Future<void> recreateReminderChannel() async {
    if (kIsWeb) return;

    final soundKey = await _getSelectedSound();

    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.deleteNotificationChannel(_channelId);

    final androidChannel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound(soundKey),
    );

    await androidPlugin?.createNotificationChannel(androidChannel);
  }

  // ============ SCHEDULE (UPDATED TO OPTION 2) ============
  static Future<void> scheduleHourlyReminder() async {
    if (kIsWeb) return;

    // ⭐ Fasting Mode Sync Check
    final prefs = await SharedPreferences.getInstance();
    final bool isFasting = prefs.getBool('isFastingMode') ?? false;
    
    if (isFasting) {
      if (kDebugMode) debugPrint("Fasting Mode Active: Cancellation triggered instead of schedule.");
      await cancelAll(); 
      return;
    }

    if (kDebugMode) debugPrint("CLEANING AND RE-SCHEDULING (PLAY STORE SAFE)");

    await init();

    await prefs.setInt(_intervalKey, 60);
    await prefs.setBool(_scheduleFlagKey, true);

    final sleepStartH = prefs.getInt(_sleepStartHourKey) ?? 23;
    final sleepStartM = prefs.getInt(_sleepStartMinuteKey) ?? 0;
    final sleepEndH = prefs.getInt(_sleepEndHourKey) ?? 7;
    final sleepEndM = prefs.getInt(_sleepEndMinuteKey) ?? 0;

    final soundKey = await _getSelectedSound();

    final androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound(soundKey),
    );

    final details = NotificationDetails(android: androidDetails);

    // Cancel all previous hourly IDs (100 to 124)
    for (int i = 0; i < 24; i++) {
      await _notifications.cancel(100 + i);
    }

    // ⭐ Debug Lists for logging
    List<int> scheduledHours = [];
    List<int> skippedHours = [];

    // Schedule for each hour except sleep hours
    for (int hour = 0; hour < 24; hour++) {
      bool isSleep = false;
      
      // Precise calculation for sleep window
      double currentT = hour.toDouble();
      double startT = sleepStartH + (sleepStartM / 60.0);
      double endT = sleepEndH + (sleepEndM / 60.0);

      if (startT > endT) {
        if (currentT >= startT || currentT < endT) isSleep = true;
      } else if (startT < endT) {
        if (currentT >= startT && currentT < endT) isSleep = true;
      }

      if (!isSleep) {
        scheduledHours.add(hour);
        await _notifications.zonedSchedule(
          100 + hour,
          _randomMessages[_random.nextInt(_randomMessages.length)],
          _randomBodies[_random.nextInt(_randomBodies.length)],
          _nextInstanceOfHour(hour),
          details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,
        );
      } else {
        skippedHours.add(hour);
      }
    }

    if (kDebugMode) {
      debugPrint('--- NOTIFICATION SCHEDULE REPORT ---');
      debugPrint('Active Hours: ${scheduledHours.join(", ")}');
      debugPrint('Sleep Hours (Skipped): ${skippedHours.join(", ")}');
      debugPrint('------------------------------------');
    }
  }

  static tz.TZDateTime _nextInstanceOfHour(int hour) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    // Precise strike at :00:00 (Inexact system will still shift it slightly)
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, 0, 0);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  // ============ GET NEXT SCHEDULED TIME ============
  static Future<DateTime?> getNextScheduledReminderTime() async {
    final prefs = await SharedPreferences.getInstance();

    final isScheduled = prefs.getBool(_scheduleFlagKey) ?? false;
    final isFasting = prefs.getBool('isFastingMode') ?? false;

    if (!isScheduled || isFasting) return null;

    final sleepStartH = prefs.getInt(_sleepStartHourKey) ?? 23;
    final sleepStartM = prefs.getInt(_sleepStartMinuteKey) ?? 0;
    final sleepEndH = prefs.getInt(_sleepEndHourKey) ?? 7;
    final sleepEndM = prefs.getInt(_sleepEndMinuteKey) ?? 0;

    final now = DateTime.now();

    for (int i = 1; i <= 24; i++) {
      final check = now.add(Duration(hours: i));
      bool isSleep = false;
      
      double checkT = check.hour.toDouble();
      double startT = sleepStartH + (sleepStartM / 60.0);
      double endT = sleepEndH + (sleepEndM / 60.0);

      if (startT > endT) {
        if (checkT >= startT || checkT < endT) isSleep = true;
      } else if (startT < endT) {
        if (checkT >= startT && checkT < endT) isSleep = true;
      }

      if (!isSleep) {
        return DateTime(check.year, check.month, check.day, check.hour, 0);
      }
    }

    return null;
  }

  // ============ RESCHEDULE ============
  static Future<void> rescheduleNext({bool force = false}) async {
    if (kIsWeb) return;

    final prefs = await SharedPreferences.getInstance();

    final scheduled = prefs.getBool(_scheduleFlagKey) ?? false;

    if (scheduled || force) {
      await scheduleHourlyReminder();
    }
  }

  // ============ TEST ============
  static Future<void> showTestNotification() async {
    if (kIsWeb) return;

    await init();

    const androidDetails = AndroidNotificationDetails(
      'water_test',
      'Water Reminder Test',
      channelDescription: 'Test notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    final randomTitle =
        _randomMessages[_random.nextInt(_randomMessages.length)];

    await _notifications.show(
      999,
      randomTitle,
      _randomBodies[_random.nextInt(_randomBodies.length)],
      const NotificationDetails(android: androidDetails),
    );
  }

  // ============ CANCEL ============
  static Future<void> cancelAll() async {
    if (kIsWeb) return;

    await _notifications.cancelAll();

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_scheduleFlagKey, false);

    if (kDebugMode) debugPrint('Notifications cancelled');
  }

  // ============ DEVICE RELIABILITY ============
  static Future<void> openBatteryOptimizationSettings() async {
    if (kIsWeb) return;

    try {
      const intent = AndroidIntent(
        action: 'android.settings.IGNORE_BATTERY_OPTIMIZATION_SETTINGS',
      );

      await intent.launch();
    } catch (_) {
      const fallbackIntent = AndroidIntent(action: 'android.settings.SETTINGS');

      await fallbackIntent.launch();
    }
  }

  static Future<void> openAutoStartSettings() async {
    if (kIsWeb) return;

    final intents = <AndroidIntent>[
      const AndroidIntent(
        package: 'com.miui.securitycenter',
        componentName:
            'com.miui.permcenter.autostart.AutoStartManagementActivity',
      ),
      const AndroidIntent(
        package: 'com.coloros.safecenter',
        componentName:
            'com.coloros.safecenter.permission.startup.StartupAppListActivity',
      ),
      const AndroidIntent(
        package: 'com.oppo.safe',
        componentName:
            'com.oppo.safe.permission.startup.StartupAppListActivity',
      ),
      const AndroidIntent(
        package: 'com.realme.securitycenter',
        componentName:
            'com.realme.securitycenter.startupapp.StartupAppListActivity',
      ),
      const AndroidIntent(
        package: 'com.transsion.phonemaster',
        componentName: 'com.itel.autobootmanager.activity.AutoBootMgrActivity',
      ),
      const AndroidIntent(action: 'android.settings.SETTINGS'),
    ];

    for (final intent in intents) {
      try {
        await intent.launch();
        return;
      } catch (_) {}
    }
  }
}