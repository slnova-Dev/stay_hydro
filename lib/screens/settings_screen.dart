import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/notification_service.dart';
import 'package:stay_hydro/services/sound_service.dart'; // یہاں اپنے پراجیکٹ کا صحیح پاتھ دیں

class SettingsScreen extends StatefulWidget {
  final bool isDark;
  final Function(bool) onThemeToggle;
  final bool isFastingMode;
  final Function(bool) onFastingToggle;

  const SettingsScreen({
    super.key,
    required this.isDark,
    required this.onThemeToggle,
    required this.isFastingMode,
    required this.onFastingToggle,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
// ==========================================
  // [BLOCK: SPECIAL REMINDERS VARIABLES]
  // اسپیشل ریمائنڈرز کا ڈیٹا (آن/آف، ٹائم، اور میسج)
  // ==========================================
  // ہم 3 سلاٹس کے لیے لسٹ استعمال کر رہے ہیں (انڈیکس 0 سے 2 تک)
  List<bool> _specialEnabled = [false, false, false];
  List<int> _specialHours = [0, 0, 0];
  List<int> _specialMinutes = [0, 0, 0];
  List<String> _specialMessages = ["Special 1", "Special 2", "Special 3"];

  // ==========================================
  // [BLOCK: CUSTOM SCHEDULE VARIABLES]
  // اردو کمنٹ:
  // Custom Schedule mode کے لیے user-defined reminder times
  // ابھی یہ صرف save/load foundation ہے؛ scheduling اگلے step میں آئے گی
  // ==========================================
  List<Map<String, dynamic>> _customReminderSlots = [];

  static const String _customReminderTimesKey = 'custom_reminder_times';

// ==========================================
  // [BLOCK: STATE VARIABLES & KEYS] (Updated Phase 10.3)
  // تمام متغیرات اور لوکل ڈیٹا کی کیز یہاں محفوظ ہیں
  // ==========================================
  late bool _fasting;
  late bool _darkTheme;
  late int _sleepStartHour;
  late int _sleepStartMinute;
  late int _sleepEndHour;
  late int _sleepEndMinute;

  // آواز اور ریمائنڈر موڈ کے نئے ویریبلز
  String _currentMode = 'Sound + Vibrate';
  String _selectedSoundKey = 'water_glass';
  String _selectedSoundName = 'Water Flow';
  int _dailyGoal = 2000; // یوزر کا روزانہ کا ہدف (ڈیفالٹ: 2000ml)

// ڈیلی گول key شامل کی
  static const String _dailyGoalKey = 'daily_goal';

  // Reminder system selector
  // Smart Hourly = موجودہ hourly reminders
  // Custom Schedule = future custom times
  //// Hybrid currently postponed; Special Reminders remain independent.
  String _reminderSystem = 'Smart Hourly';

  static const String _reminderSystemKey = 'reminder_system_mode';

  // سونے کے اوقات کی لوکل کیز
  static const String _sleepStartHourKey = 'sleep_start_hour';
  static const String _sleepStartMinuteKey = 'sleep_start_minute';
  static const String _sleepEndHourKey = 'sleep_end_hour';
  static const String _sleepEndMinuteKey = 'sleep_end_minute';

  @override
  void initState() {
    super.initState();
    _fasting = widget.isFastingMode;
    _darkTheme = widget.isDark;

    // ڈیفالٹ ویلیوز (اگر میموری سے نہ ملیں)
    _sleepStartHour = 23;
    _sleepStartMinute = 0;
    _sleepEndHour = 7;
    _sleepEndMinute = 0;

    // تمام سیٹنگز لوڈ کرنے والے فنکشنز
    _loadSoundSettings(); // آواز کی نئی سیٹنگز کے لیے (Phase 10.3)
    _loadSleepHours(); // سونے کے اوقات لوڈ کرنے کے لیے
    _loadSpecialReminders(); // اسپیشل ریمائنڈرز لوڈ کرنے کے لیے
    _loadDailyGoal(); // ڈیلی گول لوڈ کرنے کے لیے
    _loadReminderSystem(); // ریمائنڈر سسٹم کے لیے
    _loadCustomReminderTimes(); // کسٹم ریمائنڈرز کے لیے
  }

  // ==========================================
  // [FUNCTION: LOAD SOUND SETTINGS]
  // اردو کمنٹ: محفوظ شدہ آواز اور موڈ کو میموری سے واپس لانا
  // ==========================================
  void _loadSoundSettings() async {
    final mode = await SoundService.getReminderMode();
    final soundKey = await SoundService.getSound();
    final customPath = await SoundService.getCustomPath();

    setState(() {
      _currentMode = mode;
      _selectedSoundKey = soundKey;

      // اگر کسٹم فائل ہے تو اس کا نام دکھائیں، ورنہ لسٹ سے نام اٹھائیں
      if (soundKey == 'custom' && customPath != null) {
        _selectedSoundName = customPath.split('/').last;
      } else {
        _selectedSoundName = SoundService.waterSounds[soundKey] ?? 'Water Flow';
      }
    });
  }

// ==========================================
  // [BLOCK: SPECIAL DATA LOADING]
  // محفوظ شدہ اسپیشل ریمائنڈرز کا ڈیٹا لوڈ کرنا
  // ==========================================
  Future<void> _loadSpecialReminders() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      for (int i = 0; i < 3; i++) {
        int id = 201 + i;
        _specialEnabled[i] = prefs.getBool('special_${id}_enabled') ?? false;
        _specialHours[i] = prefs.getInt('special_${id}_hour') ?? 0;
        _specialMinutes[i] = prefs.getInt('special_${id}_min') ?? 0;
        _specialMessages[i] =
            prefs.getString('special_${id}_msg') ?? "Special ${i + 1}";
      }
    });
  }

  // ==========================================
  // [BLOCK: CUSTOM SCHEDULE STORAGE]
  // [PHASE 10.5B-4]
  //
  // اردو کمنٹ:
  // Custom reminder slots کو SharedPreferences میں save/load کرنا
  // ہر slot میں:
  // - hour
  // - minute
  // - enabled
  //
  // format: "6:0:1,7:30:1,9:0:0"
  // ==========================================

  List<Map<String, dynamic>> _defaultCustomReminderSlots() {
    return [
      {'hour': 6, 'minute': 0, 'enabled': true},
      {'hour': 7, 'minute': 30, 'enabled': true},
      {'hour': 9, 'minute': 0, 'enabled': true},
      {'hour': 10, 'minute': 0, 'enabled': true},
      {'hour': 11, 'minute': 0, 'enabled': true},
      {'hour': 12, 'minute': 0, 'enabled': true},
      {'hour': 13, 'minute': 0, 'enabled': true},
      {'hour': 14, 'minute': 0, 'enabled': true},
      {'hour': 15, 'minute': 0, 'enabled': true},
      {'hour': 16, 'minute': 0, 'enabled': true},
      {'hour': 17, 'minute': 0, 'enabled': true},
      {'hour': 18, 'minute': 0, 'enabled': true},
      {'hour': 19, 'minute': 30, 'enabled': true},
      {'hour': 21, 'minute': 0, 'enabled': true},
      {'hour': 22, 'minute': 30, 'enabled': true},
    ];
  }

  int _slotMinutes(Map<String, dynamic> slot) {
    final int hour = slot['hour'] as int;
    final int minute = slot['minute'] as int;
    return hour * 60 + minute;
  }

  void _sortCustomReminderSlots() {
    _customReminderSlots.sort((a, b) {
      return _slotMinutes(a).compareTo(_slotMinutes(b));
    });
  }

  Future<void> _loadCustomReminderTimes() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_customReminderTimesKey) ?? "";

    final List<Map<String, dynamic>> loadedSlots = [];

    if (raw.trim().isNotEmpty) {
      final parts = raw.split(',');

      for (final part in parts) {
        final pieces = part.split(':');

        if (pieces.length >= 2) {
          final hour = int.tryParse(pieces[0]);
          final minute = int.tryParse(pieces[1]);

          // old format migration:
          // "6:0" => enabled true
          // new format:
          // "6:0:1" => enabled true
          final bool enabled = pieces.length >= 3 ? pieces[2] == '1' : true;

          if (hour != null &&
              minute != null &&
              hour >= 0 &&
              hour <= 23 &&
              minute >= 0 &&
              minute <= 59) {
            loadedSlots.add({
              'hour': hour,
              'minute': minute,
              'enabled': enabled,
            });
          }
        }
      }
    }

    if (loadedSlots.isEmpty) {
      loadedSlots.addAll(_defaultCustomReminderSlots());
    }

    loadedSlots.sort((a, b) {
      final aMinutes = (a['hour'] as int) * 60 + (a['minute'] as int);
      final bMinutes = (b['hour'] as int) * 60 + (b['minute'] as int);
      return aMinutes.compareTo(bMinutes);
    });

    if (!mounted) return;
    setState(() {
      _customReminderSlots = loadedSlots;
    });

    await _saveCustomReminderTimes();
  }

  Future<void> _saveCustomReminderTimes() async {
    final prefs = await SharedPreferences.getInstance();

    _sortCustomReminderSlots();

    final raw = _customReminderSlots
        .map((slot) =>
            '${slot['hour']}:${slot['minute']}:${slot['enabled'] == true ? 1 : 0}')
        .join(',');

    await prefs.setString(_customReminderTimesKey, raw);

    // ==========================================
    // [PHASE 10.5B-5]
    // اردو کمنٹ:
    // اگر Custom Schedule active ہو تو
    // save ہوتے ہی reminders دوبارہ schedule کریں
    // ==========================================
    if (_reminderSystem == 'Custom Schedule') {
      await NotificationService.scheduleCustomReminders(
        _customReminderSlots,
      );
    }
  }

