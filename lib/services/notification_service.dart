import 'dart:math';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:stay_hydro/services/sound_service.dart'; // اگر فولڈر کا پاتھ یہی ہے تو
import 'dart:typed_data';
import 'package:flutter/material.dart'; // یا import 'package:flutter/painting.dart';

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
  static const String _reminderSystemKey = 'reminder_system_mode';
  static const String _customReminderTimesKey = 'custom_reminder_times';

  // اسے 'water_hourly' سے بدل کر 'water_reminder_v3' کر دیں

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
      // ⭐ یہ لائن بیک گراؤنڈ کلک ہینڈلر کو جوڑ رہی ہے
      onDidReceiveBackgroundNotificationResponse:
          NotificationService.notificationTapBackground,
    );

    // ⭐ لاجک: اگر یہ بوٹ (Boot) سے چل رہا ہے تو پرمیشن نہیں مانگنی
    if (!fromBoot) {
      try {
        await _notifications
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission();
      } catch (e) {
        if (kDebugMode) {
          debugPrint("Notification permission request skipped safely: $e");
        }
      }
    }

// =========================================================
// ⭐⭐⭐ CRITICAL FIX: Dynamic Channel Creation (REAL SOLUTION)
// =========================================================

    final prefs = await SharedPreferences.getInstance();

// ⭐ منتخب ساؤنڈ حاصل کریں
    final String soundName = prefs.getString(_soundPrefKey) ?? 'water_glass';

// ⭐ DEBUG: init میں اصل loaded value دیکھیں
    if (kDebugMode) {
      debugPrint("INIT SOUND: $soundName");
    }

// ⭐ ساؤنڈ اور چینل آئی ڈی سیٹ کریں
    //  String finalSound = 'water_glass';
    // String channelId = 'water_glass_channel_V10';

    // if (soundName == 'soft_knock') {
    //   finalSound = 'soft_knock';
    //   channelId = 'soft_knock_channel_V10';
    // } else if (soundName == 'water_drop') {
    //   finalSound = 'water_drop';
    //   channelId = 'water_drop_channel_V10';
    // }
// ⭐ DEBUG ONLY
    //if (kDebugMode) {
    // debugPrint("INIT SELECTED SOUND: $soundName");
    //   debugPrint("INIT CHANNEL ID: $channelId");
    //}

    // ⭐ صرف ایک بار سب چینلز بنا دو
    await createAllNotificationChannels();

    _initialized = true;
  }

  // اردو کمنٹ: تمام ضروری چینلز کو پہلے سے بنا کر رکھنا تاکہ سسٹم تیار رہے

// ============ SOUND ============
  static Future<String> _getSelectedSound() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_soundPrefKey) ?? 'water_glass';
  }

// ============ SHARED NOTIFICATION ENGINE (10.4A) ============
// اردو کمنٹ: تمام reminders کے لیے ایک ہی جگہ سے sound/mode/channel/details بنیں گے

  static Future<String> _getCurrentReminderMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('reminder_mode') ?? 'Sound + Vibrate';
  }

  static String _modeSuffix(String mode) {
    switch (mode) {
      case 'Sound only':
        return 's';
      case 'Vibrate only':
        return 'v';
      case 'Silent':
        return 'silent';
      case 'Sound + Vibrate':
      default:
        return 'sv';
    }
  }

  static Future<NotificationDetails> buildNotificationDetails({
    String? soundKey,
    String? mode,
  }) async {
    final selectedSound = soundKey ?? await _getSelectedSound();
    final selectedMode = mode ?? await _getCurrentReminderMode();

    final channelId =
        '${selectedSound}_${_modeSuffix(selectedMode)}_channel_V14';

    if (kDebugMode) {
      debugPrint('ENGINE: $selectedSound | $selectedMode');
    }

    final androidDetails = AndroidNotificationDetails(
      channelId,
      'Water Reminders',
      channelDescription: 'Hourly hydration alerts',
      importance: selectedMode == 'Silent' ? Importance.high : Importance.max,
      priority: Priority.high,
      ticker: 'Stay Hydro Reminder',

      // اہم:
      // یہاں playSound / enableVibration / vibrationPattern نہیں دیں گے
      // کیونکہ اصل behavior channel createAllNotificationChannels() میں lock ہے
    );

    return NotificationDetails(android: androidDetails);
  }

  // ⭐ نیا فنکشن:
