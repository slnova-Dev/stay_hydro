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
  // SECTION LOCK: CORE STATE & GOALS
  // ==========================================
  int currentIntake = 0;
  final int dailyGoal = 2000;
  int selectedIntake = 200;
  int streakDays = 0;
  bool _reminderScheduled = false;
  DateTime? _nextReminderTime;
  Timer? _reminderRefreshTimer;
  bool _justDrank = false;

  int _sleepStartHour = 23;
  int _sleepStartMinute = 0;
  int _sleepEndHour = 7;
  int _sleepEndMinute = 0;
  // ==========================================

  late AnimationController _buttonController;
  late AnimationController _bellController;
  late AnimationController _switchBtnController;
  late AnimationController _missedBtnController;

  final List<Widget> _risingAnimations = [];

  // ==========================================
  // SECTION LOCK: DAILY TIPS CONTENT
  // ==========================================
  static const List<String> _dailyWaterTips = [
    'Drink water right after you wake up.',
    'Sip water slowly instead of chugging.',
    'Keep a bottle within arm’s reach.',
    'Drink a glass before each meal.',
    'Add lemon slices for fresh flavor.',
    'Set simple water checkpoints through the day.',
    'Take a few sips every hour.',
    'Drink water after every bathroom break.',
    'Pair water with your coffee or tea.',
    'Drink before you feel thirsty.',
    'Refill your bottle whenever it’s half empty.',
    'Have water with every snack.',
    'Keep a glass of water on your desk.',
    'Choose water first when you eat out.',
    'Drink a small glass before workouts.',
    'Rehydrate after exercise right away.',
    'Add cucumber for a crisp taste.',
    'Take a water break between tasks.',
    'Keep chilled and room-temp options ready.',
    'Start meetings with a quick sip.',
    'Drink water after salty foods.',
    'Track your intake to stay motivated.',
    'Take a sip whenever you check your phone.',
    'Drink water before sugary drinks.',
    'Bring water in the car for short trips.',
    'Refill your bottle before leaving home.',
    'Take water breaks during screen time.',
    'Add mint leaves for variety.',
    'Drink a glass while waiting for meals.',
    'Celebrate each time you hit a mini goal.',
    'Keep water by your bedside at night.',
    'Make hydration part of your morning routine.',
    'Proper hydration improves brain focus.',
    'Feeling tired? Try a glass of water first.',
    'Water helps your kidneys clear toxins from your blood.',
    'Drinking water can help prevent headaches caused by dehydration.',
    'Hydration is key for maintaining healthy, glowing skin.',
    'Drinking water boosts your physical performance during exercise.',
    'Water helps maintain normal bowel function and prevents constipation.',
    'Being well-hydrated helps regulate your body temperature.',
    'Drinking water before meals can aid in healthy weight management.',
    'Hydration keeps your joints lubricated and cushioned.',
    'Water is essential for the production of saliva and digestive juices.',
    'Even mild dehydration can drain your energy and make you tired.',
    'Drinking enough water helps your heart pump blood more easily.',
    'Hydration supports the health of your mucus membranes and lungs.',
    'Water carries nutrients and oxygen to all cells in your body.',
    'A glass of water can help curb late-night snack cravings.',
    'Optimal hydration helps your brain stay alert and focused.',
    'Drinking water helps flush out waste products through sweat and urine.',
  ];

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

  late final String _dailyTip;
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
      final assets = _mascotAssets
          .where((a) => a.contains('/fasting'))
          .toList();
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
      final sleeping = _mascotAssets
          .where((a) => a.contains('/sleeping'))
          .toList();
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
      final thirsty = _mascotAssets
          .where((a) => a.contains('/thirsty'))
          .toList();
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

    final random = Random();
    _dailyTip = _dailyWaterTips[random.nextInt(_dailyWaterTips.length)];
    _currentMascotAsset = _selectMascotAsset();
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
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
    await NotificationService.init();
    await _checkAndScheduleOnFirstRun();
    await _refreshNextReminderTime();
  }

  Future<void> _checkAndScheduleOnFirstRun() async {
    try {
      if (widget.isFastingMode) return;
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool('hourly_scheduled') ?? false) return;
      await prefs.setInt('interval_minutes', 60);
      await NotificationService.scheduleHourlyReminder();
      _reminderScheduled = true;
    } catch (_) {}
  }

  Future<void> _setupReminder() async {
    if (!widget.isFastingMode && !_reminderScheduled) {
      await NotificationService.scheduleHourlyReminder();
      _reminderScheduled = true;
      await _refreshNextReminderTime();
    }
  }

  Future<void> _refreshNextReminderTime() async {
    DateTime? updatedTime;
    if (!widget.isFastingMode) {
      updatedTime = await NotificationService.getNextScheduledReminderTime();
    }
    if (!mounted) return;
    setState(() {
      _nextReminderTime = updatedTime;
      _currentMascotAsset = _selectMascotAsset();
    });
  }

  double _getReminderProgress() {
    if (_nextReminderTime == null) return 0.0;
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
        NotificationService.cancelAll();
        _reminderScheduled = false;
        _refreshNextReminderTime();
      } else {
        _setupReminder();
        _refreshNextReminderTime();
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
  // ==========================================
  void _triggerRisingEffect() {
    setState(() {
      _risingAnimations.add(_buildRisingText());
    });
    Timer(const Duration(seconds: 2), () {
      if (mounted && _risingAnimations.isNotEmpty) {
        setState(() {
          _risingAnimations.removeAt(0);
        });
      }
    });
  }

  Widget _buildRisingText() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(seconds: 2),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Positioned(
          bottom: 100 + (value * 120),
          child: Opacity(
            opacity: (1.0 - value).clamp(0.0, 1.0),
            child: Text(
              "+$selectedIntake ml",
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
  // ==========================================
  Future<void> addWater() async {
    final int prev = currentIntake;
    _triggerRisingEffect();

    // موجودہ وقت کو "10:30 AM" کی شکل میں حاصل کرنا
    String currentTime = DateFormat('hh:mm a').format(DateTime.now());

    // اب ہم مقدار کے ساتھ وقت بھی ہسٹری میں بھیج رہے ہیں
    await HistoryService.addToHistory(selectedIntake, currentTime);

    setState(() {
      currentIntake += selectedIntake;
      _justDrank = true;
      _currentMascotAsset = _selectMascotAsset();
    });

    Timer(const Duration(minutes: 10), () {
      if (mounted) {
        setState(() {
          _justDrank = false;
          _currentMascotAsset = _selectMascotAsset();
        });
      }
    });

    await SoundService.playWaterSound();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentIntake', currentIntake);

    if (prev < dailyGoal && currentIntake >= dailyGoal) {
      await StreakService.markGoalCompleted();
      await _loadStreak();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("🎉 Goal completed! Streak: $streakDays days")),
      );
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
      final String time = result['time'] ?? DateFormat('hh:mm a').format(DateTime.now()); // اگر وقت ملے ورنہ موجودہ وقت
      final int prev = currentIntake;

      // مسڈ انٹری کو بھی ہسٹری میں وقت کے ساتھ شامل کرنا
      await HistoryService.addToHistory(amount, time);

      setState(() {
        currentIntake += amount;
      });

      await SoundService.playWaterSound();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('currentIntake', currentIntake);

      if (prev < dailyGoal && currentIntake >= dailyGoal) {
        await StreakService.markGoalCompleted();
        await _loadStreak();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "🎉 Goal completed with missed entry! Streak: $streakDays days",
            ),
          ),
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

  // ==========================================
  // SECTION LOCK: MAIN BUILD METHOD
  // ==========================================
  @override
  Widget build(BuildContext context) {
    final bool isDark = widget.isDarkTheme;
    final bool hasReminder = _nextReminderTime != null;
    final String timeStr = hasReminder
        ? MaterialLocalizations.of(
            context,
          ).formatTimeOfDay(TimeOfDay.fromDateTime(_nextReminderTime!))
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
                        child: Row(
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500),
                              child: SvgPicture.asset(
                                _currentMascotAsset ??
                                    'assets/mascots/welcome1.svg',
                                key: ValueKey(_currentMascotAsset),
                                width: 55,
                                height: 65,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Daily Hydration Tip",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isDark
                                          ? Colors.cyan.shade300
                                          : Colors.blue.shade500,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _dailyTip,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: isDark
                                          ? Colors.white70
                                          : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
                                    "Next Hydration Goal",
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
                                  widget.isFastingMode ? "Paused" : timeStr,
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
                                    "$streakDays days",
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
                                  right: 35,
                                  bottom: 15,
                                ),
                                child: Text(
                                  "Add $selectedIntake ml",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17.5,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
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
                                label: "Switch Intake",
                                icon: Icons.local_drink_rounded,
                                controller: _switchBtnController,
                                onTap: _openIntakeDialog,
                                isDark: isDark,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: _buildCapsuleButton(
                                label: "Missed Entry",
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
