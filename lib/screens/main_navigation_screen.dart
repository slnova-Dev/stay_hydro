import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final bool isDarkTheme;
  final Function(bool) onThemeToggle;
  final bool isFastingMode;
  final Function(bool) onFastingToggle;

  const MainNavigationScreen({
    super.key,
    required this.isDarkTheme,
    required this.onThemeToggle,
    required this.isFastingMode,
    required this.onFastingToggle,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _navItems = [
    {'icon': Icons.water_drop_rounded, 'label': 'Home'},
    {'icon': Icons.insert_chart_rounded, 'label': 'History'},
    {'icon': Icons.tune_rounded, 'label': 'Settings'},
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDark = widget.isDarkTheme;
    final Color activeColor = Colors.blue.shade400;

    return Scaffold(
      extendBody: true,
      // ==========================================
      // SECTION LOCK: MAIN BACKGROUND
      // ==========================================
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      // ==========================================
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedIndex,
            children: [
              HomeScreen(
                isDarkTheme: widget.isDarkTheme,
                onThemeToggle: widget.onThemeToggle,
                isFastingMode: widget.isFastingMode,
                onFastingToggle: widget.onFastingToggle,
              ),
              const HistoryScreen(), // ہسٹری اسکرین
              SettingsScreen(
                isDark: widget.isDarkTheme,
                onThemeToggle: widget.onThemeToggle,
                isFastingMode: widget.isFastingMode,
                onFastingToggle: widget.onFastingToggle,
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
              child: Container(
                height: 70,
                // ==========================================
                // SECTION LOCK: NAVBAR DECORATION & THEME
                // ==========================================
                decoration: BoxDecoration(
                  gradient: isDark
                      ? const LinearGradient(
                          colors: [Color(0xFF1E293B), Color(0xFF334155)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        )
                      : null,
                  color: isDark ? null : Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(35),
                  border: Border.all(
                    color: isDark
                        ? Colors.blue.shade900.withOpacity(0.5)
                        : activeColor.withOpacity(0.2),
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withOpacity(0.3)
                          : activeColor.withOpacity(0.15),
                      blurRadius: isDark ? 10 : 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                // ==========================================
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(_navItems.length, (index) {
                      bool isSelected = _selectedIndex == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                          // ==========================================
                          // SECTION LOCK: NAV ITEM BUTTON STYLE
                          // ==========================================
                          decoration: BoxDecoration(
                            gradient: (isSelected && isDark)
                                ? const LinearGradient(
                                    colors: [
                                      Color(0xFF334155),
                                      Color(0xFF1E293B),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  )
                                : null,
                            color: isSelected
                                ? (isDark
                                      ? null
                                      : activeColor.withOpacity(0.15))
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: (isSelected && isDark)
                                  ? Colors.blue.shade900.withOpacity(0.5)
                                  : Colors.transparent,
                              width: 1,
                            ),
                          ),
                          // ==========================================
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _navItems[index]['icon'],
                                color: isSelected
                                    ? activeColor
                                    : (isDark
                                          ? Colors.white54
                                          : Colors.grey.shade400),
                                size: isSelected ? 26 : 24,
                              ),
                              if (isSelected) ...[
                                const SizedBox(width: 8),
                                Text(
                                  _navItems[index]['label'],
                                  style: TextStyle(
                                    color: activeColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