// ⭐ تمام sounds + modes کے لیے channels
  static Future<void> createAllNotificationChannels() async {
    if (kIsWeb) return;

    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    final sounds = [
      'digital_bell',
      'soft_bell',
      'soft_knock',
      'water_drop',
      'water_glass',
    ];

    for (final sound in sounds) {
      // =========================================
      // SOUND + VIBRATE
      // =========================================
      await androidPlugin?.createNotificationChannel(
        AndroidNotificationChannel(
          '${sound}_sv_channel_V14',
          '$sound Sound + Vibrate',
          description: 'Sound and vibration reminders',
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
          vibrationPattern: Int64List.fromList([100, 500, 200, 500]),
          sound: RawResourceAndroidNotificationSound(sound),
        ),
      );

      // =========================================
      // SOUND ONLY
      // =========================================
      await androidPlugin?.createNotificationChannel(
        AndroidNotificationChannel(
          '${sound}_s_channel_V14',
          '$sound Sound Only',
          description: 'Sound only reminders',
          importance: Importance.max,
          playSound: true,
          enableVibration: false,
          sound: RawResourceAndroidNotificationSound(sound),
        ),
      );

      // =========================================
      // VIBRATE ONLY
      // =========================================
      await androidPlugin?.createNotificationChannel(
        AndroidNotificationChannel(
          '${sound}_v_channel_V14',
          '$sound Vibrate Only',
          description: 'Vibration only reminders',
          importance: Importance.max,
          playSound: false,
          enableVibration: true,
          vibrationPattern: Int64List.fromList([100, 500, 200, 500]),
        ),
      );

      // =========================================
      // SILENT
      // =========================================
      await androidPlugin?.createNotificationChannel(
        AndroidNotificationChannel(
          '${sound}_silent_channel_V14',
          '$sound Silent',
          description: 'Silent reminders',
          // ⭐ visible but silent
          importance: Importance.high,
          playSound: false,
          enableVibration: false,
        ),
      );
    }
  }

  // اردو کمنٹ: پرانا recreateReminderChannel اب createAllNotificationChannels میں ضم ہو چکا ہے
  static Future<void> recreateReminderChannel() async {
    await createAllNotificationChannels();
  }

// ============ SCHEDULE (UPDATED TO OPTION 2) ============
// اردو کمنٹ: fromBoot پیرامیٹر شامل کیا گیا ہے تاکہ بیک گراؤنڈ میں پرمیشن کا مسئلہ نہ ہو
  static Future<void> scheduleHourlyReminder({bool fromBoot = false}) async {
    if (kDebugMode) {} // یہاں شامل کریں
    if (kIsWeb) return;

    // ⭐ Fasting Mode Sync Check
    final prefs = await SharedPreferences.getInstance();
    final bool isFasting = prefs.getBool('isFastingMode') ?? false;

    if (isFasting) {
      if (kDebugMode)
        debugPrint(
            "Fasting Mode Active: Cancellation triggered instead of schedule.");
      // ⭐ صرف پانی والے ریمائنڈرز کینسل کریں (100 سے 124)
      await cancelRegularReminders();
      await cancelCustomReminders();
      return;
    }

    if (kDebugMode) debugPrint("HOURLY RESTORE STARTED");

    // ⭐ اہم تبدیلی: اب یہ پیرامیٹر کے مطابق انیشلائز ہوگا
    await init(fromBoot: fromBoot);

    // ⭐ ensure channels exist before scheduling

    await prefs.setInt(_intervalKey, 60);
    await prefs.setBool(_scheduleFlagKey, true);

    final sleepStartH = prefs.getInt(_sleepStartHourKey) ?? 23;
    final sleepStartM = prefs.getInt(_sleepStartMinuteKey) ?? 0;
    final sleepEndH = prefs.getInt(_sleepEndHourKey) ?? 7;
    final sleepEndM = prefs.getInt(_sleepEndMinuteKey) ?? 0;

    // ⭐ سیف لاجک: آواز کے انتخاب کے مطابق صحیح چینل آئی ڈی اور فائل کا تعین
    // آواز کا نام حاصل کریں
    // =========================================
    // [PHASE 10.4C] CURRENT SOUND + MODE
    // اردو کمنٹ:
    // hourly reminders ہمیشہ current global sound + mode کے مطابق schedule ہوں گے
    // mode/sound change پر settings screen سے یہ function دوبارہ call ہو گا
    // =========================================

    final String selectedSound = await _getSelectedSound();
    final String currentMode =
        prefs.getString('reminder_mode') ?? 'Sound + Vibrate';

    final NotificationDetails notificationDetails =
        await buildNotificationDetails(
      soundKey: selectedSound,
      mode: currentMode,
    );

    if (kDebugMode) {
      debugPrint("HOURLY ENGINE READY");
    }

    // =========================================
    // HOURLY REMINDER LOOP
    // اردو کمنٹ:
    // sleep hours کے علاوہ ہر active hour کے لیے daily repeating notification schedule ہو گا
    // =========================================
    // یہاں سے آگے آپ کا ریمائنڈر لوپ (Loop) شروع ہوگا...

    // Cancel all previous hourly IDs (100 to 124)
    await cancelRegularReminders();

    // ⭐ Debug Lists for logging
    List<int> scheduledHours = [];
    List<int> skippedHours = [];

    // Schedule for each hour except sleep hours
    for (int hour = 0; hour < 24; hour++) {
      bool isSleep = false;

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
          notificationDetails,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,
          payload: 'water_reminder',
        );
      } else {
        skippedHours.add(hour);
      }
    }

    if (kDebugMode) {}

