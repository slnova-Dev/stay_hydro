import 'dart:async';

import 'package:flutter/material.dart';
import 'main_navigation_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/app_strings.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  final bool isDarkTheme;
  final Function(bool) onThemeToggle;
  final bool isFastingMode;
  final Function(bool) onFastingToggle;
  final Function(String) onLanguageChanged;

  const SplashScreen({
    super.key,
    required this.isDarkTheme,
    required this.onThemeToggle,
    required this.isFastingMode,
    required this.onFastingToggle,
    required this.onLanguageChanged,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const String _firstLaunchGuideKey =
      'first_launch_reliability_guide_seen';

  @override
  void initState() {
    super.initState();
    _initializeStartup();
  }

  //==============================================
  // STARTUP FLOW
  // Splash Screen Initialization
  // سپلیش سکرین آغاز اور اسٹارٹ اپ فلو
  //==============================================
  Future<void> _initializeStartup() async {
    await Future.delayed(
      const Duration(milliseconds: 1000),
    );

    if (!mounted) return;

    await _showWelcomeIfNeeded();

    await Future.delayed(
      const Duration(milliseconds: 150),
    );

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (_, __, ___) => MainNavigationScreen(
          isDarkTheme: widget.isDarkTheme,
          onThemeToggle: widget.onThemeToggle,
          isFastingMode: widget.isFastingMode,
          onFastingToggle: widget.onFastingToggle,
          onLanguageChanged: widget.onLanguageChanged,
        ),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  //==============================================
  // FIRST LAUNCH GUIDE
  // پہلی مرتبہ ایپ استعمال کرنے والوں کے لیے
  // Welcome & Reliability Guide
  //==============================================
  Future<void> _showWelcomeIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();

    final seen = prefs.getBool(_firstLaunchGuideKey) ?? false;

    if (seen) return;

    if (!mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(
          AppStrings.t(
            AppStrings.firstLaunchWelcomeTitle,
          ),
        ),
        content: Text(
          AppStrings.t(
            AppStrings.firstLaunchReliabilityMessage,
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              AppStrings.t(
                AppStrings.getStarted,
              ),
            ),
          ),
        ],
      ),
    );

    await prefs.setBool(
      _firstLaunchGuideKey,
      true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: dark ? const Color(0xFF101826) : const Color(0xFFF7FAFF),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/splash_logo.png",
                width: 118,
              ),
              const SizedBox(height: 18),
              SvgPicture.asset(
                "assets/images/stayhydro_wordmark.svg",
                width: 190,
              ),
              const SizedBox(height: 8),
              Text(
                "Your Hydration Companion",
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF6B7280),
                  letterSpacing: .3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
