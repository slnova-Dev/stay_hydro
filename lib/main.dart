import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ❌ REMOVE: background service imports
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_background_service_android/flutter_background_service_android.dart';

import 'package:stay_hydro/services/sound_service.dart';
import 'screens/main_navigation_screen.dart';
import 'services/notification_service.dart';

// ==========================================
// سیکشن 1: مین فنکشن اور ایپ کا آغاز
// ==========================================
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ✅ نوٹیفیکیشن سروس کافی ہے (background service کی ضرورت نہیں)
  await NotificationService.init();

  // App start/update/reinstall کے بعد enabled special reminders restore کریں
  await NotificationService.restoreSpecialReminders();

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

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
    _isFastingMode = prefs.getBool('isFastingMode') ?? false;

    if (!mounted) return;

    setState(() {
      _isLoaded = true;
    });
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
      home: MainNavigationScreen(
        isDarkTheme: _isDarkTheme,
        isFastingMode: _isFastingMode,
        onThemeToggle: _toggleTheme,
        onFastingToggle: _toggleFasting,
      ),
    );
  }
}