//یہاں سے سپیشل ریمائنڈر دوبارہ زندہ ہونے کا فنکشن اڑا دیا پلس کے کہنے پر
  } // 👈 یہ ہے فنکشن کی اصل آخری بریکٹ

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
// اردو کمنٹ:
// active reminder system کو دوبارہ restore/reschedule کرنا
// Smart Hourly / Custom Schedule دونوں supported
// ====================================
  static Future<void> rescheduleNext({bool force = false}) async {
    if (kIsWeb) return;

    final prefs = await SharedPreferences.getInstance();

    final scheduled = prefs.getBool(_scheduleFlagKey) ?? false;

    if (scheduled || force) {
      await restoreActiveReminderSystem();
    }
  }

  // ============ SPECIAL REMINDERS ============
  // [PHASE 10.3B / 10.4B LOCKED SPECIAL BEHAVIOR]
  //
  // اردو کمنٹ:
  // Special reminders save-time locked sound + mode استعمال کریں گے
  // Hourly/test reminders global sound + mode follow کریں گے
  static Future<void> scheduleSpecialReminder(
    int id,
    int hour,
    int minute,
    String message, {
    String? soundKey,
    String? mode,
  }) async {
    if (kIsWeb) return;

    await init();

    final NotificationDetails details = await buildNotificationDetails(
      soundKey: soundKey,
      mode: mode,
    );

    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
      0,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _notifications.zonedSchedule(
      id,
      "Special Reminder",
      message.trim().isEmpty ? "Time to hydrate 💧" : message.trim(),
      scheduledDate,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    if (kDebugMode) {
      debugPrint("SPECIAL REMINDER RESTORED: $id");
    }
  }

  // ==========================================
  // [FUNCTION: RESTORE SPECIAL REMINDERS]
  // [PHASE 10.3B RELIABILITY FIX]
  //
  // اردو کمنٹ:
  // App start / reinstall / update / boot کے بعد enabled special reminders
  // کو دوبارہ schedule کرنے کا محفوظ فنکشن
  //
  // اہم اصول:
  // - یہ fasting mode سے متاثر نہیں ہوں گے
  // - یہ hourly reminders کو touch نہیں کرے گا
  // - صرف 201, 202, 203 IDs restore ہوں گی
  // ==========================================
  static Future<void> restoreSpecialReminders({
    bool fromBoot = false,
    bool skipInit = false,
  }) async {
    if (kIsWeb) return;

    if (!skipInit) {
      await init(fromBoot: fromBoot);
    }

    final prefs = await SharedPreferences.getInstance();

    for (int id = 201; id <= 203; id++) {
      final bool isEnabled = prefs.getBool('special_${id}_enabled') ?? false;

      if (isEnabled) {
        final int h = prefs.getInt('special_${id}_hour') ?? 0;
        final int m = prefs.getInt('special_${id}_min') ?? 0;
        final String msg =
            prefs.getString('special_${id}_msg') ?? "Special Reminder";

        final String sound =
            prefs.getString('special_${id}_sound') ?? await _getSelectedSound();

        final String reminderMode = prefs.getString('special_${id}_mode') ??
            await _getCurrentReminderMode();

        await scheduleSpecialReminder(
          id,
          h,
          m,
          msg,
          soundKey: sound,
          mode: reminderMode,
        );
      }
    }

    if (kDebugMode) {
      debugPrint("SPECIAL RESTORE COMPLETED");
    }
  }

  // ==========================================
  // [FUNCTION: CANCEL SINGLE NOTIFICATION]
  // اردو کمنٹ:
  // کسی ایک notification کو ID کے ذریعے cancel کرنے کا محفوظ فنکشن
  // Special reminders save/update/off کرتے وقت استعمال ہوتا ہے
  // ==========================================
  static Future<void> cancelNotification(int id) async {
    if (kIsWeb) return;

    await _notifications.cancel(id);

    if (kDebugMode) {
      debugPrint("Notification $id cancelled.");
    }
  }

  // ==========================================
  // [FUNCTION: CANCEL REGULAR REMINDERS ONLY]
  // اردو کمنٹ:
  // صرف hourly water reminders cancel ہوں گے
  // Special reminders IDs 201, 202, 203 محفوظ رہیں گے
  // ==========================================
  static Future<void> cancelRegularReminders() async {
    if (kIsWeb) return;

    for (int i = 100; i <= 150; i++) {
      await _notifications.cancel(i);
    }

    if (kDebugMode) {
      debugPrint(
        "Regular reminders (100-150) cancelled. Special ones kept safe.",
      );
    }
  }

  // ==========================================
  // [FUNCTION: CANCEL CUSTOM REMINDERS ONLY]
  // [PHASE 10.5B-5]
  // اردو کمنٹ:
  // صرف Custom Schedule reminders cancel ہوں گے
  // IDs: 300–350
  // ==========================================
  static Future<void> cancelCustomReminders() async {
    if (kIsWeb) return;

    for (int i = 300; i <= 350; i++) {
      await _notifications.cancel(i);
    }

    if (kDebugMode) {
      debugPrint("Custom reminders (300-350) cancelled.");
    }
  }

  // ==========================================
  // [FUNCTION: SCHEDULE CUSTOM REMINDERS]
  // [PHASE 10.5B-5]
  // اردو کمنٹ:
  // Custom Schedule slots کو global sound + mode کے مطابق schedule کرنا
  // Fasting Mode میں یہ reminders schedule نہیں ہوں گے
  // ==========================================
  static Future<void> scheduleCustomReminders(
    List<Map<String, dynamic>> slots, {
    bool fromBoot = false,
  }) async {
    if (kIsWeb) return;

    final prefs = await SharedPreferences.getInstance();
    final bool isFasting = prefs.getBool('isFastingMode') ?? false;

    await cancelCustomReminders();
    await cancelRegularReminders();

    if (isFasting) {
      if (kDebugMode) {
        debugPrint("Fasting Mode Active: Custom reminders cancelled.");
      }
      return;
    }

    await init(fromBoot: fromBoot);

    final NotificationDetails details = await buildNotificationDetails();

    int scheduledCount = 0;

    for (int i = 0; i < slots.length && i < 51; i++) {
      final slot = slots[i];

      final int hour = slot['hour'] as int;
      final int minute = slot['minute'] as int;
      final bool enabled = slot['enabled'] as bool? ?? true;

      if (!enabled) continue;

      final now = tz.TZDateTime.now(tz.local);
      var scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
        0,
      );

      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      await _notifications.zonedSchedule(
        300 + i,
        _randomMessages[_random.nextInt(_randomMessages.length)],
        _randomBodies[_random.nextInt(_randomBodies.length)],
        scheduledDate,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'custom_water_reminder',
      );

      scheduledCount++;
    }

    if (kDebugMode) {
      debugPrint("CUSTOM REMINDERS SCHEDULED: $scheduledCount");
    }
  }

