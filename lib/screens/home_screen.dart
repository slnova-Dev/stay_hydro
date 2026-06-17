import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/water_goal_widget.dart';
import '../widgets/intake_selector_dialog.dart';
import '../widgets/missed_entry_dialog.dart';
import '../services/notification_service.dart';
import '../services/sound_service.dart';
import '../services/streak_service.dart';
import 'package:stay_hydro/services/history_service.dart';
import 'package:stay_hydro/core/app_strings.dart';

class HomeScreen extends StatefulWidget {
  final bool isDarkTheme;
  final Function(bool) onThemeToggle;
  final bool isFastingMode;
  final Function(bool) onFastingToggle;

  const HomeScreen({
    super.key,
    required this.isDarkTheme,
    required this.onThemeToggle,
    required this.isFastingMode,
    required this.onFastingToggle,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  // ==========================================
  // SECTION LOCK: CORE STATE VARIABLES & GOALS
  // ==========================================
  int currentIntake = 0;
  int dailyGoal = 2000;
  static const String _dailyGoalKey = 'daily_goal';
  static const String _reminderSystemKey = 'reminder_system_mode';
  static const String _customReminderTimesKey = 'custom_reminder_times';
  int selectedIntake = 200;
  int streakDays = 0;
  bool _reminderScheduled = false;
  DateTime? _nextReminderTime;
  Timer? _reminderRefreshTimer;
  bool _justDrank = false;
  bool _isAddingWater = false;
  DateTime _lastTipChangeTime = DateTime.now();

  int _sleepStartHour = 23;
  int _sleepStartMinute = 0;
  int _sleepEndHour = 7;
  int _sleepEndMinute = 0;
  static const int _maxDailyIntake = 5000;
  // ==========================================

  late AnimationController _buttonController;
  late AnimationController _bellController;
  late AnimationController _switchBtnController;
  late AnimationController _missedBtnController;

  final List<Widget> _risingAnimations = [];

  // ==========================================
  // SECTION LOCK: DAILY TIPS CONTENT
  // ==========================================
  // یہ ٹپس app_strings.dart میں dailyTips method کو استعمال کرکے load ہوں گے

  // ==========================================
  // SECTION LOCK: MASCOT ASSETS
  // ==========================================
  static const List<String> _mascotAssets = [
    'assets/mascots/welcome1.svg',
    'assets/mascots/welcome2.svg',
    'assets/mascots/welcome3.svg',
    'assets/mascots/welcome4.svg',
    'assets/mascots/happy1.svg',
    'assets/mascots/happy2.svg',
    'assets/mascots/thinking1.svg',
    'assets/mascots/thinking2.svg',
    'assets/mascots/thirsty1.svg',
    'assets/mascots/thirsty2.svg',
    'assets/mascots/thirsty3.svg',
    'assets/mascots/thirsty4.svg',
    'assets/mascots/cool1.svg',
    'assets/mascots/cool2.svg',
    'assets/mascots/cool3.svg',
    'assets/mascots/cool4.svg',
    'assets/mascots/cool5.svg',
    'assets/mascots/cool6.svg',
    'assets/mascots/sleeping1.svg',
    'assets/mascots/sleeping2.svg',
    'assets/mascots/reminder1.svg',
    'assets/mascots/reminder2.svg',
    'assets/mascots/fasting1.svg',
    'assets/mascots/fasting2.svg',
    'assets/mascots/fasting3.svg',
  ];

  String _dailyTip = '';
  String _lastTipLanguage = '';
  String? _currentMascotAsset;

  // ==========================================
  // SECTION LOCK: LOGIC HELPERS
  // ==========================================
  bool _isCurrentlySleepTime(int startH, int startM, int endH, int endM) {
    final now = DateTime.now();
    final nowMinutes = now.hour * 60 + now.minute;
    final startMinutes = startH * 60 + startM;
    final endMinutes = endH * 60 + endM;
    if (startMinutes < endMinutes) {
      return nowMinutes >= startMinutes && nowMinutes < endMinutes;
    } else {
      return nowMinutes >= startMinutes || nowMinutes < endMinutes;
    }
  }

  String _selectMascotAsset() {
    final random = Random();
    if (widget.isFastingMode) {
      final assets =
          _mascotAssets.where((a) => a.contains('/fasting')).toList();
      return assets.isNotEmpty
          ? assets[random.nextInt(assets.length)]
          : _mascotAssets[0];
    }
    final happyAssets = _mascotAssets
        .where((a) => a.contains('/happy') || a.contains('/welcome'))
        .toList();
    if (_justDrank && happyAssets.isNotEmpty) {
      return happyAssets[random.nextInt(happyAssets.length)];
    }
    if (_isCurrentlySleepTime(
      _sleepStartHour,
      _sleepStartMinute,
      _sleepEndHour,
      _sleepEndMinute,
    )) {
      final sleeping =
          _mascotAssets.where((a) => a.contains('/sleeping')).toList();
      if (sleeping.isNotEmpty) return sleeping[random.nextInt(sleeping.length)];
    }
    if (currentIntake >= dailyGoal && happyAssets.isNotEmpty) {
      return happyAssets[random.nextInt(happyAssets.length)];
    }
    final now = DateTime.now();
    final isReminderOverdue =
        _nextReminderTime != null && _nextReminderTime!.isBefore(now);
    final isVeryLow = currentIntake < (dailyGoal ~/ 4);
    if ((isVeryLow || isReminderOverdue) && !_justDrank) {
      final thirsty =
          _mascotAssets.where((a) => a.contains('/thirsty')).toList();
      return thirsty.isNotEmpty
          ? thirsty[random.nextInt(thirsty.length)]
          : _mascotAssets[0];
    }
    final cool = _mascotAssets
        .where((a) => a.contains('/cool') || a.contains('/thinking'))
        .toList();
    return cool.isNotEmpty
        ? cool[random.nextInt(cool.length)]
        : _mascotAssets[0];
  }

// ==========================================
// SECTION LOCK: DAILY TIPS & MASCOT Refresh Timer Guard Helper
// ڈیلی ٹِپ میسکوٹ اور میسج کم از کم 10 سیکنڈز بعد ری فریش کرنے کا ہیلپر
// ==========================================
  void _refreshTipAndMascot({bool force = false}) {
    final now = DateTime.now();

    if (!force && now.difference(_lastTipChangeTime).inSeconds < 10) {
      return;
    }

    _setRandomDailyTip();
    _currentMascotAsset = _selectMascotAsset();
    _lastTipChangeTime = now;
  }

// ==========================================
// SECTION LOCK: DAILY TIPS Language Change Check Helper
// ==========================================
  void _setRandomDailyTip() {
    final tips = AppStrings.dailyTips();
    final random = Random();

    _dailyTip = tips[random.nextInt(tips.length)];
    _lastTipLanguage = AppStrings.activeLanguage;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.92,
      upperBound: 1.0,
      value: 1.0,
    );
    _bellController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
    _switchBtnController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.95,
      upperBound: 1.0,
      value: 1.0,
    );
    _missedBtnController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.95,
      upperBound: 1.0,
      value: 1.0,
    );

