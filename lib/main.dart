import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stay_hydro/core/app_strings.dart';
import 'package:stay_hydro/services/notification_service.dart';

// ❌ REMOVE: background service imports
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_background_service_android/flutter_background_service_android.dart';

import 'package:stay_hydro/services/sound_service.dart';
import 'screens/main_navigation_screen.dart';
import 'services/notification_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:android_intent_plus/android_intent.dart';

// ==========================================
// سیکشن 1: مین فنکشن اور ایپ کا آغاز
// ==========================================
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // App start/update/reinstall کے بعد enabled special reminders restore کریں
  // ==========================================
// [PHASE 10.8-A: DELAYED STARTUP RESTORE]
// اردو کمنٹ:
// ایپ کی پہلی screen جلدی load کرنے کے لیے reminder restore کو
// تھوڑا delay کیا گیا ہے تاکہ startup پر UI freeze / skipped frames کم ہوں
// ==========================================
  Future.delayed(const Duration(seconds: 2), () async {
    // ✅ نوٹیفیکیشن سروس کافی ہے (background service کی ضرورت نہیں)
    await NotificationService.init();
    await NotificationService.restoreActiveReminderSystem();
  });

  runApp(const StayHydroApp());
}

// ==========================================
// ❌ مکمل background service سیکشن REMOVE کر دیا گیا
// ==========================================

// ==========================================
// سیکشن 2: مین ایپ کلاس
// ==========================================
class StayHydroApp extends StatefulWidget {
  const StayHydroApp({super.key});

  @override
  State<StayHydroApp> createState() => _StayHydroAppState();
}

// ==========================================
// سیکشن 3: ایپ کی اسٹیٹ
// ==========================================
class _StayHydroAppState extends State<StayHydroApp> {
  bool _isDarkTheme = false;
  bool _isFastingMode = false;
  bool _isLoaded = false;

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  static const String _firstLaunchGuideKey =
      'first_launch_reliability_guide_seen';

  static const String _installDateKey = 'install_date';

  static const String _reviewPromptShownKey = 'review_prompt_shown';

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
    _isFastingMode = prefs.getBool('isFastingMode') ?? false;

    final selectedLanguage = prefs.getString('app_language') ?? 'English';
    AppStrings.setLanguage(selectedLanguage);

    if (!mounted) return;

    setState(() {
      _isLoaded = true;
    });

    await _showFirstLaunchGuideIfNeeded();
    await _saveInstallDateIfNeeded();
  }

  Future<void> _toggleTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', value);

    if (!mounted) return;

    setState(() {
      _isDarkTheme = value;
    });
  }

  Future<void> _toggleFasting(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFastingMode', value);

    if (!mounted) return;

    setState(() {
      _isFastingMode = value;
    });

    if (value) {
      await NotificationService.cancelAll();
    }
  }

// ==========================================
// [PHASE 10.6-A16: UPDATE APP LANGUAGE]
// اردو کمنٹ:
// language change پر پوری app / MaterialApp کو rebuild کرنے کے لیے
// تاکہ Time Picker, RTL/LTR اور Bottom Navigation فوراً update ہوں
// ==========================================
  Future<void> _updateLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_language', language);

    if (!mounted) return;

    setState(() {
      AppStrings.setLanguage(language);
    });

    await NotificationService.restoreActiveReminderSystem();
  }

  Future<void> _showFirstLaunchGuideIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool(_firstLaunchGuideKey) ?? false;

    if (seen || !mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final dialogContext = _navigatorKey.currentContext;
      if (dialogContext == null || !mounted) return;

      await showDialog(
        context: dialogContext,
        builder: (context) => AlertDialog(
          title: Text(AppStrings.t(AppStrings.firstLaunchWelcomeTitle)),
          content: Text(AppStrings.t(AppStrings.firstLaunchReliabilityMessage)),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppStrings.t(AppStrings.getStarted)),
            ),
          ],
        ),
      );

      await prefs.setBool(_firstLaunchGuideKey, true);
    });
  }

//========================================
// RATE STAYHYDRO PROMPT MESSAGE METHOD
//ایپ ریویو اور ریٹنگ پرامپٹ میسج کا میتھڈ
//========================================
  Future<void> _saveInstallDateIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey(_installDateKey)) {
      await prefs.setString(
        _installDateKey,
        DateTime.now().toIso8601String(),
      );
    }
  }

//========================================
// OPEN PLAY STORE LISTING
//========================================
  Future<void> _openPlayStoreListing() async {
    try {
      final intent = AndroidIntent(
        action: 'action_view',
        data: 'market://details?id=com.slnova.stayhydro',
      );

      await intent.launch();
    } catch (_) {
      // اگر Play Store نہ کھلے تو خاموشی سے ignore
    }
  }

//==================================
// APP RATING & REVIEW DIALOG METHOD
//==================================
  Future<void> _showReviewDialog() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    showDialog(
      context: _navigatorKey.currentContext!,
      builder: (context) => AlertDialog(
        title: const Text('Enjoying StayHydro?'),
        content: const Text(
          'Your review helps us improve and reach more people.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Maybe Later'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);

              await _openPlayStoreListing();

              await prefs.setBool(
                _reviewPromptShownKey,
                true,
              );
            },
            child: const Text('Rate Now'),
          ),
        ],
      ),
    );
  }

// ==========================================
// [PHASE 10.6-A16: APP LOCALE HELPER]
// اردو کمنٹ:
// selected language کے مطابق Flutter/Material widgets کی language set کرنے کے لیے
// Time Picker وغیرہ اسی سے translate ہوں گے
// ==========================================
  Locale _appLocale() {
    switch (AppStrings.activeLanguage) {
      case 'Spanish':
        return const Locale('es');
      case 'Arabic':
        return const Locale('ar');
      case 'Hindi':
        return const Locale('hi');
      case 'Indonesian':
        return const Locale('id');
      default:
        return const Locale('en');
    }
  }

  // ==========================================
  // UI BUILD
  // ==========================================
  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp(
      title: 'StayHydro',
      debugShowCheckedModeBanner: false,
      navigatorKey: _navigatorKey,
      locale: _appLocale(),
      supportedLocales: const [
        Locale('en'),
        Locale('es'),
        Locale('ar'),
        Locale('hi'),
        Locale('id'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.teal,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardTheme: ThemeData.dark().cardTheme.copyWith(
              color: const Color(0xFF1E1E1E),
              elevation: 2,
            ),
        dialogTheme: ThemeData.dark().dialogTheme.copyWith(
              backgroundColor: const Color(0xFF1E1E1E),
              surfaceTintColor: Colors.transparent,
            ),
      ),
      themeMode: _isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      home: Directionality(
        textDirection:
            AppStrings.isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: MainNavigationScreen(
          isDarkTheme: _isDarkTheme,
          isFastingMode: _isFastingMode,
          onThemeToggle: _toggleTheme,
          onFastingToggle: _toggleFasting,
          onLanguageChanged: _updateLanguage,
        ),
      ),
    );
  }
}
