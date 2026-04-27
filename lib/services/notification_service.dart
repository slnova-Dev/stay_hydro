import 'dart:math';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:stay_hydro/services/sound_service.dart'; // اگر فولڈر کا پاتھ یہی ہے تو

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
  // اردو کمنٹ: اس میں fromBoot کا اضافہ کیا گیا ہے تاکہ بیک گراؤنڈ میں کریش نہ ہو
  static Future<void> init({bool fromBoot = false}) async {
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
        if ((response.id ?? 0) < 100) return;
        if (kDebugMode) {
          debugPrint('Notification tapped: ${response.id}');
        }
      },
    );

    // ⭐ لاجک: اگر یہ بوٹ (Boot) سے چل رہا ہے تو پرمیشن نہیں مانگنی
    if (!fromBoot) {
      await _notifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }

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

    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.deleteNotificationChannel(_channelId);

    final androidChannel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.high,
      // [CRITICAL UPDATE] اردو کمنٹ: سسٹم ساؤنڈ کو یہاں بھی بند کریں تاکہ ہماری کسٹم ساؤنڈ بج سکے
      playSound: false,
      enableVibration: false,
    );

    await androidPlugin?.createNotificationChannel(androidChannel);
  }

// ============ SCHEDULE (UPDATED TO OPTION 2) ============
  // اردو کمنٹ: fromBoot پیرامیٹر شامل کیا گیا ہے تاکہ بیک گراؤنڈ میں پرمیشن کا مسئلہ نہ ہو
  static Future<void> scheduleHourlyReminder({bool fromBoot = false}) async {
    if (kIsWeb) return;

    // ⭐ Fasting Mode Sync Check
    final prefs = await SharedPreferences.getInstance();
    final bool isFasting = prefs.getBool('isFastingMode') ?? false;

    if (isFasting) {
      if (kDebugMode)
        debugPrint(
            "Fasting Mode Active: Cancellation triggered instead of schedule.");
// ⭐ صرف پانی والے ریمائنڈرز کینسل کریں (100 سے 124)
      // اسپیشل ریمائنڈرز (201-203) محفوظ رہیں گے
// ⭐ تبدیلی: اب مینوئل لوپ کی جگہ ہم اپنا نیا فنکشن کال کریں گے
      await cancelRegularReminders();
      return; // یہاں سے فنکشن واپس چلا جائے گا
    } // 👈 یہ بریکٹ یقینی بنائیں کہ یہاں موجود ہے

    if (kDebugMode) debugPrint("CLEANING AND RE-SCHEDULING (PLAY STORE SAFE)");

    // ⭐ اہم تبدیلی: اب یہ پیرامیٹر کے مطابق انیشلائز ہوگا
    await init(fromBoot: fromBoot);

    await prefs.setInt(_intervalKey, 60);
    await prefs.setBool(_scheduleFlagKey, true);

    final sleepStartH = prefs.getInt(_sleepStartHourKey) ?? 23;
    final sleepStartM = prefs.getInt(_sleepStartMinuteKey) ?? 0;
    final sleepEndH = prefs.getInt(_sleepEndHourKey) ?? 7;
    final sleepEndM = prefs.getInt(_sleepEndMinuteKey) ?? 0;

    final soundKey = await _getSelectedSound();

// جہاں نوٹیفیکیشن کی تفصیلات سیٹ ہو رہی ہیں
    final androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      // [CRITICAL CHANGE] اینڈرائیڈ کو آواز بجانے سے روکیں
      playSound: false,
      enableVibration: false, // وائبریشن بھی ہم خود سنبھالیں گے
    );

    final details = NotificationDetails(android: androidDetails);

    // Cancel all previous hourly IDs (100 to 124)
// ⭐ تبدیلی: یہاں بھی پرانا لوپ ہٹا کر نیا فنکشن کال کر سکتے ہیں
    await cancelRegularReminders();

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
          // ⭐ اہم تبدیلی: اب یہ 'exact' موڈ استعمال کرے گا تاکہ الارم وقت پر آئیں
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
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

// ⭐ درست جگہ: فنکشن ختم ہونے والی بریکٹ سے پہلے
    // ⭐ آخر میں اسپیشل ریمائنڈرز کو دوبارہ زندہ (Restore) کریں
    // تاکہ ری شیڈولنگ کے دوران اگر کچھ مِس ہوا ہو تو وہ بحال ہو جائے
    for (int id = 201; id <= 203; id++) {
      final bool isEnabled = prefs.getBool('special_${id}_enabled') ?? false;
      if (isEnabled) {
        final h = prefs.getInt('special_${id}_hour') ?? 0;
        final m = prefs.getInt('special_${id}_min') ?? 0;
        final msg = prefs.getString('special_${id}_msg') ?? "Special Reminder";
        await scheduleSpecialReminder(id, h, m, msg);
      }
    }
  } // 👈 یہ ہے فنکشن کی آخری بریکٹ، لوپ اس کے اندر ہونا چاہیے

  static tz.TZDateTime _nextInstanceOfHour(int hour) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    // Precise strike at :00:00 (Inexact system will still shift it slightly)
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, 0, 0);

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

  // ============ SPECIAL REMINDERS ============