    _setRandomDailyTip();
    _currentMascotAsset = _selectMascotAsset();
    _loadDailyGoal();
    _loadDailyState();
    _loadSelectedIntake();
    _loadStreak();
    _loadSleepHours();
    _startupSequence();
    _startReminderRefreshTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _reminderRefreshTimer?.cancel();
    _buttonController.dispose();
    _bellController.dispose();
    _switchBtnController.dispose();
    _missedBtnController.dispose();
    super.dispose();
  }

  DateTime? _nextCustomReminderTime(String raw) {
    final now = DateTime.now();
    final candidates = <DateTime>[];

    for (final part in raw.split(',')) {
      final pieces = part.split(':');
      if (pieces.length < 2) continue;

      final hour = int.tryParse(pieces[0]);
      final minute = int.tryParse(pieces[1]);
      final enabled = pieces.length >= 3 ? pieces[2] == '1' : true;

      if (hour == null || minute == null || !enabled) continue;

      var dt = DateTime(now.year, now.month, now.day, hour, minute);
      if (!dt.isAfter(now)) {
        dt = dt.add(const Duration(days: 1));
      }

      candidates.add(dt);
    }

    if (candidates.isEmpty) return null;
    candidates.sort();
    return candidates.first;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadDailyGoal();
      _loadSleepHours();
      _refreshNextReminderTime();
    }
  }

  void _startReminderRefreshTimer() {
    _reminderRefreshTimer?.cancel();
    _reminderRefreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _refreshNextReminderTime();
    });
  }

  Future<void> _startupSequence() async {
    await _checkAndScheduleOnFirstRun();
    await _refreshNextReminderTime();
  }

  Future<void> _checkAndScheduleOnFirstRun() async {
    try {
      if (widget.isFastingMode) return;
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool('hourly_scheduled') ?? false) return;
      await prefs.setInt('interval_minutes', 60);
      await NotificationService.restoreActiveReminderSystem();
      _reminderScheduled = true;
    } catch (_) {}
  }

  Future<void> _setupReminder() async {
    if (!widget.isFastingMode && !_reminderScheduled) {
      await NotificationService.restoreActiveReminderSystem();
      _reminderScheduled = true;
      await _refreshNextReminderTime();
    }
  }

  Future<void> _refreshNextReminderTime() async {
    DateTime? updatedTime;

    if (!widget.isFastingMode) {
      final prefs = await SharedPreferences.getInstance();
      final reminderSystem =
          prefs.getString(_reminderSystemKey) ?? 'smart_hourly';

      if (reminderSystem == 'custom_schedule' ||
          reminderSystem == 'Custom Schedule') {
        final raw = prefs.getString(_customReminderTimesKey) ?? "";
        updatedTime = _nextCustomReminderTime(raw);
      } else {
        updatedTime = await NotificationService.getNextScheduledReminderTime();
      }
    }

    if (!mounted) return;
    setState(() {
      _nextReminderTime = updatedTime;
      _refreshTipAndMascot();
    });
  }

  double _getReminderProgress() {
    if (_nextReminderTime == null || widget.isFastingMode) return 0.0;

    final now = DateTime.now();
    final diff = _nextReminderTime!.difference(now).inMinutes;

    if (diff <= 0) return 1.0;

    return (1.0 - (diff / 60.0)).clamp(0.0, 1.0);
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isFastingMode != widget.isFastingMode) {
      if (widget.isFastingMode) {
        NotificationService.cancelRegularReminders();
        _reminderScheduled = false;
        _refreshNextReminderTime();
      } else {
        _setupReminder();
        _refreshNextReminderTime();
        _loadDailyGoal();
      }
    }
  }

  // ==========================================
  // SECTION LOCK: DATA LOADING
  // ==========================================
  Future<void> _loadStreak() async {
    await StreakService.resetStreakIfMissed();
    streakDays = await StreakService.getStreak();
    if (mounted) setState(() {});
  }

  Future<void> _loadDailyState() async {
    final prefs = await SharedPreferences.getInstance();
    final todayKey =
        "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
    if (prefs.getString('lastDate') != todayKey) {
      currentIntake = 0;
      await prefs.setString('lastDate', todayKey);
      await prefs.setInt('currentIntake', 0);
    } else {
      currentIntake = prefs.getInt('currentIntake') ?? 0;
    }
    if (mounted) setState(() {});
  }

  // ==========================================
  // SECTION LOCK: DAILY GOAL LOADING
  // اردو کمنٹ:
  // Settings screen سے محفوظ daily goal کو Home screen پر load کرنا
  // ==========================================
  Future<void> _loadDailyGoal() async {
    final prefs = await SharedPreferences.getInstance();
    dailyGoal = prefs.getInt(_dailyGoalKey) ?? 2000;

    if (mounted) {
      setState(() {
        _currentMascotAsset = _selectMascotAsset();
      });
    }
  }

  Future<void> _loadSelectedIntake() async {
    final prefs = await SharedPreferences.getInstance();
    selectedIntake = prefs.getInt('selectedIntake') ?? 200;
    if (mounted) setState(() {});
  }

  Future<void> _loadSleepHours() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _sleepStartHour = prefs.getInt('sleep_start_hour') ?? 23;
      _sleepStartMinute = prefs.getInt('sleep_start_minute') ?? 0;
      _sleepEndHour = prefs.getInt('sleep_end_hour') ?? 7;
      _sleepEndMinute = prefs.getInt('sleep_end_minute') ?? 0;
    });
  }

  // ==========================================
