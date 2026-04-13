import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/notification_service.dart';

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
  // [BLOCK: STATE VARIABLES & KEYS]
  // تمام متغیرات اور لوکل ڈیٹا کی کیز یہاں محفوظ ہیں
  // ==========================================
  late bool _fasting;
  late bool _darkTheme;
  late int _sleepStartHour;
  late int _sleepStartMinute;
  late int _sleepEndHour;
  late int _sleepEndMinute;

  String _selectedSound = 'water_glass';
  static const String _soundPrefKey = 'selected_sound';
  static const String _sleepStartHourKey = 'sleep_start_hour';
  static const String _sleepStartMinuteKey = 'sleep_start_minute';
  static const String _sleepEndHourKey = 'sleep_end_hour';
  static const String _sleepEndMinuteKey = 'sleep_end_minute';

  static const Map<String, String> _sounds = {
    'water_glass': 'Water Glass',
    'soft_knock': 'Soft Knock',
    'water_drop': 'Water Drop',
  };
  // [END BLOCK: STATE VARIABLES]

  @override
  void initState() {
    super.initState();
    _fasting = widget.isFastingMode;
    _darkTheme = widget.isDark;
    _sleepStartHour = 23;
    _sleepStartMinute = 0;
    _sleepEndHour = 7;
    _sleepEndMinute = 0;
    _loadSound();
    _loadSleepHours();
  }

  // ==========================================
  // [BLOCK: DATA LOADING LOGIC]
  // شیئرڈ پریفرنسز سے ڈیٹا لوڈ کرنے کے فنکشنز
  // ==========================================
  Future<void> _loadSound() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _selectedSound = prefs.getString(_soundPrefKey) ?? 'water_glass';
    });
  }

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
  // [END BLOCK: DATA LOADING]

  // ==========================================
  // [BLOCK: STORAGE & ACTIONS LOGIC]
  // ڈیٹا محفوظ کرنے اور نوٹیفیکیشن شیڈول کرنے کی لاجک
  // ==========================================
  Future<void> _saveSound(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_soundPrefKey, value);
    await NotificationService.scheduleHourlyReminder();
  }

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
  // [END BLOCK: STORAGE & ACTIONS]

  // ==========================================
  // [BLOCK: UI PICKERS & DIALOGS]
  // ٹائم پیکر اور ساؤنڈ سلیکٹر ڈائیلاگ
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

  void _openSoundSelector() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: widget.isDark ? const Color(0xFF1E293B) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Reminder Sound",
          style: TextStyle(
            color: widget.isDark ? Colors.white : Colors.blue.shade900,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _sounds.entries.map((entry) {
            return RadioListTile<String>(
              activeColor: Colors.blue.shade400,
              title: Text(
                entry.value,
                style: TextStyle(
                  color: widget.isDark ? Colors.white : Colors.black87,
                ),
              ),
              value: entry.key,
              groupValue: _selectedSound,
              onChanged: (value) async {
                if (value == null) return;
                await _saveSound(value);
                await NotificationService.recreateReminderChannel();
                if (!mounted) return;
                setState(() => _selectedSound = value);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
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
  // [END BLOCK: UI PICKERS]

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
      body: Container(
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            top: 110,
            bottom: 20,
            left: 16,
            right: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==========================================
              // [SECTION: APPEARANCE]
              // تھیم اور لک اینڈ فیل کی سیٹنگز
              // ==========================================_buildSectionTitle("Appearance", isDark),
              _buildGroupContainer(
                isDark: isDark,
                children: [
                  _buildSettingTile(
                    isDark: isDark,
                    title: "Dark Theme",
                    icon: Icons.dark_mode_rounded,
                    showDivider:
                        false, // اس گروپ میں ایک ہی بٹن ہے، اس لیے لکیر نہیں چاہیے
                    trailing: Switch(
                      activeColor: Colors.blue.shade400,
                      value: _darkTheme,
                      onChanged: (value) {
                        setState(() => _darkTheme = value);
                        widget.onThemeToggle(value);
                      },
                    ),
                  ),
                ],
              ),

              // ==========================================
              // [SECTION: NOTIFICATIONS]
              // فاسٹنگ موڈ اور ریمائنڈر ساؤنڈ کی سیٹنگز
              // ==========================================_buildSectionTitle("Notifications", isDark),
              _buildGroupContainer(
                isDark: isDark,
                children: [
                  _buildSettingTile(
                    isDark: isDark,
                    title: "Fasting Mode",
                    subtitle: "Pause hydration reminders",
                    icon: Icons.timer_off_rounded,
                    showDivider:
                        true, // اس کے بعد ایک اور بٹن ہے، اس لیے لکیر چاہیے
                    trailing: Switch(
                      activeColor: Colors.blue.shade400,
                      value: _fasting,
                      onChanged: (value) async {
                        setState(() => _fasting = value);
                        widget.onFastingToggle(value);
                        if (value) {
                          await NotificationService.cancelAll();
                        } else {
                          await NotificationService.scheduleHourlyReminder();
                        }
                      },
                    ),
                  ),
                  _buildSettingTile(
                    isDark: isDark,
                    title: "Reminder Sound",
                    subtitle: _sounds[_selectedSound] ?? '',
                    icon: Icons.notifications_active_rounded,
                    showDivider: false, // آخری بٹن پر لکیر ختم
                    onTap: _openSoundSelector,
                  ),
                ],
              ),
              // ==========================================
              // [SECTION: SYSTEM]
              // بیٹری اور آٹو سٹارٹ کی سسٹم لیول سیٹنگز
              // ==========================================_buildSectionTitle("System", isDark),
              _buildGroupContainer(
                isDark: isDark,
                children: [
                  _buildSettingTile(
                    isDark: isDark,
                    title: "Battery Optimization",
                    subtitle: "Essential for on-time alerts",
                    icon: Icons.battery_saver_rounded,
                    showDivider: true,
                    onTap: () async =>
                        await NotificationService.openBatteryOptimizationSettings(),
                  ),
                  _buildSettingTile(
                    isDark: isDark,
                    title: "Enable Auto Start",
                    subtitle: "Keep reminders active after restart",
                    icon: Icons.power_settings_new_rounded,
                    showDivider: false,
                    onTap: () async =>
                        await NotificationService.openAutoStartSettings(),
                  ),
                ],
              ),

              // ==========================================
              // [SECTION: SCHEDULE]
              // سونے اور جاگنے کے اوقات کی سیٹنگز
              // ==========================================_buildSectionTitle("Schedule", isDark),
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
                      initialMinute: _sleepStartMinute,
                    ),
                  ),
                  _buildSettingTile(
                    isDark: isDark,
                    title: "Sleep End Hour",
                    subtitle: _formatTime(_sleepEndHour, _sleepEndMinute),
                    icon: Icons.wb_sunny_rounded,
                    showDivider: false,
                    onTap: () => _selectSleepHour(
                      isStartHour: false,
                      initialHour: _sleepEndHour,
                      initialMinute: _sleepEndMinute,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // [BLOCK: UI HELPER WIDGETS]
  // سیٹنگز کے ٹائٹلز، گروپ کارڈز اور بٹنز کے وزٹس
  // ==========================================

  // سیکشن کا عنوان (مثلاً APPEARANCE)
  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 8, top: 10),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: isDark ? Colors.blue.shade300 : Colors.blue.shade700,
        ),
      ),
    );
  }

  // پورے سیکشن کو ایک کارڈ میں بند کرنے والا کنٹینر
  Widget _buildGroupContainer({
    required List<Widget> children,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.blue.shade50,
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.blue.shade100.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(children: children),
    );
  }

  // انفرادی سیٹنگ بٹن (اب یہ خود کارڈ نہیں بلکہ لسٹ ٹائل ہے)
  Widget _buildSettingTile({
    required bool isDark,
    required String title,
    String? subtitle,
    required IconData icon,
    Widget? trailing,
    VoidCallback? onTap,
    bool showDivider = true, // ڈیوائڈر دکھانے کے لیے
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
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
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.blue.shade900,
            ),
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle,
                  style: TextStyle(
                    color: isDark ? Colors.white54 : Colors.black54,
                    fontSize: 13,
                  ),
                )
              : null,
          trailing:
              trailing ??
              Icon(
                Icons.chevron_right,
                size: 20,
                color: isDark ? Colors.white30 : Colors.blue.shade200,
              ),
          onTap: onTap,
        ),
        // وہ خاص گریڈینٹ ڈیوائڈر جو آئیکن کے بعد سے شروع ہوتا ہے
        if (showDivider)
          Padding(
            padding: const EdgeInsets.only(left: 56), // آئیکن کی جگہ چھوڑ کر
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    isDark ? Colors.white10 : Colors.blue.shade50,
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