// ==========================================
  // [BLOCK: DATA LOADING LOGIC]
  // اردو کمنٹ: میموری سے ڈیٹا لوڈ کرنے کی لاجک
  // ==========================================

  // نوٹ: پرانا _loadSound اب _loadSoundSettings میں منتقل ہو چکا ہے

  Future<void> _loadSleepHours() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _sleepStartHour = prefs.getInt(_sleepStartHourKey) ?? 23;
      _sleepStartMinute = prefs.getInt(_sleepStartMinuteKey) ?? 0;
      _sleepEndHour = prefs.getInt(_sleepEndHourKey) ?? 7;
      _sleepEndMinute = prefs.getInt(_sleepEndMinuteKey) ?? 0;
    });
  }

  // ==========================================
  // [BLOCK: DAILY GOAL LOGIC]
  // اردو کمنٹ: روزانہ پانی کے ہدف کو load/save/edit کرنے کی logic
  // ==========================================

  Future<void> _loadDailyGoal() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;

    setState(() {
      _dailyGoal = prefs.getInt(_dailyGoalKey) ?? 2000;
    });
  }

  // ==========================================
  // [BLOCK: REMINDER SYSTEM MODE LOGIC]
  // اردو کمنٹ:
  // Smart Hourly / Custom Schedule / Hybrid selection کو save/load کرنا
  // ابھی یہ foundation ہے؛ custom scheduler اگلے steps میں activate ہو گا
  // ==========================================

  Future<void> _loadReminderSystem() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;
    setState(() {
      _reminderSystem = prefs.getString(_reminderSystemKey) ?? 'Smart Hourly';
    });
  }

  Future<void> _saveReminderSystem(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_reminderSystemKey, value);

    if (!mounted) return;
    setState(() {
      _reminderSystem = value;
    });

    if (value == 'Smart Hourly') {
      await NotificationService.cancelCustomReminders();
      await NotificationService.scheduleHourlyReminder();
    } else if (value == 'Custom Schedule') {
      await NotificationService.cancelRegularReminders();
      await NotificationService.scheduleCustomReminders(_customReminderSlots);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Reminder system set to $value"),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showReminderSystemPicker() {
    final List<String> systems = [
      'Smart Hourly',
      'Custom Schedule',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: _darkTheme ? const Color(0xFF1A1C1E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Select Reminder System",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _darkTheme ? Colors.white : Colors.blue.shade900,
                  ),
                ),
                const SizedBox(height: 10),
                ...systems.map(
                  (system) => ListTile(
                    leading: Icon(
                      system == 'Smart Hourly'
                          ? Icons.schedule_rounded
                          : system == 'Custom Schedule'
                              ? Icons.edit_calendar_rounded
                              : Icons.auto_awesome_rounded,
                      color: _reminderSystem == system
                          ? Colors.blue.shade400
                          : Colors.grey,
                    ),
                    title: Text(
                      system,
                      style: TextStyle(
                        color: _darkTheme ? Colors.white : Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      system == 'Smart Hourly'
                          ? "Automatic hourly reminders with sleep hours"
                          : "Choose your own reminder times",
                      style: TextStyle(
                        color: _darkTheme
                            ? Colors.white54
                            : Colors.blue.shade900.withOpacity(0.6),
                      ),
                    ),
                    trailing: _reminderSystem == system
                        ? Icon(Icons.check_circle, color: Colors.blue.shade400)
                        : null,
                    onTap: () async {
                      await _saveReminderSystem(system);
                      if (context.mounted) Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveDailyGoal(int goal) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_dailyGoalKey, goal);

    if (!mounted) return;
    setState(() {
      _dailyGoal = goal;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Daily goal updated to $goal ml")),
    );
  }

  void _showDailyGoalPicker() {
    final List<int> goals = [
      600,
      800,
      1000,
      1200,
      1500,
      1800,
      2000,
      2500,
      3000,
      3500,
      4000,
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _darkTheme ? const Color(0xFF1A1C1E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.65,
            child: Column(
              children: [
                const SizedBox(height: 16),
                Text(
                  "Select Daily Goal",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _darkTheme ? Colors.white : Colors.blue.shade900,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: goals.length,
                    itemBuilder: (context, index) {
                      final goal = goals[index];

                      return ListTile(
                        leading: Icon(
                          Icons.water_drop_rounded,
                          color: _dailyGoal == goal
                              ? Colors.blue.shade400
                              : Colors.grey,
                        ),
                        title: Text(
                          "$goal ml",
                          style: TextStyle(
                            color: _darkTheme ? Colors.white : Colors.black87,
                          ),
                        ),
                        trailing: _dailyGoal == goal
                            ? Icon(Icons.check_circle,
                                color: Colors.blue.shade400)
                            : null,
                        onTap: () async {
                          await _saveDailyGoal(goal);
                          if (context.mounted) Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================
  // [BLOCK: STORAGE & ACTIONS LOGIC]
  // ==========================================
  Future<void> _saveSleepHours({
    int? startHour,
    int? startMin,
    int? endHour,
    int? endMin,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (startHour != null) await prefs.setInt(_sleepStartHourKey, startHour);
    if (startMin != null) await prefs.setInt(_sleepStartMinuteKey, startMin);
    if (endHour != null) await prefs.setInt(_sleepEndHourKey, endHour);
    if (endMin != null) await prefs.setInt(_sleepEndMinuteKey, endMin);

    await NotificationService.scheduleHourlyReminder();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sleep hours updated & Scheduled')),
    );
  }

  // ==========================================
  // [BLOCK: SAVE SPECIAL REMINDER]
  // [PHASE 10.3B / 10.4B LOCKED SPECIAL BEHAVIOR]
  //
  // اردو کمنٹ:
  // اسپیشل ریمائنڈر save کرتے وقت current sound + mode بھی lock ہوں گے
  // تاکہ app restart / restore / global mode change کے بعد بھی
  // یہ reminder اسی sound + mode کے ساتھ چلے جس میں user نے اسے save کیا تھا
  // ==========================================
  Future<void> _saveSpecialReminder(
      int index, bool enabled, int h, int m, String msg) async {
    final prefs = await SharedPreferences.getInstance();

    final int id = 201 + index; // IDs: 201, 202, 203

    final String cleanMessage =
        msg.trim().isEmpty ? "Special Reminder" : msg.trim();

    // موجودہ global sound + mode کو special reminder کے لیے lock کریں
    final String lockedSound = await SoundService.getSound();
    final String lockedMode = await SoundService.getReminderMode();

    await NotificationService.cancelNotification(id);

    await prefs.setBool('special_${id}_enabled', enabled);
    await prefs.setInt('special_${id}_hour', h);
    await prefs.setInt('special_${id}_min', m);
    await prefs.setString('special_${id}_msg', cleanMessage);

    // save-time sound/mode lock
    await prefs.setString('special_${id}_sound', lockedSound);
    await prefs.setString('special_${id}_mode', lockedMode);

    if (enabled) {
      await NotificationService.scheduleSpecialReminder(
        id,
        h,
        m,
        cleanMessage,
        soundKey: lockedSound,
        mode: lockedMode,
      );
    }

    await _loadSpecialReminders();
  }

  // ==========================================
  // [BLOCK: UI PICKERS & DIALOGS]
  // ==========================================
  Future<void> _selectSleepHour({
    required bool isStartHour,
    required int initialHour,
    required int initialMinute,
  }) async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: initialHour, minute: initialMinute),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              helpTextStyle: TextStyle(
                color: widget.isDark ? Colors.white : Colors.blue.shade900,
              ),
            ),
          ),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
    );
    if (selectedTime == null) return;
    if (!mounted) return;
    setState(() {
      if (isStartHour) {
        _sleepStartHour = selectedTime.hour;
        _sleepStartMinute = selectedTime.minute;
      } else {
        _sleepEndHour = selectedTime.hour;
        _sleepEndMinute = selectedTime.minute;
      }
    });
    await _saveSleepHours(
      startHour: isStartHour ? selectedTime.hour : null,
      startMin: isStartHour ? selectedTime.minute : null,
      endHour: isStartHour ? null : selectedTime.hour,
      endMin: isStartHour ? null : selectedTime.minute,
    );
  }

  String _formatTime(int hour, int minute) {
    final normalizedHour = hour % 24;
    final displayHour = normalizedHour == 0
        ? 12
        : normalizedHour > 12
            ? normalizedHour - 12
            : normalizedHour;
    final suffix = normalizedHour >= 12 ? 'PM' : 'AM';
    return '$displayHour:${minute.toString().padLeft(2, '0')} $suffix';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.blue.shade900,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : Colors.blue.shade900,
        ),
      ),
      body: Stack(
        children: [
          // ==========================================
          // [SECTION: BACKGROUND DESIGN]
          // گریڈینٹ اور بڑا بیک گراؤنڈ آئیکن
          // ==========================================
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [const Color(0xFF0F172A), const Color(0xFF1E293B)]
                    : [Colors.teal.shade300, Colors.cyan.shade100],
              ),
            ),
          ),

          // ہسٹری سکرین کی طرح بڑا بیک گراؤنڈ آئیکن
          Positioned(
            bottom: 150, // آپ اسے اوپر نیچے کرنے کے لیے تبدیل کر سکتے ہیں
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.1, // اسے مدھم رکھا ہے تاکہ ڈیٹا واضح نظر آئے
              child: Icon(
                Icons.settings_rounded,
                size: 280,
                color: isDark ? Colors.white : Colors.blue.shade900,
              ),
            ), // یہاں Opacity کی بریکٹ بند ہوئی
          ), // یہاں Positioned کی بریکٹ بند ہوئی

// اصلی کانٹینٹ
// ==========================================
// [SECTION: MAIN CONTENT SCROLL] (Updated)
// اردو کمنٹ: سکرول پوزیشن کو محفوظ رکھنے کے لیے PageStorageKey کا استعمال
// ==========================================
          SingleChildScrollView(
            key: const PageStorageKey<String>(
                'settings_scroll_position'), // اب سکرول اوپر نہیں بھاگے گا
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(
                top: 120, bottom: 100, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ... آپ کا باقی تمام کوڈ یہاں آئے گا

// ==========================================
// [SECTION 1: APPEARANCE & PERSONALIZATION]
// اردو کمنٹ: تھیم، زبان اور روزانہ کے ہدف کی سیٹنگز
// ==========================================
                _buildSectionTitle("Appearance & Personalization", isDark),
                _buildGroupContainer(
                  isDark: isDark,
                  children: [
                    // 1: تھیم (Dark Theme)
                    _buildSettingTile(
                      isDark: isDark,
                      title: "Dark Theme",
                      icon: Icons.dark_mode_rounded,
                      showDivider: true,
                      trailing: Switch(
                        activeColor: Colors.blue.shade400,
                        value: _darkTheme,
                        onChanged: (value) {
                          setState(() => _darkTheme = value);
                          widget.onThemeToggle(value);
                        },
                      ),
                    ),

                    // 2: زبان (Language Selector) - فیز 10.3 کا حصہ
                    _buildSettingTile(
                      isDark: isDark,
                      title: "App Language",
                      subtitle:
                          "English • More languages coming soon", // یہاں منتخب زبان کا نام آئے گا
                      icon: Icons.translate_rounded,
                      showDivider: true,
                      onTap: () {
                        // زبان منتخب کرنے کا ڈائلاگ
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                "Language options will be added in a future update."),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),

                    // 3: ڈیلی گول (Daily Goal)
                    _buildSettingTile(
                      isDark: isDark,
                      title: "Daily Goal",
                      subtitle: "$_dailyGoal ml", // ڈیلی گول کا ویریبل
                      icon: Icons.water_drop_rounded,
                      showDivider: false,
                      onTap: _showDailyGoalPicker, // گول سیٹ کرنے کا ڈائیلاگ
                    ),
                  ],
                ),

// ==========================================
// [SECTION 2: NOTIFICATION & SOUNDS]
// اردو کمنٹ: ریمائنڈرز کے موڈ، آوازیں اور فاسٹنگ موڈ
// ==========================================
                _buildSectionTitle("Notification & Sounds", isDark),
                _buildGroupContainer(
                  isDark: isDark,
                  children: [
                    // 1: فاسٹنگ موڈ (Fasting Mode)
                    _buildSettingTile(
                      isDark: isDark,
                      title: "Fasting Mode",
                      subtitle: "Pause hydration reminders",
                      icon: Icons.timer_off_rounded,
                      showDivider: true,
                      trailing: Switch(
                        activeColor: Colors.blue.shade400,
                        value: _fasting,
                        onChanged: (value) async {
                          setState(() => _fasting = value);
                          widget.onFastingToggle(value);

                          if (value) {
                            await NotificationService.cancelRegularReminders();
                            await NotificationService.cancelCustomReminders();
                          } else {
                            if (_reminderSystem == 'Custom Schedule') {
                              await NotificationService.scheduleCustomReminders(
                                  _customReminderSlots);
                            } else {
                              await NotificationService
                                  .scheduleHourlyReminder();
                            }
                          }
                        },
                      ),
                    ),

                    // 2: ریمائنڈر موڈ (Sound/Vibrate/Silent)
                    // اردو کمنٹ: شو موڈ پکر (showModePicker) یہاں سے کال ہوگا
                    _buildSettingTile(
                      isDark: isDark,
                      title: "Reminder Mode",
                      subtitle: _currentMode,
                      icon: Icons.notifications_active_rounded,
                      showDivider: true,
                      onTap: () => _showModePicker(context, isDark),
                    ),

                    // 3: ریمائنڈر ساؤنڈ (Sound Selector)
                    // اردو کمنٹ: شو ساؤنڈ پکر (showSoundPicker) یہاں سے کال ہوگا
                    _buildSettingTile(
                      isDark: isDark,
                      title: "Reminder Sound",
                      subtitle: _selectedSoundName,
                      icon: Icons.music_note_rounded,
                      showDivider: false,
                      onTap: () => _showSoundPicker(context, isDark),
                    ),
                  ],
                ),

// ==========================================
// [SECTION: REMINDER SYSTEM]
// اردو کمنٹ:
// App کس reminder strategy پر چلے گی:
// Smart Hourly / Custom Schedule / Hybrid
// ==========================================
                _buildSectionTitle("Reminder System", isDark),
                _buildGroupContainer(
                  isDark: isDark,
                  children: [
                    _buildSettingTile(
                      isDark: isDark,
                      title: "Reminder System",
                      subtitle: _reminderSystem,
                      icon: Icons.tune_rounded,
                      showDivider: false,
                      onInfoTap: () {
                        _showReliabilityInfo(
                          title: "Reminder System",
                          message:
                              "Smart Hourly uses automatic hourly reminders and follows your Sleep Hours.\n\n"
                              "Custom Schedule lets you choose your own hydration reminder times.\n\n"
                              "Special Reminders stay separate and work with both systems.",
                        );
                      },
                      onTap: _showReminderSystemPicker,
                    ),
                  ],
                ),

// ==========================================
// [SECTION: CUSTOM SCHEDULE]
// [PHASE 10.5B-2]
// اردو کمنٹ:
// Custom Schedule mode کے لیے user-defined reminder times کی preview/list
// ابھی یہ UI foundation ہے؛ actual notification scheduling اگلے step میں آئے گی
// ==========================================
                _buildSectionTitle("Custom Schedule", isDark),
                _buildGroupContainer(
                  isDark: isDark,
                  children: [
                    _buildSettingTile(
                      isDark: isDark,
                      title: "Custom Reminder Times",
                      subtitle: _reminderSystem == 'Custom Schedule'
                          ? "${_customReminderSlots.length} reminder slots configured"
                          : "Available when Custom Schedule is selected",
                      icon: Icons.edit_calendar_rounded,
                      showDivider: false,
                      onInfoTap: () {
                        _showReliabilityInfo(
                          title: "Custom Schedule",
                          message:
                              "Custom Schedule lets you choose your own hydration reminder times.\n\n"
                              "It follows your selected reminder sound and mode.\n\n"
                              "Sleep Hours do not apply here because you control the exact reminder times.\n\n"
                              "Fasting Mode will still pause hydration reminders.",
                        );
                      },
                      onTap: () {
                        if (_reminderSystem != 'Custom Schedule') {
                          _showReliabilityInfo(
                            title: "Custom Schedule Inactive",
                            message:
                                "Select Custom Schedule from Reminder System to manage your custom reminder times.",
                          );
                          return;
                        }

                        _showCustomSchedulePreview();
                      },
                    ),
                  ],
                ),

// ==========================================
// [SECTION 3: SPECIAL REMINDERS]
// اردو کمنٹ:
// یہ reminders fasting mode میں بھی active رہتے ہیں
// اور save-time locked sound/mode استعمال کرتے ہیں
// ==========================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSectionTitle("Special Reminders", isDark),
                    IconButton(
                      icon: Icon(
                        Icons.info_outline_rounded,
                        size: 18,
                        color: isDark ? Colors.white30 : Colors.blue.shade700,
                      ),
                      onPressed: () {
                        _showReliabilityInfo(
                          title: "Special Reminders",
                          message:
                              "• Special reminders remain active even during Fasting Mode.\n\n"
                              "• Each special reminder uses the sound and mode active at the time of saving.\n\n"
                              "• To change a reminder's sound or mode, select the desired sound/mode and save the reminder again.\n\n"
                              "• Special reminders also restore automatically after phone restart.",
                        );
                      },
                    ),
                  ],
                ),
                _buildGroupContainer(
                  isDark: isDark,
                  children: [
                    // CARD: SPECIAL 1
                    _buildSettingTile(
                      isDark: isDark,
                      title: _specialMessages[0],
                      subtitle: _specialEnabled[0]
                          ? "Active at ${_formatTime(_specialHours[0], _specialMinutes[0])}"
                          : "Off",
                      icon: _specialEnabled[0]
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      showDivider: true,
                      onTap: () => _showSpecialEditor(0),
                    ),
                    // CARD: SPECIAL 2
                    _buildSettingTile(
                      isDark: isDark,
                      title: _specialMessages[1],
                      subtitle: _specialEnabled[1]
                          ? "Active at ${_formatTime(_specialHours[1], _specialMinutes[1])}"
                          : "Off",
                      icon: _specialEnabled[1]
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      showDivider: true,
                      onTap: () => _showSpecialEditor(1),
                    ),
                    // CARD: SPECIAL 3
                    _buildSettingTile(
                      isDark: isDark,
                      title: _specialMessages[2],
                      subtitle: _specialEnabled[2]
                          ? "Active at ${_formatTime(_specialHours[2], _specialMinutes[2])}"
                          : "Off",
                      icon: _specialEnabled[2]
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      showDivider: false,
                      onTap: () => _showSpecialEditor(2),
                    ),
                  ],
                ),

// ==========================================
// [SECTION 4: SCHEDULE & SYSTEM]
// اردو کمنٹ: سونے کے اوقات اور بیٹری کی اہم سیٹنگز
// ==========================================
                _buildSectionTitle("Schedule & System", isDark),
                _buildGroupContainer(
                  isDark: isDark,
                  children: [
                    _buildSettingTile(
                      isDark: isDark,
                      title: "Sleep Start Hour",
                      subtitle: _formatTime(_sleepStartHour, _sleepStartMinute),
                      icon: Icons.bedtime_rounded,
                      showDivider: true,
                      onTap: () => _selectSleepHour(
                          isStartHour: true,
                          initialHour: _sleepStartHour,
                          initialMinute: _sleepStartMinute),
                    ),
                    _buildSettingTile(
                      isDark: isDark,
                      title: "Sleep End Hour",
                      subtitle: _formatTime(_sleepEndHour, _sleepEndMinute),
                      icon: Icons.wb_sunny_rounded,
                      showDivider: true,
                      onTap: () => _selectSleepHour(
                          isStartHour: false,
                          initialHour: _sleepEndHour,
                          initialMinute: _sleepEndMinute),
                    ),
                    _buildSettingTile(
                      isDark: isDark,
                      title: "Battery Optimization",
                      subtitle: "Required for reliable reminders",
                      icon: Icons.battery_saver_rounded,
                      showDivider: true,
                      onInfoTap: () {
                        _showReliabilityInfo(
                          title: "Battery Optimization",
                          message:
                              "For reliable reminders, set StayHydro to Not Optimized in battery settings. This helps Android avoid delaying or stopping reminders.",
                        );
                      },
                      onTap: () async {
                        await NotificationService
                            .openBatteryOptimizationSettings();
                      },
                    ),
                    _buildSettingTile(
                      isDark: isDark,
                      title: "Auto Start & Background",
                      subtitle: "Enable auto start and background activity",
                      icon: Icons.power_settings_new_rounded,
                      showDivider: false,
                      onInfoTap: () {
                        _showReliabilityInfo(
                          title: "Auto Start & Background Activity",
                          message:
                              "Allow Auto Start and Background Activity for StayHydro, especially on Oppo, Realme, Vivo and Xiaomi phones. This helps reminders continue after restart and while the app is closed.",
                        );
                      },
                      onTap: () async {
                        await NotificationService.openAutoStartSettings();
                      },
                    ),
                  ],
                ),

// ==========================================
// [SECTION: REMINDER RELIABILITY TIPS]
// اردو کمنٹ:
// Reminder reliability بہتر بنانے کے لیے اہم ہدایات
// خاص طور پر Oppo / Xiaomi / Vivo devices کے لیے
// ==========================================
                _buildSectionTitle("Reminder Reliability Tips", isDark),

                _buildGroupContainer(
                  isDark: isDark,
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.battery_saver_rounded,
                        color: Colors.orange.shade400,
                      ),
                      title: Text(
                        "Disable Battery Optimization",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.blue.shade900,
                        ),
                      ),
                      subtitle: Text(
                        "Set StayHydro to Not Optimized for reliable reminders.",
                        style: TextStyle(
                          color: isDark
                              ? Colors.white54
                              : Colors.blue.shade900.withOpacity(0.6),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 56),
                      child: Container(
                        height: 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              isDark
                                  ? Colors.white10
                                  : Colors.blue.shade100.withOpacity(0.3),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.power_settings_new_rounded,
                        color: Colors.green.shade400,
                      ),
                      title: Text(
                        "Enable Auto Start",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.blue.shade900,
                        ),
                      ),
                      subtitle: Text(
                        "Recommended for Oppo, Xiaomi, Vivo & Realme devices.",
                        style: TextStyle(
                          color: isDark
                              ? Colors.white54
                              : Colors.blue.shade900.withOpacity(0.6),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 56),
                      child: Container(
                        height: 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              isDark
                                  ? Colors.white10
                                  : Colors.blue.shade100.withOpacity(0.3),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.sync_rounded,
                        color: Colors.cyan.shade400,
                      ),
                      title: Text(
                        "Allow Background Activity",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.blue.shade900,
                        ),
                      ),
                      subtitle: Text(
                        "Helps reminders continue while the app is closed.",
                        style: TextStyle(
                          color: isDark
                              ? Colors.white54
                              : Colors.blue.shade900.withOpacity(0.6),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 56),
                      child: Container(
                        height: 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              isDark
                                  ? Colors.white10
                                  : Colors.blue.shade100.withOpacity(0.3),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.notifications_active_rounded,
                        color: Colors.blue.shade400,
                      ),
                      title: Text(
                        "Allow Notifications & Exact Alarms",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.blue.shade900,
                        ),
                      ),
                      subtitle: Text(
                        "Required for accurate reminder delivery.",
                        style: TextStyle(
                          color: isDark
                              ? Colors.white54
                              : Colors.blue.shade900.withOpacity(0.6),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 56),
                      child: Container(
                        height: 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              isDark
                                  ? Colors.white10
                                  : Colors.blue.shade100.withOpacity(0.3),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.restart_alt_rounded,
                        color: Colors.purple.shade300,
                      ),
                      title: Text(
                        "Restart Reliability",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.blue.shade900,
                        ),
                      ),
                      subtitle: Text(
                        "StayHydro restores reminders automatically after reboot.",
                        style: TextStyle(
                          color: isDark
                              ? Colors.white54
                              : Colors.blue.shade900.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ],
                ),

                // ==========================================
                // [SECTION 5: APP SUPPORT]
                // اردو کمنٹ: ٹیسٹ نوٹیفیکیشن اور ہیلپ
                // ==========================================
                _buildSectionTitle("App Support", isDark),
                _buildGroupContainer(
                  isDark: isDark,
                  children: [
                    _buildSettingTile(
                      isDark: isDark,
                      title: "Test Notification",
                      subtitle: "Check if reminders are working",
                      icon: Icons.notification_important_rounded,
                      trailing: Icon(
                        Icons.play_circle_fill_rounded,
                        color: Colors.blue.withOpacity(0.7),
                      ),
                      showDivider: true,
                      onTap: () async {
                        await NotificationService.showTestNotification();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text("Test notification sent!"),
                            backgroundColor: isDark
                                ? Colors.blueGrey[800]
                                : Colors.blue[600],
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                    _buildSettingTile(
                      isDark: isDark,
                      title: "Help & Feedback",
                      subtitle: "Report a problem or suggest a feature",
                      icon: Icons.help_outline_rounded,
                      showDivider: false,
                      onTap: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // [FUNCTION: CUSTOM SCHEDULE PREVIEW]
  // [PHASE 10.5B-4]
  //
  // اردو کمنٹ:
  // Custom reminder slots کی editable preview bottom sheet
  // ابھی actual notification scheduling اگلے step میں آئے گی
  // ==========================================
  void _showCustomSchedulePreview() {
    final bool isDark = _darkTheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF1A1C1E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.72,
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Custom Reminder Times",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.blue.shade900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Enable, disable or edit each hydration reminder time.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? Colors.white54
                            : Colors.blue.shade900.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: _customReminderSlots.isEmpty
                          ? Center(
                              child: Text(
                                "No custom times yet.",
                                style: TextStyle(
                                  color:
                                      isDark ? Colors.white54 : Colors.black54,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: _customReminderSlots.length,
                              itemBuilder: (context, index) {
                                final slot = _customReminderSlots[index];
                                final int hour = slot['hour'] as int;
                                final int minute = slot['minute'] as int;
                                final bool enabled =
                                    slot['enabled'] as bool? ?? true;

                                return ListTile(
                                  leading: Icon(
                                    enabled
                                        ? Icons.access_time_rounded
                                        : Icons.timer_off_rounded,
                                    color: enabled
                                        ? Colors.blue.shade400
                                        : Colors.grey,
                                  ),
                                  title: Text(
                                    _formatTime(hour, minute),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: enabled
                                          ? (isDark
                                              ? Colors.white
                                              : Colors.black87)
                                          : Colors.grey,
                                    ),
                                  ),
                                  subtitle: Text(
                                    enabled
                                        ? "Custom hydration reminder"
                                        : "Disabled",
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.white54
                                          : Colors.blue.shade900
                                              .withOpacity(0.6),
                                    ),
                                  ),
                                  trailing: Switch(
                                    value: enabled,
                                    activeColor: Colors.blue.shade400,
                                    onChanged: (value) async {
                                      setSheetState(() {
                                        _customReminderSlots[index]['enabled'] =
                                            value;
                                      });

                                      if (mounted) {
                                        setState(() {});
                                      }

                                      await _saveCustomReminderTimes();
                                    },
                                  ),
                                  onTap: () async {
                                    final picked = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay(
                                        hour: hour,
                                        minute: minute,
                                      ),
                                      builder: (context, child) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                            timePickerTheme:
                                                TimePickerThemeData(
                                              helpTextStyle: TextStyle(
                                                color: isDark
                                                    ? Colors.white
                                                    : Colors.blue.shade900,
                                              ),
                                            ),
                                          ),
                                          child: MediaQuery(
                                            data:
                                                MediaQuery.of(context).copyWith(
                                              alwaysUse24HourFormat: true,
                                            ),
                                            child: child ??
                                                const SizedBox.shrink(),
                                          ),
                                        );
                                      },
                                    );

                                    if (picked == null) return;

                                    setSheetState(() {
                                      _customReminderSlots[index]['hour'] =
                                          picked.hour;
                                      _customReminderSlots[index]['minute'] =
                                          picked.minute;
                                      _sortCustomReminderSlots();
                                    });

                                    if (mounted) {
                                      setState(() {});
                                    }

                                    await _saveCustomReminderTimes();
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

// ==========================================
  // [BLOCK: SPECIAL REMINDER EDITOR]
  // اسپیشل ریمائنڈر کو ایڈٹ کرنے والی باٹم شیٹ
  // ==========================================
  void _showSpecialEditor(int index) {
    final bool isDark = _darkTheme;
    // ٹیکسٹ کنٹرولر تاکہ یوزر کا میسج ایڈٹ ہو سکے
    TextEditingController msgController =
        TextEditingController(text: _specialMessages[index]);
    int tempHour = _specialHours[index];
    int tempMinute = _specialMinutes[index];
    bool tempEnabled = _specialEnabled[index];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // گلاس مورفزم کے لیے
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              top: 20,
              left: 20,
              right: 20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // اوپر والی چھوٹی لائن (Handle)
              Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 20),

              // ٹائٹل اور سوئچ
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Edit Special Reminder",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.blue.shade900)),
                  Switch(
                    value: tempEnabled,
                    onChanged: (val) => setSheetState(() => tempEnabled = val),
                    activeColor: Colors.blue.shade400,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ٹائم سلیکٹر بٹن
              ListTile(
                tileColor: Colors.blue.withOpacity(0.05),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                leading:
                    const Icon(Icons.access_time_rounded, color: Colors.blue),
                title: const Text("Select Time"),
                trailing: Text(_formatTime(tempHour, tempMinute),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                onTap: () async {
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(hour: tempHour, minute: tempMinute),
                  );
                  if (picked != null) {
                    setSheetState(() {
                      tempHour = picked.hour;
                      tempMinute = picked.minute;
                    });
                  }
                },
              ),
              const SizedBox(height: 15),

              // میسج لکھنے کی جگہ (TextField)
              TextField(
                controller: msgController,
                maxLength: 25,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  labelText: "Reminder Message",
                  prefixIcon: const Icon(Icons.edit_note_rounded),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),
              const SizedBox(height: 20),

              // سیو بٹن
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () async {
                    await _saveSpecialReminder(
                      index,
                      tempEnabled,
                      tempHour,
                      tempMinute,
                      msgController.text,
                    );
                    if (context.mounted) Navigator.pop(context);
                  },
                  child: const Text("Save Reminder",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // [FUNCTION: RESCHEDULE ACTIVE REMINDER SYSTEM]
  // [PHASE 10.5B FIX]
  //
  // اردو کمنٹ:
  // sound/mode change کے بعد صرف active reminder system دوبارہ schedule ہو گا
  // Smart Hourly active ہو تو hourly
  // Custom Schedule active ہو تو custom
  // Special reminders untouched رہیں گے
  // ==========================================
  Future<void> _rescheduleActiveReminderSystem() async {
    if (_reminderSystem == 'Custom Schedule') {
      await NotificationService.scheduleCustomReminders(_customReminderSlots);
    } else {
      await NotificationService.scheduleHourlyReminder();
    }
  }

// ==========================================
// [FUNCTION: SHOW MODE PICKER] (Updated Phase 10.4)
// اردو کمنٹ: ریمائنڈر کے طریقے منتخب کرنے اور فوری فیڈ بیک دینے کا فنکشن
// ==========================================
  void _showModePicker(BuildContext context, bool isDark) {
    final List<String> modes = [
      'Sound + Vibrate',
      'Sound only',
      'Vibrate only',
      'Silent'
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1A1C1E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Select Reminder Mode",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87)),
              const SizedBox(height: 10),
              ...modes
                  .map((mode) => ListTile(
                        leading: Icon(
                          mode == 'Silent'
                              ? Icons.notifications_off_rounded
                              : Icons.notifications_active_rounded,
                          color: _currentMode == mode
                              ? Colors.blue.shade400
                              : Colors.grey,
                        ),
                        title: Text(mode,
                            style: TextStyle(
                                color: isDark ? Colors.white : Colors.black87)),
                        trailing: _currentMode == mode
                            ? Icon(Icons.check_circle,
                                color: Colors.blue.shade400)
                            : null,
                        onTap: () async {
                          setState(() => _currentMode = mode);

                          // [PHASE 10.4C]
                          // نیا mode save کریں
                          await SoundService.setReminderMode(mode);

                          // Hourly یا کسٹم reminders کو نئے mode کے مطابق دوبارہ schedule کریں
                          // Special reminders کو یہاں touch نہیں کریں گے
                          await _rescheduleActiveReminderSystem();

                          // Preview صرف user feedback کے لیے
                          SoundService.playWaterSound();

                          Navigator.pop(context);
                        },
                      ))
                  .toList(),
            ],
          ),
        );
      },
    );
  }

// ==========================================
// [FUNCTION: SHOW SOUND PICKER] (Updated Phase 10.4)
// اردو کمنٹ: آواز منتخب کرنے اور منتخب شدہ آواز کا فوری پریویو (Preview) سنانے کا فنکشن
// ==========================================
  void _showSoundPicker(BuildContext context, bool isDark) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1A1C1E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Select Notification Sound",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87)),
              const SizedBox(height: 10),
              ...SoundService.waterSounds.entries
                  .where((e) => e.key != 'custom')
                  .map((entry) => ListTile(
                        leading: Icon(Icons.music_note_rounded,
                            color: _selectedSoundKey == entry.key
                                ? Colors.blue.shade400
                                : Colors.grey),
                        title: Text(entry.value,
                            style: TextStyle(
                                color: isDark ? Colors.white : Colors.black87)),
                        onTap: () async {
                          setState(() {
                            _selectedSoundKey = entry.key;
                            _selectedSoundName = entry.value;
                          });

                          // ⭐ منتخب ساؤنڈ save کریں
                          await SoundService.setSound(entry.key);

                          // ⭐ DEBUG: confirm کریں کہ save ہو گئی
                          print("SOUND PICKER SAVED: ${entry.key}");

                          // ⭐ بہت اہم:
                          // نئی sound کے مطابق channel recreate کریں
                          await NotificationService.recreateReminderChannel();

                          // ⭐ بہت اہم:
                          // تمام reminders دوبارہ schedule کریں
                          await _rescheduleActiveReminderSystem();

                          // ⭐ preview چلائیں
                          SoundService.playWaterSound();

                          Navigator.pop(context);
                        },
                      ))
                  .toList(),
            ],
          ),
        );
      },
    );
  }

  // ==========================================
  // [BLOCK: UI HELPER WIDGETS]
  // ==========================================

  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 8, top: 10),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          // کلرز کو مزید واضح کر دیا گیا ہے
          color: isDark ? Colors.blue.shade300 : Colors.blue.shade900,
        ),
      ),
    );
  }

  Widget _buildGroupContainer({
    required List<Widget> children,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        // گلاس مورفزم ایفیکٹ (لائٹ اور ڈارک دونوں کے لیے ٹرانسپیرنسی)
        color: isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.white.withOpacity(0.4), // لائٹ میں 60% شفافیت
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.white.withOpacity(0.2),
        ),
        boxShadow: const [], // تمام شیڈوز ختم کر دیے گئے ہیں
      ),
      child: Column(children: children),
    );
  }

  // ==========================================
  // [FUNCTION: SHOW RELIABILITY INFO DIALOG]
  // اردو کمنٹ:
  // Battery / Auto Start / Background Activity کی وضاحت الگ dialog میں دکھانے کے لیے
  // تاکہ settings screen فوراً کھلنے سے message ضائع نہ ہو
  // ==========================================
  void _showReliabilityInfo({
    required String title,
    required String message,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Got it"),
          ),
        ],
      ),
    );
  }