// SECTION LOCK: UI EFFECTS
// اردو کمنٹ:
// Add Water animation میں اصل add ہونے والی مقدار دکھانا
// تاکہ max daily limit پر partial amount بھی درست نظر آئے
// ==========================================
  void _triggerRisingEffect(int amount) {
    setState(() {
      _risingAnimations.add(_buildRisingText(amount));
    });

    Timer(const Duration(seconds: 2), () {
      if (mounted && _risingAnimations.isNotEmpty) {
        setState(() {
          _risingAnimations.removeAt(0);
        });
      }
    });
  }

  Widget _buildRisingText(int amount) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(seconds: 2),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Positioned(
          bottom: 100 + (value * 120),
          child: Opacity(
            opacity: (1.0 - value).clamp(0.0, 1.0),
            child: Text(
              "+$amount ml",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: widget.isDarkTheme
                    ? Colors.cyanAccent
                    : Colors.blue.shade900,
                shadows: widget.isDarkTheme
                    ? [
                        Shadow(
                          color: Colors.cyanAccent.withOpacity(0.5),
                          blurRadius: 10.0,
                          offset: const Offset(0, 0),
                        ),
                        Shadow(
                          color: Colors.black.withOpacity(0.8),
                          blurRadius: 4.0,
                          offset: const Offset(1, 1),
                        ),
                      ]
                    : null,
              ),
            ),
          ),
        );
      },
    );
  }

  // ==========================================
