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
  // [BLOCK: SPECIAL REMINDERS VARIABLES]
  // اسپیشل ریمائنڈرز کا ڈیٹا (آن/آف، ٹائم، اور میسج)
  // ==========================================
  // ہم 3 سلاٹس کے لیے لسٹ استعمال کر رہے ہیں (انڈیکس 0 سے 2 تک)
  List<bool> _specialEnabled = [false, false, false];
  List<int> _specialHours = [0, 0, 0];
  List<int> _specialMinutes = [0, 0, 0];
  List<String> _specialMessages = ["Special 1", "Special 2", "Special 3"];

  // ==========================================
  // [BLOCK: STATE VARIABLES & KEYS] (Updated)
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
    _loadSpecialReminders(); // اسپیشل ریمائنڈرز لوڈ کرنے کا فنکشن
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
        _specialMessages[i] = prefs.getString('special_${id}_msg') ?? "Special ${i + 1}";
      }
    });
  }

  // ==========================================
  // [BLOCK: DATA LOADING LOGIC]
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

  // ==========================================
  // [BLOCK: STORAGE & ACTIONS LOGIC]
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

// ==========================================
  // [BLOCK: SAVE SPECIAL REMINDER]
  // اسپیشل ریمائنڈر کو میموری میں محفوظ کرنا اور شیڈول کرنا
  // ==========================================
  Future<void> _saveSpecialReminder(int index, bool enabled, int h, int m, String msg) async {
    final prefs = await SharedPreferences.getInstance();
    int id = 201 + index; // IDs: 201, 202, 203

    // ڈیٹا کو لوکل سٹوریج میں محفوظ کرنا
    await prefs.setBool('special_${id}_enabled', enabled);
    await prefs.setInt('special_${id}_hour', h);
    await prefs.setInt('special_${id}_min', m);
    await prefs.setString('special_${id}_msg', msg);

    // اگر آن ہے تو نوٹیفیکیشن سروس میں شیڈول کرنا، ورنہ کینسل کرنا
    if (enabled) {
      await NotificationService.scheduleSpecialReminder(id, h, m, msg);
    } else {
      await NotificationService.cancelNotification(id);
    }

    _loadSpecialReminders(); // UI کو اپ ڈیٹ کرنے کے لیے دوبارہ لوڈ کریں
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
              color: isDark 
                  ? Colors.white
                  : Colors.blue.shade900,
            ),
          ), // یہاں Opacity کی بریکٹ بند ہوئی
        ), // یہاں Positioned کی بریکٹ بند ہوئی

