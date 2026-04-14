import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // یہ لائن شامل کریں
import 'firebase_options.dart'; // یہ لائن شامل کریں
// ... باقی امپورٹس (جیسے NotificationService وغیرہ) ویسے ہی رہیں گی
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/main_navigation_screen.dart';
import 'services/notification_service.dart';

// ==========================================
// سیکشن 1: مین فنکشن اور ایپ کا آغاز
// اس حصے میں ایپ کی شروعات اور ضروری سروسز لوڈ ہوتی ہیں
// ==========================================
void main() async {
  // 1. یہ یقینی بناتا ہے کہ فلٹر کے تمام ویجیٹس تیار ہیں
  WidgetsFlutterBinding.ensureInitialized();

  // 2. فائربیس کو انیشیلائز کریں (یہ وہ جادوئی لائن ہے)
  // یہ لائن ایپ کو آپ کے فائربیس پروجیکٹ سے جوڑتی ہے
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 3. نوٹیفیکیشن سروس کو شروع کرنا
  await NotificationService.init();

  // 4. ایپ کا نام اب آفیشل StayHydroApp ہے
  runApp(const StayHydroApp());
}

// ==========================================
// سیکشن 2: مین ایپ کلاس (StatefulWidget)
// یہ ایپ کی مین جڑ ہے جہاں سے تھیم اور اسٹیٹ کنٹرول ہوتی ہے
// ==========================================
class StayHydroApp extends StatefulWidget {
  const StayHydroApp({super.key});

  @override
  State<StayHydroApp> createState() => _StayHydroAppState();
}

// ==========================================
// سیکشن 3: ایپ کی اسٹیٹ اور سیٹنگز (Logic)
// یہاں ڈارک موڈ، روزہ موڈ اور دیگر ڈیٹا لوڈ کیا جاتا ہے
// ==========================================
class _StayHydroAppState extends State<StayHydroApp> {
  bool _isDarkTheme = false;
  bool _isFastingMode = false;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadPrefs(); // محفوظ شدہ سیٹنگز لوڈ کرنا
  }

  // یوزر کی پرانی سیٹنگز فون کی میموری سے نکالنا
  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
    _isFastingMode = prefs.getBool('isFastingMode') ?? false;
    if (!mounted) return;
    setState(() {
      _isLoaded = true;
    });
  }

  // تھیم (لائٹ/ڈارک) تبدیل کرنے کا فنکشن
  Future<void> _toggleTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', value);
    if (!mounted) return;
    setState(() {
      _isDarkTheme = value;
    });
  }

  // روزہ موڈ (Fasting Mode) آن یا آف کرنے کا فنکشن
  Future<void> _toggleFasting(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFastingMode', value);
    if (!mounted) return;
    setState(() {
      _isFastingMode = value;
    });
    if (value) {
      // اگر روزہ موڈ آن ہے تو نوٹیفیکیشنز بند کر دیں
      await NotificationService.cancelAll();
    }
  }

  // ==========================================
  // سیکشن 4: ڈیزائن اور یو آئی (UI Build)
  // یہاں ایپ کا ظاہری ڈیزائن، رنگ اور تھیمز بیان کیے گئے ہیں
  // ==========================================
  @override
  Widget build(BuildContext context) {
    // جب تک ڈیٹا لوڈ نہ ہو، لوڈنگ اسکرین دکھائیں
    if (!_isLoaded) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp(
      title: 'StayHydro', // ایپ کا ٹائٹل تبدیل کر دیا گیا
      debugShowCheckedModeBanner: false,

      // --- لائٹ تھیم کا سیکشن ---
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.teal,
      ),

      // --- ڈارک تھیم کا سیکشن ---
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
      
      // --- مین نیویگیشن اسکرین (ہوم پیج) ---
      home: MainNavigationScreen(
        isDarkTheme: _isDarkTheme,
        isFastingMode: _isFastingMode,
        onThemeToggle: _toggleTheme,
        onFastingToggle: _toggleFasting,
      ),
    );
  }
}