// SECTION LOCK: CORE ACTIONS
// مرکزی افعال: پانی کا اضافہ اور مسڈ انٹری
// اردو کمنٹ:
// Add Water پر daily intake کو 5000 ml پر cap کیا گیا ہے
// تاکہ accidental rapid taps یا غیر حقیقی daily values سے بچا جا سکے
// ==========================================
  Future<void> addWater() async {
    if (_isAddingWater) return;
    _isAddingWater = true;

    try {
      if (currentIntake >= _maxDailyIntake) {
        if (!mounted) return;
        _showHomeSnackBar(
          AppStrings.t(AppStrings.dailyIntakeLimitReached),
        );
        return;
      }

      final int amountToAdd = (currentIntake + selectedIntake > _maxDailyIntake)
          ? _maxDailyIntake - currentIntake
          : selectedIntake;

      final int prev = currentIntake;
      _triggerRisingEffect(amountToAdd);

      final String currentTime = DateFormat('hh:mm a').format(DateTime.now());

      await HistoryService.addToHistory(amountToAdd, currentTime);

      setState(() {
        currentIntake += amountToAdd;
        _justDrank = true;
        _refreshTipAndMascot(force: true);
      });

      Timer(const Duration(minutes: 10), () {
        if (mounted) {
          setState(() {
            _justDrank = false;
            _currentMascotAsset = _selectMascotAsset();
          });
        }
      });

      await SoundService.playButtonFeedbackSound();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('currentIntake', currentIntake);

      if (prev < dailyGoal && currentIntake >= dailyGoal) {
        await StreakService.markGoalCompleted();
        await _loadStreak();
        if (!mounted) return;
        _showHomeSnackBar(
          "🎉 ${AppStrings.t(AppStrings.goalCompleted)} $streakDays ${AppStrings.t(AppStrings.days)}",
        );
      }
    } finally {
      _isAddingWater = false;
    }
  }

  void _addMissedEntry() async {
    final result = await showGeneralDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) => const MissedEntryDialog(),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(
            scale: Tween<double>(
              begin: 0.9,
              end: 1.0,
            ).animate(CurvedAnimation(parent: anim1, curve: Curves.easeOut)),
            child: child,
          ),
        );
      },
    );

    if (result != null) {
      final int amount = result['amount'];

      if (currentIntake >= _maxDailyIntake) {
        _showHomeSnackBar(
          AppStrings.t(AppStrings.dailyIntakeLimitReached),
        );
        return;
      }

      final int amountToAdd = (currentIntake + amount > _maxDailyIntake)
          ? _maxDailyIntake - currentIntake
          : amount;

      final dynamic rawTime = result['time'];
      final String time = (rawTime is TimeOfDay)
          ? DateFormat('hh:mm a', 'en_US').format(
              DateTime(2026, 1, 1, rawTime.hour, rawTime.minute),
            )
          : rawTime?.toString() ??
              DateFormat('hh:mm a', 'en_US').format(DateTime.now());

      final int prev = currentIntake;

      await HistoryService.addToHistory(amountToAdd, time);

      setState(() {
        currentIntake += amountToAdd;
      });

      await SoundService.playButtonFeedbackSound();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('currentIntake', currentIntake);

      if (prev < dailyGoal && currentIntake >= dailyGoal) {
        await StreakService.markGoalCompleted();
        await _loadStreak();
        if (!mounted) return;
        _showHomeSnackBar(
          "🎉 ${AppStrings.t(AppStrings.goalCompletedMissedEntry)} $streakDays ${AppStrings.t(AppStrings.days)}",
        );
      }
    }
  }

  // ==========================================
  // SECTION LOCK: DIALOGS & INTAKE SELECTION
  // ==========================================
  void _openIntakeDialog() async {
    final result = await showGeneralDialog<int>(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) => IntakeSelectorDialog(
        currentValue: selectedIntake,
        onSelected: (v) {},
      ),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(
            scale: Tween<double>(
              begin: 0.9,
              end: 1.0,
            ).animate(CurvedAnimation(parent: anim1, curve: Curves.easeOut)),
            child: child,
          ),
        );
      },
    );

    if (result != null) {
      selectedIntake = result;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('selectedIntake', result);
      if (mounted) setState(() {});
    }
  }

  // ==========================================
  // SECTION LOCK: UI CUSTOM WIDGETS (CARDS)
  // ==========================================
  Widget _buildStyledCard({required Widget child}) {
    final isDark = widget.isDarkTheme;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF334155)
            : Colors.blue.shade50.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.blue.shade900.withOpacity(0.5)
              : Colors.blue.shade400.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