// اسپیشل ریمائنڈر شیڈول کرنے کا فنکشن
  static Future<void> scheduleSpecialReminder(
      int id, int hour, int minute, String message) async {
    if (kIsWeb) return;

    await init();

// جہاں نوٹیفیکیشن کی تفصیلات سیٹ ہو رہی ہیں
    final androidDetails = AndroidNotificationDetails(
      'special_reminders',
      'Special Reminders',
      channelDescription: 'Reminders for medicine, sehri, or iftar',
      importance: Importance.max,
      priority: Priority.high,
      // [UPDATE] ابھی اسے خاموش رکھتے ہیں، فیچر مکمل کرتے وقت آواز بدلیں گے
      playSound: false,
      enableVibration: false,
    );

    final details = NotificationDetails(android: androidDetails);

    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute, 0);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _notifications.zonedSchedule(
      id, // 201, 202 or 203
      "Special Reminder",
      message,
      scheduledDate,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    if (kDebugMode)
      debugPrint(
          "Special Reminder $id set for $hour:$minute with message: $message");
  }

// مخصوص نوٹیفیکیشن کینسل کرنے کا فنکشن (آئی ڈی کے ذریعے)
  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
    if (kDebugMode) debugPrint("Notification $id cancelled.");
  }

// ⭐ نیا شامل شدہ فنکشن: تمام عام ریمائنڈرز کینسل کرنے کا محفوظ طریقہ
  static Future<void> cancelRegularReminders() async {
    if (kIsWeb) return;
    // صرف 100 سے 150 تک کینسل کریں (پانی پینے والے ریمائنڈرز)
    // اسپیشل ریمائنڈرز (201, 202, 203) محفوظ رہیں گے
    for (int i = 100; i <= 150; i++) {
      await _notifications.cancel(i);
    }
    if (kDebugMode)
      debugPrint(
          "Regular reminders (100-150) cancelled. Special ones kept safe.");
  }

  // ============ TEST ============
  static Future<void> showTestNotification() async {
    if (kIsWeb) return;

    await init();

// جہاں نوٹیفیکیشن کی تفصیلات سیٹ ہو رہی ہیں
    const androidDetails = AndroidNotificationDetails(
      'water_test',
      'Water Reminder Test',
      channelDescription: 'Test notifications',
      importance: Importance.max,
      priority: Priority.high,
      // [UPDATE] ٹیسٹ میں بھی کسٹم ساؤنڈ بجانے کے لیے سسٹم ساؤنڈ بند
      playSound: false,
      enableVibration: false,
    );

    final randomTitle =
        _randomMessages[_random.nextInt(_randomMessages.length)];

    await _notifications.show(
      999,
      randomTitle,
      _randomBodies[_random.nextInt(_randomBodies.length)],
      const NotificationDetails(android: androidDetails),
    );

    // [TEST FIX] اردو کمنٹ: نوٹیفکیشن دکھانے کے فوراً بعد اپنی کسٹم ساؤنڈ بجائیں
    await SoundService.playWaterSound();
  }

// ============ CANCEL ============
// اس فنکشن کو اب ہم نے 'Selective' بنا دیا ہے تاکہ 'Star' ریمائنڈرز نہ رکیں
  static Future<void> cancelAll() async {
    if (kIsWeb) return;

    // ⭐ بڑی تبدیلی: اب ہم مکمل ایپ کے نوٹیفیکیشن صاف نہیں کریں گے
    // بلکہ صرف واٹر ریمائنڈرز صاف کریں گے
    await cancelRegularReminders();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_scheduleFlagKey, false);

    if (kDebugMode)
      debugPrint('Water notifications cancelled. Special reminders preserved.');
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

  // ==========================================
  // SECTION 7: BOOT RESCHEDULE LOGIC (Phase 10)
  // اردو کمنٹ: فون ری اسٹارٹ ہونے پر خاموشی سے ریمائنڈرز بحال کرنا
  // ==========================================
  @pragma('vm:entry-point')
  static Future<void> handleBootReschedule() async {
    if (kDebugMode)
      debugPrint("BOOT_RECEIVER: Device reboot detected. Rescheduling...");

    await init(fromBoot: true);
    final prefs = await SharedPreferences.getInstance();

    // --- حصہ 1: عام واٹر ریمائنڈرز (فاسٹنگ موڈ کے تابع) ---
    final bool isScheduled = prefs.getBool(_scheduleFlagKey) ?? false;
    final bool isFasting = prefs.getBool('isFastingMode') ?? false;

    if (isScheduled && !isFasting) {
      await scheduleHourlyReminder(fromBoot: true);
      if (kDebugMode) debugPrint("BOOT_RECEIVER: Water reminders restored.");
    } else {
      if (kDebugMode)
        debugPrint("BOOT_RECEIVER: Water reminders skipped (Fasting or Off).");
    }

    // --- حصہ 2: اسپیشل ریمائنڈرز (فاسٹنگ موڈ سے آزاد) ---
    // یہ حصہ 'if/else' سے باہر ہے تاکہ ہر حال میں چلے
    for (int id = 201; id <= 203; id++) {
      final bool isEnabled = prefs.getBool('special_${id}_enabled') ?? false;
      if (isEnabled) {
        final h = prefs.getInt('special_${id}_hour') ?? 0;
        final m = prefs.getInt('special_${id}_min') ?? 0;
        final msg = prefs.getString('special_${id}_msg') ?? "Special Reminder";
        await scheduleSpecialReminder(id, h, m, msg);
      }
    }

    if (kDebugMode)
      debugPrint("BOOT_RECEIVER: Special reminders check completed.");
  }
}