// ============ TEST NOTIFICATION ============
// [PHASE 10.4C]
// اردو کمنٹ:
// ٹیسٹ نوٹیفکیشن بھی اب اسی Shared Notification Engine کو استعمال کرے گا
// تاکہ test behavior hourly اور special reminders جیسا ہی ہو
  static Future<void> showTestNotification() async {
    if (kIsWeb) return;

    await init();

    final NotificationDetails details = await buildNotificationDetails();

    final randomTitle =
        _randomMessages[_random.nextInt(_randomMessages.length)];

    await _notifications.show(
      999,
      randomTitle,
      _randomBodies[_random.nextInt(_randomBodies.length)],
      details,
      payload: 'test_notification',
    );

    if (kDebugMode) {
      debugPrint("TEST NOTIFICATION SENT");
    }
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

//===========================================
  //Boot Receiver / app start restore HELPER
  // اردو کمنٹ: ایپ ری سٹارٹ / اپ ڈیٹ/ ری بُوٹ کے بعد کسٹم اور ایکٹیو ریمائنڈر سسٹم Reliable بحال کرنے کے لیے
//===========================================
  static Future<List<Map<String, dynamic>>>
      _loadCustomReminderSlotsFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_customReminderTimesKey) ?? "";
    final slots = <Map<String, dynamic>>[];

    for (final part in raw.split(',')) {
      final pieces = part.split(':');
      if (pieces.length >= 2) {
        final hour = int.tryParse(pieces[0]);
        final minute = int.tryParse(pieces[1]);
        final enabled = pieces.length >= 3 ? pieces[2] == '1' : true;

        if (hour != null &&
            minute != null &&
            hour >= 0 &&
            hour <= 23 &&
            minute >= 0 &&
            minute <= 59) {
          slots.add({'hour': hour, 'minute': minute, 'enabled': enabled});
        }
      }
    }
    return slots;
  }

  static Future<void> restoreActiveReminderSystem(
      {bool fromBoot = false}) async {
    if (kIsWeb) return;

    final prefs = await SharedPreferences.getInstance();
    final isFasting = prefs.getBool('isFastingMode') ?? false;
    final reminderSystem =
        prefs.getString(_reminderSystemKey) ?? 'Smart Hourly';

    if (isFasting) {
      await cancelRegularReminders();
      await cancelCustomReminders();
    } else if (reminderSystem == 'Custom Schedule') {
      final slots = await _loadCustomReminderSlotsFromPrefs();
      await scheduleCustomReminders(slots, fromBoot: fromBoot);
    } else {
      await cancelCustomReminders();
      await scheduleHourlyReminder(fromBoot: fromBoot);
    }

// ==========================================
// [PHASE 10.8-B: OPTIMIZED SPECIAL RESTORE]
// اردو کمنٹ:
// اگر fasting mode OFF ہو تو init پہلے ہی hourly/custom restore میں ہو چکی ہوگی
// اس لیے special restore دوبارہ init نہیں کرے گا
//
// اگر fasting ON ہو تو hydration restore skip ہوگی
// اس صورت میں special restore خود init کرے گا
// ==========================================
    await restoreSpecialReminders(
      fromBoot: fromBoot,
      skipInit: !isFasting,
    );

    if (kDebugMode) {
      debugPrint("ACTIVE REMINDER SYSTEM RESTORED: $reminderSystem");
    }
  }

// ==========================================
  // SECTION 7: BOOT & BACKGROUND HANDLER (Phase 10.3)
  // اردو کمنٹ: فون ری اسٹارٹ ہونے پر یا بیک گراؤنڈ میں ایونٹس کو ہینڈل کرنا
  // ==========================================
  @pragma('vm:entry-point')
  static Future<void> handleBootReschedule() async {
    if (kDebugMode) {
      debugPrint("BOOT_RECEIVER: Device reboot detected.");
    }

    await restoreActiveReminderSystem(fromBoot: true);

    if (kDebugMode) {
      debugPrint("BOOT_RECEIVER: Active reminder system restore completed.");
    }
  }

  // ⭐ یہ فنکشن اب بھی ضروری ہے تاکہ نوٹیفکیشن کلک کو ہینڈل کیا جا سکے
  @pragma('vm:entry-point')
  static void notificationTapBackground(NotificationResponse response) {
    // اردو کمنٹ:
    // background notification tap handler
    // فی الحال کوئی custom action نہیں چاہیے
  }
}
