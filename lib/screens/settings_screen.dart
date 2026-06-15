import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/notification_service.dart';
import 'package:stay_hydro/services/sound_service.dart'; // یہاں اپنے پراجیکٹ کا صحیح پاتھ دیں
import 'package:stay_hydro/core/app_strings.dart';
import 'package:flutter/services.dart';

class SettingsScreen extends StatefulWidget {
  final bool isDark;
  final Function(bool) onThemeToggle;
  final bool isFastingMode;
  final Function(bool) onFastingToggle;
  final Function(String) onLanguageChanged;

  const SettingsScreen({
    super.key,
    required this.isDark,
    required this.onThemeToggle,
    required this.isFastingMode,
    required this.onFastingToggle,
    required this.onLanguageChanged,
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
  String _currentMode = 'sound_vibrate';
  String _selectedSoundKey = 'water_glass';
  String _selectedSoundName = 'Water Flow';
  int _dailyGoal = 2000; // یوزر کا روزانہ کا ہدف (ڈیفالٹ: 2000ml)

// ڈیلی گول key شامل کی
  static const String _dailyGoalKey = 'daily_goal';

  String _selectedLanguage = 'English';

  static const String _languageKey = 'app_language'; // زبان کی key شامل کی

  // Reminder system selector
  // Smart Hourly = موجودہ hourly reminders
  // Custom Schedule = future custom times
  //// Hybrid currently postponed; Special Reminders remain independent.
  String _reminderSystem = 'smart_hourly';

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
    _loadLanguage(); // زبان تبدیلی کیے لیے
    _loadReminderSystem(); // ریمائنڈر سسٹم کے لیے
    _loadCustomReminderTimes(); // کسٹم ریمائنڈرز کے لیے
  }

//================================
// FOR HELP & FEEDBACK SECTION
// Open Support Email Helper
//================================
  // عارضی طور پر ہٹا دیا، ریلیز کے بعد دوبارہ لگایا جائے گا

// ==========================================
// [HELP & FEEDBACK DIALOG]
// اردو کمنٹ:
// Support emails دکھانے اور copy کرنے کے لیے custom dialog
// ==========================================
  void _showHelpFeedbackDialog() {
    final bool isDark = _darkTheme;

    Future<void> copyEmail(String email) async {
      await Clipboard.setData(ClipboardData(text: email));
      if (!mounted) return;
      Navigator.pop(context);
      _showSettingsSnackBar(AppStrings.t(AppStrings.emailCopied));
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1A1C1E) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: Text(
          AppStrings.t(AppStrings.helpFeedback),
          style: TextStyle(
            color: isDark ? Colors.white : Colors.blue.shade900,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.t('helpFeedbackInfoMessage'),
              style: TextStyle(
                color: isDark
                    ? Colors.white70
                    : Colors.blue.shade900.withOpacity(0.75),
              ),
            ),
            const SizedBox(height: 16),
            _buildCopyEmailButton(
              isDark: isDark,
              label: AppStrings.t(AppStrings.copyStayHydroEmail),
              email: 'hello.stayhydro@gmail.com',
              onCopy: copyEmail,
            ),
            const SizedBox(height: 8),
            _buildCopyEmailButton(
              isDark: isDark,
              label: AppStrings.t(AppStrings.copySlnovaEmail),
              email: 'hello.slnova@gmail.com',
              onCopy: copyEmail,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppStrings.t(AppStrings.gotIt)),
          ),
        ],
      ),
    );
  }

  Widget _buildCopyEmailButton({
    required bool isDark,
    required String label,
    required String email,
    required Future<void> Function(String email) onCopy,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => onCopy(email),
        icon: const Icon(Icons.copy_rounded, size: 18),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: isDark ? Colors.blue.shade200 : Colors.blue.shade700,
          side: BorderSide(
            color: isDark
                ? Colors.blue.shade900.withOpacity(0.5)
                : Colors.blue.shade200,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

// ==========================================
// [PHASE 10.6-A14: SOUND DISPLAY HELPER]
// اردو کمنٹ:
// sound key کو selected language کے مطابق user-facing name میں بدلنے کے لیے
// asset keys تبدیل نہیں ہوں گی
// ==========================================
  String _soundDisplayName(String soundKey) {
    switch (soundKey) {
      case 'digital_bell':
        return AppStrings.t('digitalBell');
      case 'soft_bell':
        return AppStrings.t('softBell');
      case 'soft_knock':
        return AppStrings.t('softKnock');
      case 'water_drop':
        return AppStrings.t('waterDrop');
      case 'water_glass':
        return AppStrings.t('waterPour');
      default:
        return AppStrings.t('waterPour');
    }
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
      _currentMode = _normalizeReminderMode(mode);
      _selectedSoundKey = soundKey;

      // اگر کسٹم فائل ہے تو اس کا نام دکھائیں، ورنہ لسٹ سے نام اٹھائیں
      if (soundKey == 'custom' && customPath != null) {
        _selectedSoundName = customPath.split('/').last;
      } else {
        _selectedSoundName = _soundDisplayName(soundKey);
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

//==========================================
// Special Reminders Helper Function
// اردو کمنٹ: سپیشل ریمائنڈرز کے ہیلپر فنکشن
//==========================================

  String _specialFallbackTitle(int index) {
    switch (index) {
      case 0:
        return AppStrings.t('medicineReminder');
      case 1:
        return AppStrings.t('wellnessReminder');
      case 2:
        return AppStrings.t('bedtimeWater');
      default:
        return AppStrings.t('healthReminder');
    }
  }

  IconData _specialIcon(int index, bool enabled) {
    if (!enabled) return Icons.notifications_none_rounded;

    switch (index) {
      case 0:
        return Icons.medication_rounded;
      case 1:
        return Icons.favorite_rounded;
      case 2:
        return Icons.nightlight_round;
      default:
        return Icons.health_and_safety_rounded;
    }
  }

  String _specialDisplayTitle(int index) {
    final msg = _specialMessages[index].trim();

    if (msg.isEmpty ||
        msg == "${AppStrings.specialReminderFallback} ${index + 1}" ||
        msg == AppStrings.specialReminder) {
      return _specialFallbackTitle(index);
    }

    return msg;
  }

//Special Reminders Message Off Subtitle helper

  String _specialOffSubtitle(int index) {
    switch (index) {
      case 0:
        return AppStrings.t(AppStrings.medicineReminderSubtitle);
      case 1:
        return AppStrings.t(AppStrings.wellnessReminderSubtitle);
      case 2:
        return AppStrings.t(AppStrings.bedtimeReminderSubtitle);
      default:
        return AppStrings.t(AppStrings.offTapHealthReminder);
    }
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
    bool shouldSaveLoadedSlots = false;

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
      shouldSaveLoadedSlots = true;
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

    if (shouldSaveLoadedSlots) {
      await _saveCustomReminderTimes();
    }
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
    if (_isCustomSchedule) {
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

//===========================================
// LANGUAGE FUNCTION LOGIC
// زبان لوڈ کرنے کی لاجک
//===========================================

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;
    setState(() {
      _selectedLanguage = prefs.getString(_languageKey) ?? 'English';
      AppStrings.setLanguage(_selectedLanguage);
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

// Reminder system change helper function
  String _localizedSystemDisplayName(String value) {
    if (value == 'smart_hourly' || value == 'Smart Hourly') {
      return AppStrings.t(AppStrings.smartHourly);
    }

    if (value == 'custom_schedule' || value == 'Custom Schedule') {
      return AppStrings.t(AppStrings.customScheduleMode);
    }

    return AppStrings.t(AppStrings.smartHourly);
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
      _reminderSystem = prefs.getString(_reminderSystemKey) ?? 'smart_hourly';
    });
  }

  Future<void> _saveReminderSystem(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_reminderSystemKey, value);

    if (!mounted) return;
    setState(() {
      _reminderSystem = value;
    });

    if (value == 'smart_hourly' || value == 'Smart Hourly') {
      await NotificationService.cancelCustomReminders();
      await NotificationService.scheduleHourlyReminder();
    } else if (value == 'custom_schedule' || value == 'Custom Schedule') {
      await NotificationService.cancelRegularReminders();
      await NotificationService.scheduleCustomReminders(_customReminderSlots);
    }

    _showSettingsSnackBar(
      "${AppStrings.t(AppStrings.reminderSystemChanged)} ${_localizedSystemDisplayName(value)}",
    );
  }

  void _showReminderSystemPicker() {
    final List<String> systems = [
      'smart_hourly',
      'custom_schedule',
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
                  AppStrings.t('selectReminderSystem'),
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
                      system == 'smart_hourly'
                          ? Icons.schedule_rounded
                          : system == 'custom_schedule'
                              ? Icons.edit_calendar_rounded
                              : Icons.auto_awesome_rounded,
                      color: _reminderSystem == system
                          ? Colors.blue.shade400
                          : Colors.grey,
                    ),
                    title: Text(
                      _systemDisplayName(system),
                      style: TextStyle(
                        color: _darkTheme ? Colors.white : Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      system == 'smart_hourly'
                          ? AppStrings.t('smartHourlySubtitle')
                          : AppStrings.t('customScheduleSubtitle'),
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

                      if (context.mounted) {
                        Navigator.pop(context);
                      }

                      Future.delayed(
                        const Duration(milliseconds: 100),
                        () {
                          if (mounted) {
                            setState(() {});
                          }
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

  Future<void> _saveDailyGoal(int goal) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_dailyGoalKey, goal);

    if (!mounted) return;
    setState(() {
      _dailyGoal = goal;
    });

    _showSettingsSnackBar(
      "${AppStrings.t('dailyGoalUpdated')} $goal ${AppStrings.t('ml')}",
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
                  AppStrings.t('selectDailyGoal'),
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
                          "$goal ${AppStrings.t('ml')}",
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

    if (_isSmartHourly) {
      await NotificationService.scheduleHourlyReminder();
    }

    if (!mounted) return;
    _showSettingsSnackBar(AppStrings.t('sleepHoursUpdated'));
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

    final String cleanMessage = msg.trim();

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
    final selectedTime = await _showStayHydroTimePicker(
      initialTime: TimeOfDay(hour: initialHour, minute: initialMinute),
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

// Time Picker Helper  پوری ایپ میں یکساں سٹآئل میں کرنے کے لیے

  Future<TimeOfDay?> _showStayHydroTimePicker({
    required TimeOfDay initialTime,
  }) async {
    final bool isDarkMode = _darkTheme;

    return showGeneralDialog<TimeOfDay>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) => const SizedBox.shrink(),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(
              CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                colorScheme: isDarkMode
                    ? ColorScheme.dark(
                        primary: Colors.blue.shade400,
                        onPrimary: Colors.white,
                        surface: const Color(0xFF1E293B),
                        onSurface: Colors.white,
                      )
                    : ColorScheme.light(
                        primary: Colors.blue.shade600,
                        onPrimary: Colors.white,
                        surface: Colors.white,
                        onSurface: Colors.blue.shade900,
                      ),
                timePickerTheme: TimePickerThemeData(
                  backgroundColor: isDarkMode
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFF5F6FA),
                  hourMinuteColor: WidgetStateColor.resolveWith(
                    (states) => states.contains(WidgetState.selected)
                        ? (isDarkMode
                            ? const Color(0xFF334155)
                            : Colors.blue.shade100)
                        : (isDarkMode ? Colors.black26 : Colors.white),
                  ),
                  hourMinuteTextColor: WidgetStateColor.resolveWith(
                    (states) => states.contains(WidgetState.selected)
                        ? (isDarkMode ? Colors.white : Colors.blue.shade900)
                        : (isDarkMode ? Colors.white70 : Colors.blue.shade400),
                  ),
                  dialBackgroundColor:
                      isDarkMode ? Colors.black26 : Colors.white,
                  dialHandColor: Colors.blue.shade400,
                  dialTextColor: isDarkMode ? Colors.white : Colors.black,
                  entryModeIconColor: Colors.blue.shade400,
                ),
              ),
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  alwaysUse24HourFormat: false,
                ),
                child: TimePickerDialog(
                  initialTime: initialTime,
                  initialEntryMode: TimePickerEntryMode.dialOnly,
                ),
              ),
            ),
          ),
        );
      },
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

  // ==========================================
// [PHASE 10.6-A15: SETTINGS SNACKBAR HELPER]
// اردو کمنٹ:
// Settings screen کے تمام snackbars کے لیے ایک جیسا style
// تاکہ کبھی نیلی، کبھی کالی پٹی نہ آئے
// ==========================================
  void _showSettingsSnackBar(String message) {
    if (!mounted) return;

    final bool isDark = _darkTheme;

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor:
            isDark ? const Color(0xFF334155) : Colors.blue.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        margin: const EdgeInsets.fromLTRB(18, 0, 18, 18),
        duration: const Duration(seconds: 2),
      ),
    );
  }

// ==========================================
// [PHASE 10.6-A10: LANGUAGE NATIVE NAME HELPER]
// اردو کمنٹ:
// زبان کا نام اسی زبان میں دکھانے کے لیے
// ==========================================
  String _languageNativeName(String language) {
    switch (language) {
      case 'Spanish':
        return 'Español';
      case 'Arabic':
        return 'العربية';
      case 'Hindi':
        return 'हिन्दी';
      case 'Indonesian':
        return 'Bahasa Indonesia';
      default:
        return 'English';
    }
  }

// Reminder Mode Display Helper

  String _normalizeReminderMode(String mode) {
    switch (mode) {
      case 'Sound + Vibrate':
      case 'sound_vibrate':
        return 'sound_vibrate';
      case 'Sound only':
      case 'sound_only':
        return 'sound_only';
      case 'Vibrate only':
      case 'vibrate_only':
        return 'vibrate_only';
      case 'Silent':
      case 'silent':
        return 'silent';
      default:
        return 'sound_vibrate';
    }
  }

  // ==========================================
  // [PHASE 10.6-A9: REMINDER MODE DISPLAY HELPER]
  // اردو کمنٹ:
  // memory میں mode key رہے گی، screen پر selected language کے مطابق text دکھے گا
  // ==========================================
  String _modeDisplayName(String modeKey) {
    modeKey = _normalizeReminderMode(modeKey);

    switch (modeKey) {
      case 'sound_vibrate':
      case 'Sound + Vibrate':
        return AppStrings.t('soundVibrate');
      case 'sound_only':
      case 'Sound only':
        return AppStrings.t('soundOnly');
      case 'vibrate_only':
      case 'Vibrate only':
        return AppStrings.t('vibrateOnly');
      case 'silent':
      case 'Silent':
        return AppStrings.t('silent');
      default:
        return AppStrings.t('soundVibrate');
    }
  }

  // ==========================================
  // [PHASE 10.6-A9: REMINDER SYSTEM DISPLAY HELPER]
  // اردو کمنٹ:
  // memory میں system key رہے گی، screen پر selected language کے مطابق text دکھے گا
  // ==========================================
  String _systemDisplayName(String systemKey) {
    switch (systemKey) {
      case 'smart_hourly':
      case 'Smart Hourly':
        return AppStrings.t('smartHourly');
      case 'custom_schedule':
      case 'Custom Schedule':
        return AppStrings.t('customSchedule');
      default:
        return AppStrings.t('smartHourly');
    }
  }

// ==========================================
// [PHASE 10.6-A9: ACTIVE SYSTEM HELPERS]
// اردو کمنٹ:
// پرانی saved values اور نئی key values دونوں کو support کرنے کے لیے
// helper کبھی خود کو call نہیں کرے گا، صرف _reminderSystem کو check کرے گا
// ==========================================
  bool get _isSmartHourly {
    return _reminderSystem == 'smart_hourly' ||
        _reminderSystem == 'Smart Hourly';
  }

  bool get _isCustomSchedule {
    return _reminderSystem == 'custom_schedule' ||
        _reminderSystem == 'Custom Schedule';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;

    return Directionality(
      textDirection:
          AppStrings.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(
            AppStrings.t('settings'),
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
                  _buildSectionTitle(
                      AppStrings.t('appearancePersonalization'), isDark),
                  _buildGroupContainer(
                    isDark: isDark,
                    children: [
                      // 1: تھیم (Dark Theme)
                      _buildSettingTile(
                        isDark: isDark,
                        title: AppStrings.t('darkTheme'),
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
                        title: AppStrings.t('appLanguage'),
                        subtitle:
                            "Language • ${_languageNativeName(_selectedLanguage)}",
                        icon: Icons.translate_rounded,
                        showDivider: true,
                        onTap: _showLanguagePicker,
                      ),

                      // 3: ڈیلی گول (Daily Goal)
                      _buildSettingTile(
                        isDark: isDark,
                        title: AppStrings.t('dailyGoal'),
                        subtitle:
                            "$_dailyGoal ${AppStrings.t('ml')}", // ڈیلی گول کا ویریبل
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
                  _buildSectionTitle(
                      AppStrings.t('notificationSounds'), isDark),
                  _buildGroupContainer(
                    isDark: isDark,
                    children: [
                      // 1: فاسٹنگ موڈ (Fasting Mode)
                      _buildSettingTile(
                        isDark: isDark,
                        title: AppStrings.t('fastingMode'),
                        subtitle: AppStrings.t('pauseHydrationReminders'),
                        icon: Icons.timer_off_rounded,
                        showDivider: true,
                        trailing: Switch(
                          activeColor: Colors.blue.shade400,
                          value: _fasting,
                          onChanged: (value) async {
                            setState(() => _fasting = value);
                            widget.onFastingToggle(value);

                            if (value) {
                              await NotificationService
                                  .cancelRegularReminders();
                              await NotificationService.cancelCustomReminders();
                            } else {
                              if (_isCustomSchedule) {
                                await NotificationService
                                    .scheduleCustomReminders(
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
                        title: AppStrings.t('reminderMode'),
                        subtitle: _modeDisplayName(_currentMode),
                        icon: Icons.notifications_active_rounded,
                        showDivider: true,
                        onTap: () => _showModePicker(context, isDark),
                      ),

                      // 3: ریمائنڈر ساؤنڈ (Sound Selector)
                      // اردو کمنٹ: شو ساؤنڈ پکر (showSoundPicker) یہاں سے کال ہوگا
                      _buildSettingTile(
                        isDark: isDark,
                        title: AppStrings.t('reminderSound'),
                        subtitle: _soundDisplayName(_selectedSoundKey),
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
                  _buildSectionTitle(AppStrings.t('reminderSystem'), isDark),
                  _buildGroupContainer(
                    isDark: isDark,
                    children: [
                      _buildSettingTile(
                        isDark: isDark,
                        title: AppStrings.t('reminderSystem'),
                        subtitle: _systemDisplayName(_reminderSystem),
                        icon: Icons.tune_rounded,
                        showDivider: false,
                        onInfoTap: () {
                          _showReliabilityInfo(
                            title: AppStrings.t('reminderSystem'),
                            message: AppStrings.t('reminderSystemInfoMessage'),
                          );
                        },
                        onTap: _showReminderSystemPicker,
                      ),
                    ],
                  ),

// ==========================================
// [SECTION: CUSTOM SCHEDULE]
// [PHASE 10.5B-8]
// اردو کمنٹ:
// Smart Hourly selected ہو تو Custom Schedule card inactive/faded دکھے گا
// مگر info button کام کرتا رہے گا
// ==========================================
                  _buildSectionTitle(AppStrings.t('customSchedule'), isDark),
                  _buildGroupContainer(
                    isDark: isDark,
                    children: [
                      Opacity(
                        opacity: _isCustomSchedule ? 1.0 : 0.45,
                        child: _buildSettingTile(
                          isDark: isDark,
                          title: AppStrings.t('customReminderTimes'),
                          subtitle: _isCustomSchedule
                              ? "${_customReminderSlots.length} ${AppStrings.t('reminderSlotsConfigured')}"
                              : AppStrings.t(
                                  AppStrings.onlyAvailableInCustomSchedule),
                          icon: Icons.edit_calendar_rounded,
                          showDivider: false,
                          onInfoTap: () {
                            _showReliabilityInfo(
                              title: AppStrings.t('customSchedule'),
                              message:
                                  AppStrings.t('customScheduleInfoMessage'),
                            );
                          },
                          onTap: () {
                            if (!_isCustomSchedule) {
                              _showReliabilityInfo(
                                title: AppStrings.customScheduleInactive,
                                message:
                                    AppStrings.customScheduleInactiveMessage,
                              );
                              return;
                            }

                            _showCustomSchedulePreview();
                          },
                        ),
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
                      _buildSectionTitle(
                          AppStrings.t('specialReminders'), isDark),
                      IconButton(
                        icon: Icon(
                          Icons.info_outline_rounded,
                          size: 18,
                          color: isDark ? Colors.white30 : Colors.blue.shade700,
                        ),
                        onPressed: () {
                          _showReliabilityInfo(
                            title: AppStrings.t('specialReminders'),
                            message:
                                AppStrings.t('specialRemindersInfoMessage'),
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
                        title: _specialDisplayTitle(0),
                        subtitle: _specialEnabled[0]
                            ? "${_formatTime(_specialHours[0], _specialMinutes[0])} • ${AppStrings.t('lockedSoundMode')}"
                            : _specialOffSubtitle(0),
                        icon: _specialIcon(0, _specialEnabled[0]),
                        showDivider: true,
                        onTap: () => _showSpecialEditor(0),
                      ),
                      // CARD: SPECIAL 2
                      _buildSettingTile(
                        isDark: isDark,
                        title: _specialDisplayTitle(1),
                        subtitle: _specialEnabled[1]
                            ? "${_formatTime(_specialHours[1], _specialMinutes[1])} • ${AppStrings.t('lockedSoundMode')}"
                            : _specialOffSubtitle(1),
                        icon: _specialIcon(1, _specialEnabled[1]),
                        showDivider: true,
                        onTap: () => _showSpecialEditor(1),
                      ),
                      // CARD: SPECIAL 3
                      _buildSettingTile(
                        isDark: isDark,
                        title: _specialDisplayTitle(2),
                        subtitle: _specialEnabled[2]
                            ? "${_formatTime(_specialHours[2], _specialMinutes[2])} • ${AppStrings.t('lockedSoundMode')}"
                            : _specialOffSubtitle(2),
                        icon: _specialIcon(2, _specialEnabled[2]),
                        showDivider: false,
                        onTap: () => _showSpecialEditor(2),
                      ),
                    ],
                  ),

// ==========================================
// [SECTION 4: SCHEDULE & SYSTEM]
// اردو کمنٹ: سونے کے اوقات اور بیٹری کی اہم سیٹنگز
// ==========================================
                  _buildSectionTitle(AppStrings.t('scheduleSystem'), isDark),
                  _buildGroupContainer(
                    isDark: isDark,
                    children: [
                      Opacity(
                        opacity: _isSmartHourly ? 1.0 : 0.45,
                        child: _buildSettingTile(
                          isDark: isDark,
                          title: AppStrings.t('sleepStartHour'),
                          subtitle: _isSmartHourly
                              ? _formatTime(_sleepStartHour, _sleepStartMinute)
                              : AppStrings.t('onlyAppliesSmartHourly'),
                          icon: Icons.bedtime_rounded,
                          showDivider: true,
                          onInfoTap: () {
                            _showReliabilityInfo(
                              title: AppStrings.t('sleepHours'),
                              message: AppStrings.t('sleepHoursInfoMessage'),
                            );
                          },
                          onTap: _isSmartHourly
                              ? () => _selectSleepHour(
                                    isStartHour: true,
                                    initialHour: _sleepStartHour,
                                    initialMinute: _sleepStartMinute,
                                  )
                              : null,
                        ),
                      ),
                      Opacity(
                        opacity: _isSmartHourly ? 1.0 : 0.45,
                        child: _buildSettingTile(
                          isDark: isDark,
                          title: AppStrings.t('sleepEndHour'),
                          subtitle: _isSmartHourly
                              ? _formatTime(_sleepEndHour, _sleepEndMinute)
                              : AppStrings.t('onlyAppliesSmartHourly'),
                          icon: Icons.wb_sunny_rounded,
                          showDivider: true,
                          onInfoTap: () {
                            _showReliabilityInfo(
                              title: AppStrings.t('sleepHours'),
                              message: AppStrings.t('sleepHoursInfoMessage'),
                            );
                          },
                          onTap: _isSmartHourly
                              ? () => _selectSleepHour(
                                    isStartHour: false,
                                    initialHour: _sleepEndHour,
                                    initialMinute: _sleepEndMinute,
                                  )
                              : null,
                        ),
                      ),
                      _buildSettingTile(
                        isDark: isDark,
                        title: AppStrings.t('batteryOptimization'),
                        subtitle: AppStrings.t('batteryOptimizationSubtitle'),
                        icon: Icons.battery_saver_rounded,
                        showDivider: true,
                        onInfoTap: () {
                          _showReliabilityInfo(
                            title: AppStrings.t('batteryOptimization'),
                            message:
                                AppStrings.t('batteryOptimizationInfoMessage'),
                          );
                        },
                        onTap: () async {
                          await NotificationService
                              .openBatteryOptimizationSettings();
                        },
                      ),
                      _buildSettingTile(
                        isDark: isDark,
                        title: AppStrings.t('autoStartBackground'),
                        subtitle: AppStrings.t('autoStartBackgroundSubtitle'),
                        icon: Icons.power_settings_new_rounded,
                        showDivider: false,
                        onInfoTap: () {
                          _showReliabilityInfo(
                            title: AppStrings.t('autoStartBackground'),
                            message:
                                AppStrings.t('autoStartBackgroundInfoMessage'),
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
                  _buildSectionTitle(
                      AppStrings.t('reminderReliabilityTips'), isDark),

                  _buildGroupContainer(
                    isDark: isDark,
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.battery_saver_rounded,
                          color: Colors.orange.shade400,
                        ),
                        title: Text(
                          AppStrings.t('disableBatteryOptimization'),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.blue.shade900,
                          ),
                        ),
                        subtitle: Text(
                          AppStrings.t('disableBatteryOptimizationSubtitle'),
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
                          AppStrings.t('enableAutoStart'),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.blue.shade900,
                          ),
                        ),
                        subtitle: Text(
                          AppStrings.t('enableAutoStartSubtitle'),
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
                          AppStrings.t('allowBackgroundActivity'),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.blue.shade900,
                          ),
                        ),
                        subtitle: Text(
                          AppStrings.t('allowBackgroundActivitySubtitle'),
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
                          AppStrings.t('allowNotificationsExactAlarms'),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.blue.shade900,
                          ),
                        ),
                        subtitle: Text(
                          AppStrings.t('allowNotificationsExactAlarmsSubtitle'),
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
                          AppStrings.t('restartReliability'),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.blue.shade900,
                          ),
                        ),
                        subtitle: Text(
                          AppStrings.t('restartReliabilitySubtitle'),
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
// اردو کمنٹ: ٹیسٹ نوٹیفیکیشن، ہیلپ، ری لایبلٹی اور ایپ معلومات
// ==========================================
                  _buildSectionTitle(AppStrings.t('appSupport'), isDark),
                  _buildGroupContainer(
                    isDark: isDark,
                    children: [
                      _buildSettingTile(
                        isDark: isDark,
                        title: AppStrings.t('testNotification'),
                        subtitle: AppStrings.t('testNotificationSubtitle'),
                        icon: Icons.notification_important_rounded,
                        trailing: Icon(
                          Icons.play_circle_fill_rounded,
                          color: Colors.blue.withOpacity(0.7),
                        ),
                        showDivider: true,
                        onTap: () async {
                          await NotificationService.showTestNotification();
                          _showSettingsSnackBar(
                              AppStrings.t('testNotificationSent'));
                        },
                      ),
                      _buildSettingTile(
                        isDark: isDark,
                        title: AppStrings.t(AppStrings.helpFeedback),
                        subtitle: AppStrings.t(AppStrings.helpFeedbackSubtitle),
                        icon: Icons.help_outline_rounded,
                        showDivider: true,
                        onTap: _showHelpFeedbackDialog,
                      ),
                      _buildSettingTile(
                        isDark: isDark,
                        title: AppStrings.t(AppStrings.privacyPolicy),
                        subtitle:
                            AppStrings.t(AppStrings.privacyPolicySubtitle),
                        icon: Icons.privacy_tip_outlined,
                        showDivider: true,
                        onTap: () {
                          _showReliabilityInfo(
                            title: AppStrings.t(AppStrings.privacyPolicy),
                            message: AppStrings.t(
                                AppStrings.privacyPolicyInfoMessage),
                          );
                        },
                      ),
                      _buildSettingTile(
                        isDark: isDark,
                        title: AppStrings.t(AppStrings.termsConditions),
                        subtitle:
                            AppStrings.t(AppStrings.termsConditionsSubtitle),
                        icon: Icons.article_outlined,
                        showDivider: true,
                        onTap: () {
                          _showReliabilityInfo(
                            title: AppStrings.t(AppStrings.termsConditions),
                            message: AppStrings.t(
                                AppStrings.termsConditionsInfoMessage),
                          );
                        },
                      ),
                      _buildSettingTile(
                        isDark: isDark,
                        title: AppStrings.t('aboutStayHydro'),
                        subtitle: AppStrings.t('aboutStayHydroSubtitle'),
                        icon: Icons.info_outline_rounded,
                        showDivider: false,
                        onTap: () {
                          _showReliabilityInfo(
                            title: AppStrings.t('aboutStayHydro'),
                            message: AppStrings.t('aboutStayHydroInfoMessage'),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppStrings.t('customReminderTimes'),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? Colors.white
                                        : Colors.blue.shade900,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  AppStrings.t('customReminderTimesHelp'),
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDark
                                        ? Colors.white54
                                        : Colors.blue.shade900.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // RESET BUTTON
                          IconButton(
                            tooltip: AppStrings.t('resetDefaults'),
                            icon: Icon(
                              Icons.restart_alt_rounded,
                              color: Colors.blue.shade400,
                            ),
                            onPressed: () async {
                              final bool? confirmed = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: isDark
                                      ? const Color(0xFF1A1C1E)
                                      : Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  title: Row(
                                    children: [
                                      Icon(
                                        Icons.restart_alt_rounded,
                                        color: Colors.blue.shade400,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          AppStrings.t('resetSchedule'),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: isDark
                                                ? Colors.white
                                                : Colors.blue.shade900,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  content: Text(
                                    AppStrings.t('resetScheduleMessage'),
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.white70
                                          : Colors.blue.shade900
                                              .withOpacity(0.75),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: Text(
                                        AppStrings.t('cancel'),
                                        style: TextStyle(
                                          color: isDark
                                              ? Colors.white60
                                              : Colors.blue.shade700,
                                        ),
                                      ),
                                    ),
                                    FilledButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: Text(AppStrings.t('reset')),
                                    ),
                                  ],
                                ),
                              );

                              if (confirmed != true) return;

                              setSheetState(() {
                                _customReminderSlots =
                                    _defaultCustomReminderSlots();
                              });

                              if (mounted) {
                                setState(() {});
                              }

                              await _saveCustomReminderTimes();
                              await _rescheduleActiveReminderSystem();
                            },
                          ),

                          // ADD BUTTON
                          IconButton(
                            tooltip: AppStrings.t('addReminder'),
                            icon: Icon(
                              Icons.add_circle_rounded,
                              color: Colors.blue.shade400,
                            ),
                            onPressed: () async {
                              if (_customReminderSlots.length >= 20) {
                                _showReliabilityInfo(
                                  title: AppStrings.t('maximumReached'),
                                  message:
                                      AppStrings.t('maxCustomReminderMessage'),
                                );
                                return;
                              }

                              final picked = await _showStayHydroTimePicker(
                                initialTime:
                                    const TimeOfDay(hour: 12, minute: 0),
                              );

                              if (picked == null) return;

                              setSheetState(() {
                                _customReminderSlots.add({
                                  'hour': picked.hour,
                                  'minute': picked.minute,
                                  'enabled': true,
                                });

                                _sortCustomReminderSlots();
                              });

                              if (mounted) {
                                setState(() {});
                              }

                              await _saveCustomReminderTimes();
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: _customReminderSlots.isEmpty
                          ? Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 28),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.edit_calendar_rounded,
                                      size: 42,
                                      color: isDark
                                          ? Colors.white30
                                          : Colors.blue.shade200,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      AppStrings.t('noCustomRemindersYet'),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: isDark
                                            ? Colors.white70
                                            : Colors.blue.shade900,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      AppStrings.t('addCustomReminderHint'),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: isDark
                                            ? Colors.white54
                                            : Colors.blue.shade900
                                                .withOpacity(0.6),
                                      ),
                                    ),
                                  ],
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

                                return Opacity(
                                  opacity: enabled ? 1.0 : 0.55,
                                  child: ListTile(
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
                                          ? AppStrings.t(
                                              'customHydrationReminder')
                                          : AppStrings.t('disabled'),
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.white54
                                            : Colors.blue.shade900
                                                .withOpacity(0.6),
                                      ),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.remove_circle_outline_rounded,
                                            color: Colors.redAccent
                                                .withOpacity(0.82),
                                          ),
                                          onPressed: () async {
                                            final bool? confirmed =
                                                await showDialog<bool>(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  backgroundColor: isDark
                                                      ? const Color(0xFF1A1C1E)
                                                      : Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18),
                                                  ),
                                                  title: Row(
                                                    children: [
                                                      const Icon(
                                                        Icons
                                                            .warning_amber_rounded,
                                                        color: Colors.redAccent,
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Expanded(
                                                        child: Text(
                                                          AppStrings.t(
                                                              'deleteReminder'),
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            color: isDark
                                                                ? Colors.white
                                                                : Colors.blue
                                                                    .shade900,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  content: Text(
                                                    AppStrings.t(
                                                        'deleteReminderMessage'),
                                                    style: TextStyle(
                                                      color: isDark
                                                          ? Colors.white70
                                                          : Colors.blue.shade900
                                                              .withOpacity(
                                                                  0.75),
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context, false),
                                                      child: Text(
                                                        AppStrings.t('cancel'),
                                                        style: TextStyle(
                                                          color: isDark
                                                              ? Colors.white60
                                                              : Colors.blue
                                                                  .shade700,
                                                        ),
                                                      ),
                                                    ),
                                                    FilledButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context, true),
                                                      style: FilledButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.redAccent,
                                                      ),
                                                      child: Text(AppStrings.t(
                                                          'delete')),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );

                                            if (confirmed != true) return;

                                            setSheetState(() {
                                              _customReminderSlots
                                                  .removeAt(index);
                                            });

                                            if (mounted) {
                                              setState(() {});
                                            }

                                            await _saveCustomReminderTimes();

                                            await NotificationService
                                                .scheduleCustomReminders(
                                              _customReminderSlots,
                                            );
                                          },
                                        ),
                                        Switch(
                                          value: enabled,
                                          activeColor: Colors.blue.shade400,
                                          onChanged: (value) async {
                                            setSheetState(() {
                                              _customReminderSlots[index]
                                                  ['enabled'] = value;
                                            });

                                            if (mounted) {
                                              setState(() {});
                                            }

                                            await _saveCustomReminderTimes();

                                            await _rescheduleActiveReminderSystem();
                                          },
                                        ),
                                      ],
                                    ),
                                    onTap: () async {
                                      final picked =
                                          await _showStayHydroTimePicker(
                                        initialTime: TimeOfDay(
                                            hour: hour, minute: minute),
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
                                      await _rescheduleActiveReminderSystem();
                                    },
                                  ),
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
    final currentMsg = _specialMessages[index].trim();
    final editorText = currentMsg.isEmpty ||
            currentMsg ==
                "${AppStrings.specialReminderFallback} ${index + 1}" ||
            currentMsg == AppStrings.specialReminder
        ? ""
        : currentMsg;

    TextEditingController msgController =
        TextEditingController(text: editorText);
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
                  Text(_specialFallbackTitle(index),
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
                title: Text(AppStrings.t('selectTime')),
                trailing: Text(_formatTime(tempHour, tempMinute),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                onTap: () async {
                  final TimeOfDay? picked = await _showStayHydroTimePicker(
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
                  labelText: AppStrings.t(AppStrings.reminderMessage),
                  prefixIcon: const Icon(Icons.edit_note_rounded),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),

              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppStrings.t(AppStrings.usesCurrentSoundMode),
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? Colors.white54
                        : Colors.blue.shade900.withOpacity(0.65),
                  ),
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
                  child: Text(AppStrings.t('saveReminder'),
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
    if (_isCustomSchedule) {
      await NotificationService.scheduleCustomReminders(_customReminderSlots);
    } else {
      await NotificationService.scheduleHourlyReminder();
    }
  }

// ==========================================
// [FUNCTION: SHOW LANGUAGE PICKER] (Updated Phase 10.3BL)
// اردو کمنٹ: زبان منتخب کرنے اور فوری فیڈ بیک دینے کا فنکشن
// ==========================================

  void _showLanguagePicker() {
    final languages = [
      'English',
      'Spanish',
      'Arabic',
      'Hindi',
      'Indonesian',
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
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(
                AppStrings.t('appLanguage'),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _darkTheme ? Colors.white : Colors.blue.shade900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                AppStrings.t('fullTranslationsBeforeRelease'),
                style: TextStyle(
                  fontSize: 13,
                  color: _darkTheme
                      ? Colors.white54
                      : Colors.blue.shade900.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 10),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // یہاں صرف languages.map والا حصہ رکھو
                      ...languages.map(
                        (language) => ListTile(
                          leading: Icon(
                            Icons.language_rounded,
                            color: _selectedLanguage == language
                                ? Colors.blue.shade400
                                : Colors.grey,
                          ),
                          title: Text(
                            _languageNativeName(language),
                            style: TextStyle(
                              color: _darkTheme ? Colors.white : Colors.black87,
                            ),
                          ),
                          subtitle: language == _selectedLanguage
                              ? Text(AppStrings.t('currentlyActive'))
                              : null,
                          trailing: _selectedLanguage == language
                              ? Icon(Icons.check_circle,
                                  color: Colors.blue.shade400)
                              : null,
                          onTap: () async {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setString(_languageKey, language);

                            if (!mounted) return;
                            setState(() {
                              _selectedLanguage = language;
                              AppStrings.setLanguage(language);
                            });

                            widget.onLanguageChanged(language);

                            if (context.mounted) Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }

// ==========================================
// [FUNCTION: SHOW MODE PICKER] (Updated Phase 10.4)
// اردو کمنٹ: ریمائنڈر کے طریقے منتخب کرنے اور فوری فیڈ بیک دینے کا فنکشن
// ==========================================
  void _showModePicker(BuildContext context, bool isDark) {
    final List<String> modes = [
      'sound_vibrate',
      'sound_only',
      'vibrate_only',
      'silent',
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
              Text(AppStrings.t('selectReminderMode'),
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87)),
              const SizedBox(height: 10),
              ...modes
                  .map((mode) => ListTile(
                        leading: Icon(
                          mode == 'silent'
                              ? Icons.notifications_off_rounded
                              : Icons.notifications_active_rounded,
                          color: _currentMode == mode
                              ? Colors.blue.shade400
                              : Colors.grey,
                        ),
                        title: Text(_modeDisplayName(mode),
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

                          if (context.mounted) {
                            Navigator.pop(context);
                          }

                          Future.delayed(
                            const Duration(milliseconds: 100),
                            () {
                              if (mounted) {
                                setState(() {});
                              }
                            },
                          );
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
              Text(AppStrings.t('selectNotificationSound'),
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
                        title: Text(_soundDisplayName(entry.key),
                            style: TextStyle(
                                color: isDark ? Colors.white : Colors.black87)),
                        trailing: _selectedSoundKey == entry.key
                            ? Icon(Icons.check_circle,
                                color: Colors.blue.shade400)
                            : null,
                        onTap: () async {
                          setState(() {
                            _selectedSoundKey = entry.key;
                            _selectedSoundName = _soundDisplayName(entry.key);
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

                          if (context.mounted) {
                            Navigator.pop(context);
                          }

                          Future.delayed(
                            const Duration(milliseconds: 100),
                            () {
                              if (mounted) {
                                setState(() {});
                              }
                            },
                          );
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
// Settings info dialogs کے لیے RTL/LTR alignment support
// Arabic میں title/message/buttons دائیں سے درست align ہوں گے
// ==========================================
  void _showReliabilityInfo({
    required String title,
    required String message,
  }) {
    final bool isRtl = AppStrings.isArabic;

    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        child: AlertDialog(
          title: Text(
            title,
            textAlign: isRtl ? TextAlign.right : TextAlign.left,
          ),
          content: Text(
            message,
            textAlign: isRtl ? TextAlign.right : TextAlign.left,
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          ),
          actionsAlignment:
              isRtl ? MainAxisAlignment.start : MainAxisAlignment.end,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppStrings.t('gotIt')),
            ),
          ],
        ),
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