// ==========================================
// [FUNCTION: BUILD SETTING TILE] (Updated Phase 10.4)
// اردو کمنٹ: تمام کارڈز کی اونچائی (Height) کو ایک جیسا رکھنے کے لیے Constraints کا اضافہ
// ==========================================
  Widget _buildSettingTile({
    required bool isDark,
    required String title,
    String? subtitle,
    required IconData icon,
    Widget? trailing,
    VoidCallback? onTap,
    VoidCallback? onInfoTap,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        // Container کے ذریعے کم از کم اونچائی فکس کر دی گئی ہے
        Container(
          constraints: const BoxConstraints(
              minHeight: 70), // کارڈز کی یکساں موٹائی کے لیے
          alignment: Alignment.center,
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.blue.shade400, size: 22),
            ),
            title: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.blue.shade900,
              ),
            ),
            subtitle: subtitle != null
                ? Text(
                    subtitle,
                    style: TextStyle(
                      color: isDark
                          ? Colors.white54
                          : Colors.blue.shade900.withOpacity(0.6),
                      fontSize: 13,
                    ),
                  )
                : null,
            trailing: trailing ??
                (onInfoTap != null
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.info_outline_rounded,
                              size: 18,
                              color: isDark
                                  ? Colors.white38
                                  : Colors.blue.shade700,
                            ),
                            onPressed: onInfoTap,
                          ),
                          Icon(
                            Icons.chevron_right,
                            size: 20,
                            color:
                                isDark ? Colors.white30 : Colors.blue.shade200,
                          ),
                        ],
                      )
                    : Icon(
                        Icons.chevron_right,
                        size: 20,
                        color: isDark ? Colors.white30 : Colors.blue.shade200,
                      )),
            onTap: onTap,
          ),
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.only(left: 56),
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    isDark
                        ? Colors.white10
                        : Colors.blue.shade100.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