// اصلی کانٹینٹ
          SingleChildScrollView(
            key: UniqueKey(), 
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 120, bottom: 100, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                // ==========================================
                // [SECTION 1: APPEARANCE & LOOK]
                // اردو کمنٹ: ایپ کی ظاہری شکل اور تھیم کی سیٹنگز
                // ==========================================
                _buildSectionTitle("Appearance", isDark),
                _buildGroupContainer(
                  isDark: isDark,
                  children: [
                    _buildSettingTile(
                      isDark: isDark,
                      title: "Dark Theme",
                      icon: Icons.dark_mode_rounded,
                      showDivider: false,
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
                // [SECTION 2: NOTIFICATION CENTER]
                // اردو کمنٹ: یہاں ریمائنڈرز کے بنیادی طریقے (موڈ) اور ساؤنڈز کی سیٹنگ ہے
                // ==========================================
                _buildSectionTitle("Notification Center", isDark),
                _buildGroupContainer(
                  isDark: isDark,
                  children: [
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
                      showDivider: false,
                      onTap: _openSoundSelector,
                    ),
                    // نوٹ: یہاں فیز 11 میں "Custom vs Hourly" کا سلیکٹر شامل کریں گے
                  ],
                ),

                // ==========================================
                // [SECTION 3: SPECIAL REMINDERS] (Phase 10.2)
                // اردو کمنٹ: یہ ریمائنڈرز فاسٹنگ موڈ میں بھی کام کریں گے
                // ==========================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSectionTitle("Special Reminders", isDark),
                    IconButton(
                      icon: Icon(Icons.info_outline_rounded, 
                        size: 18, color: isDark ? Colors.white30 : Colors.blue.shade200),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Special reminders remain active even during Fasting Mode."),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  ],
                ),

// ⭐ یہ وہ 3 لائنیں ہیں جو مِس ہو گئی تھیں
                _buildGroupContainer(
                  isDark: isDark,
                  children: [
// [CARD: SPECIAL 1]
// اردو کمنٹ: پہلا اسپیشل ریمائڈر - ڈیٹا لوڈ کرنے اور ایڈٹ کرنے کی صلاحیت کے ساتھ

_buildSettingTile(
  isDark: isDark,
  // اگر یوزر نے نام بدلا ہے تو وہ دکھائے گا، ورنہ ڈیفالٹ "Special 1"
  title: _specialMessages[0], 
  // اگر آن ہے تو وقت دکھائے گا، ورنہ "Off" لکھا آئے گا
  subtitle: _specialEnabled[0] 
      ? "Active at ${_formatTime(_specialHours[0], _specialMinutes[0])}" 
      : "Off",
  // اگر آن ہے تو بھرا ہوا ستارہ (star)، ورنہ صرف آؤٹ لائن والا ستارہ
  icon: _specialEnabled[0] ? Icons.star_rounded : Icons.star_outline_rounded,
  showDivider: true,
  // کلک کرنے پر باٹم شیٹ کھولے گا اور انڈیکس 0 (پہلا کارڈ) پاس کرے گا
  onTap: () => _showSpecialEditor(0), 
),

// [CARD: SPECIAL 2]
// اردو کمنٹ: دوسرا اسپیشل ریمائڈر - ڈیٹا لوڈ کرنے اور ایڈٹ کرنے کی صلاحیت کے ساتھ
_buildSettingTile(
  isDark: isDark,
  // اگر یوزر نے نام بدلا ہے تو وہ دکھائے گا، ورنہ ڈیفالٹ "Special 2"
  title: _specialMessages[1], 
  // اگر آن ہے تو وقت دکھائے گا، ورنہ "Off" لکھا آئے گا
  subtitle: _specialEnabled[1] 
      ? "Active at ${_formatTime(_specialHours[1], _specialMinutes[1])}" 
      : "Off",
  // اگر آن ہے تو بھرا ہوا ستارہ (star)، ورنہ صرف آؤٹ لائن والا ستارہ
  icon: _specialEnabled[1] ? Icons.star_rounded : Icons.star_outline_rounded,
  showDivider: true,
  // کلک کرنے پر باٹم شیٹ کھولے گا اور انڈیکس 1 (دوسرا کارڈ) پاس کرے گا
  onTap: () => _showSpecialEditor(1), 
),

// [CARD: SPECIAL 3]
// اردو کمنٹ: تیسرا اسپیشل ریمائڈر - ڈیٹا لوڈ کرنے اور ایڈٹ کرنے کی صلاحیت کے ساتھ

_buildSettingTile(
  isDark: isDark,
  // اگر یوزر نے نام بدلا ہے تو وہ دکھائے گا، ورنہ ڈیفالٹ "Special 3"
  title: _specialMessages[2], 
  // اگر آن ہے تو وقت دکھائے گا، ورنہ "Off" لکھا آئے گا
  subtitle: _specialEnabled[2] 
      ? "Active at ${_formatTime(_specialHours[2], _specialMinutes[2])}" 
      : "Off",
  // اگر آن ہے تو بھرا ہوا ستارہ (star)، ورنہ صرف آؤٹ لائن والا ستارہ
  icon: _specialEnabled[2] ? Icons.star_rounded : Icons.star_outline_rounded,
  showDivider: false,
  // کلک کرنے پر باٹم شیٹ کھولے گا اور انڈیکس 2 (تیسرا کارڈ) پاس کرے گا
  onTap: () => _showSpecialEditor(2), 
),
], // یہ پہلی بند ہونے والی بریکٹ (children کی ہے)
                ), // یہ دوسری بند ہونے والی بریکٹ (_buildGroupContainer کی ہے)

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
                        initialMinute: _sleepStartMinute,
                      ),
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
                        initialMinute: _sleepEndMinute,
                      ),
                    ),
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
                            backgroundColor: isDark ? Colors.blueGrey[800] : Colors.blue[600],
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
  // [BLOCK: SPECIAL REMINDER EDITOR]
  // اسپیشل ریمائنڈر کو ایڈٹ کرنے والی باٹم شیٹ
  // ==========================================
  void _showSpecialEditor(int index) {
    final bool isDark = _darkTheme;
    // ٹیکسٹ کنٹرولر تاکہ یوزر کا میسج ایڈٹ ہو سکے
    TextEditingController msgController = TextEditingController(text: _specialMessages[index]);
    int tempHour = _specialHours[index];
    int tempMinute = _specialMinutes[index];
    bool tempEnabled = _specialEnabled[index];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // گلاس مورفزم کے لیے
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 20, top: 20, left: 20, right: 20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // اوپر والی چھوٹی لائن (Handle)
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 20),
              
              // ٹائٹل اور سوئچ
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Edit Special Reminder", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.blue.shade900)),
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                leading: const Icon(Icons.access_time_rounded, color: Colors.blue),
                title: const Text("Select Time"),
                trailing: Text(_formatTime(tempHour, tempMinute), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () {
                    _saveSpecialReminder(index, tempEnabled, tempHour, tempMinute, msgController.text);
                    Navigator.pop(context);
                  },
                  child: const Text("Save Reminder", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
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

  Widget _buildSettingTile({
    required bool isDark,
    required String title,
    String? subtitle,
    required IconData icon,
    Widget? trailing,
    VoidCallback? onTap,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
              fontWeight: FontWeight.bold, // ٹیکسٹ کو تھوڑا مزید گہرا کیا
              color: isDark ? Colors.white : Colors.blue.shade900,
            ),
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle,
                  style: TextStyle(
                    color: isDark ? Colors.white54 : Colors.blue.shade900.withOpacity(0.6),
                    fontSize: 13,
                  ),
                )
              : null,
          trailing: trailing ??
              Icon(
                Icons.chevron_right,
                size: 20,
                color: isDark ? Colors.white30 : Colors.blue.shade200,
              ),
          onTap: onTap,
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.only(left: 56),
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    isDark ? Colors.white10 : Colors.blue.shade100.withOpacity(0.3),
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