// Hero button text size helper function
// for Spanish and Indonesian languages

  double _heroButtonFontSize() {
    switch (AppStrings.activeLanguage) {
      case 'Spanish':
        return 14.8;
      case 'Indonesian':
        return 14.0;
      default:
        return 17.5;
    }
  }

// ==========================================
// [HOME SCREEN SNACKBAR HELPER]
// اردو کمنٹ:
// Home screen کے تمام snackbars کے لیے
// Settings screen جیسا unified style
// ==========================================
  void _showHomeSnackBar(String message) {
    if (!mounted) return;

    final bool isDark = widget.isDarkTheme;

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
  // SECTION LOCK: MAIN BUILD METHOD
  // ==========================================
  @override
  Widget build(BuildContext context) {
    final bool isDark = widget.isDarkTheme;
    if (_lastTipLanguage != AppStrings.activeLanguage) {
      _setRandomDailyTip();
    }
    final bool hasReminder = _nextReminderTime != null;
    final String timeStr = hasReminder
        ? DateFormat('h:mm a', 'en_US').format(_nextReminderTime!)
        : "--:--";

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [const Color(0xFF0F172A), const Color(0xFF1E293B)] // ڈارک موڈ
                : [Colors.teal.shade300, Colors.cyan.shade100],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // --- Header ---
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'StayHydro',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),

                      // Mascot & Tips Card
                      _buildStyledCard(
                        child: SizedBox(
                          height: 78,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 68,
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 350),
                                  switchInCurve: Curves.easeOut,
                                  switchOutCurve: Curves.easeIn,
                                  transitionBuilder: (child, animation) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: ScaleTransition(
                                        scale: Tween<double>(
                                          begin: 0.96,
                                          end: 1.0,
                                        ).animate(animation),
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: Transform(
                                    key: ValueKey(_currentMascotAsset),
                                    alignment: Alignment.center,
                                    transform: Matrix4.identity()
                                      ..scale(
                                        Directionality.of(context).name == 'rtl'
                                            ? -1.0
                                            : 1.0,
                                        1.0,
                                      ),
                                    child: SvgPicture.asset(
                                      _currentMascotAsset ??
                                          'assets/mascots/welcome1.svg',
                                      width: 55,
                                      height: 65,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: SizedBox(
                                  height: 65,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppStrings.t(
                                            AppStrings.dailyHydrationTip),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: isDark
                                              ? Colors.cyan.shade300
                                              : Colors.blue.shade500,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      AnimatedSwitcher(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        switchInCurve: Curves.easeOut,
                                        switchOutCurve: Curves.easeIn,
                                        child: Text(
                                          _dailyTip,
                                          key: ValueKey(_dailyTip),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: isDark
                                                ? Colors.white70
                                                : Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

// Reminder Card
                      _buildStyledCard(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                RotationTransition(
                                  turns: Tween(
                                    begin: -0.05,
                                    end: 0.05,
                                  ).animate(_bellController),
                                  child: const Icon(
                                    Icons.notifications_active,
                                    color: Colors.amber,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    AppStrings.t(AppStrings.nextHydrationGoal),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? Colors.cyan.shade300
                                          : Colors.blue.shade500,
                                    ),
                                  ),
                                ),
                                Text(
                                  // فاسٹنگ موڈ آن ہونے پر ٹائم کی جگہ مناسب ٹیکسٹ دکھانے کی لاجک
                                  // _fastingMode کو بدل کر widget.isFastingMode کر دیں
                                  widget.isFastingMode
                                      ? AppStrings.t(AppStrings.paused)
                                      : timeStr,
                                  style: TextStyle(
                                    // اگر ٹیکسٹ بڑا ہو تو سائز خودکار طور پر تھوڑا چھوٹا ہو جائے گا
                                    fontSize: widget.isFastingMode ? 18 : 22,
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? Colors.white
                                        : Colors.blue.shade400,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: _getReminderProgress(),
                                backgroundColor: isDark
                                    ? Colors.white10
                                    : Colors.blue.shade100,
                                color: isDark
                                    ? Colors.cyan.shade400
                                    : Colors.blue.shade400,
                                minHeight: 6,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Water Progress & Animations
                      Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          SizedBox(
                            height: 220,
                            child: Transform.scale(
                              scale: 1.25,
                              child: WaterGoalWidget(
                                currentIntake: currentIntake,
                                goal: dailyGoal,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 40,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF334155)
                                    : Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isDark
                                      ? Colors.cyan.shade300.withOpacity(0.3)
                                      : Colors.blue.shade400.withOpacity(0.4),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Text(
                                    "🔥",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "$streakDays ${AppStrings.t(AppStrings.days)}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: isDark
                                          ? Colors.cyan.shade200
                                          : Colors.blue.shade400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ..._risingAnimations,
                        ],
                      ),

                      const SizedBox(height: 0),

                      // Main Hero Button
                      GestureDetector(
                        onTapDown: (_) => _buttonController.reverse(),
                        onTapUp: (_) {
                          _buttonController.forward();
                          addWater();
                        },
                        onTapCancel: () => _buttonController.forward(),
                        child: ScaleTransition(
                          scale: _buttonController,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SvgPicture.asset(
                                isDark
                                    ? 'assets/buttons/main_hero_button2.svg'
                                    : 'assets/buttons/main_hero_button1.svg',
                                width: 250,
                                height: 80,
                                fit: BoxFit.contain,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 18,
                                  right: 62,
                                  bottom: 15,
                                ),
                                child: SizedBox(
                                  width: 155,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "${AppStrings.t(AppStrings.add)} $selectedIntake ml",
                                      maxLines: 1,
                                      softWrap: false,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: _heroButtonFontSize(),
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Secondary Action Buttons
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildCapsuleButton(
                                label: AppStrings.t(AppStrings.switchIntake),
                                icon: Icons.local_drink_rounded,
                                controller: _switchBtnController,
                                onTap: _openIntakeDialog,
                                isDark: isDark,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: _buildCapsuleButton(
                                label: AppStrings.t(AppStrings.missedEntry),
                                icon: Icons.add_task_rounded,
                                controller: _missedBtnController,
                                onTap: _addMissedEntry,
                                isDark: isDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // SECTION LOCK: REUSABLE COMPONENTS
  // ==========================================
  Widget _buildCapsuleButton({
    required String label,
    required IconData icon,
    required AnimationController controller,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTapDown: (_) => controller.reverse(),
      onTapUp: (_) {
        controller.forward();
        onTap();
      },
      onTapCancel: () => controller.forward(),
      child: ScaleTransition(
        scale: controller,
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            gradient: LinearGradient(
              colors: isDark
                  ? [const Color(0xFF1E293B), const Color(0xFF334155)]
                  : [Colors.blue.shade600, Colors.blue.shade400],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                offset: const Offset(0, 4),
                blurRadius: 4,
              ),
            ],
            border: isDark
                ? Border.all(color: Colors.blue.shade900.withOpacity(0.5))
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
