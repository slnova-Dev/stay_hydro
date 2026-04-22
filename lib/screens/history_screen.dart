import 'package:flutter/material.dart';
import 'package:stay_hydro/services/history_service.dart'; // مکمل پاتھ

// ==========================================
// SECTION LOCK: DATA REFRESH LOGIC (DO NOT MODIFY)
// یہ حصہ ڈیٹا کو ہر بار سکرین لوڈ ہونے پر تازہ (Refresh) کرتا ہے
// ==========================================
class HistoryScreen extends StatefulWidget {
  // اردو کمنٹ: نیویگیشن بار سے ری فریش سگنل وصول کرنے کے لیے پیرامیٹر
  final ValueNotifier<int>? refreshNotifier;

  const HistoryScreen({super.key, this.refreshNotifier});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Key _refreshKey = UniqueKey();
  
  // 🔥 سائلنٹ لوڈنگ کے لیے نئے ویری ایبلز
  bool _isLoading = true;
  List<Map<String, dynamic>> _chartData = [];
  Map<String, dynamic> _stats = {};
  List<IntakeEntry> _todayLogs = [];
  
  // 🔥 اینیمیشن کنٹرول کے لیے ویری ایبل
  double _animationValue = 0.0;

  @override
  void initState() {
    super.initState();
    // پہلی بار ڈیٹا لوڈ کرنا
    _loadAllData();

    // اردو کمنٹ: جب بھی نیویگیشن بار پر کلک ہوگا، یہ لسنر ڈیٹا اور سکرول کو ری فریش کرے گا
    widget.refreshNotifier?.addListener(_handleNavigationRefresh);
  }

  // اردو کمنٹ: نیویگیشن کلک کو ہینڈل کرنے والا فنکشن
  void _handleNavigationRefresh() {
    if (mounted) {
      _loadAllData();
    }
  }

  @override
  void dispose() {
    // اردو کمنٹ: میموری لیک سے بچنے کے لیے لسنر کو ختم کرنا ضروری ہے
    widget.refreshNotifier?.removeListener(_handleNavigationRefresh);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // سکرین پر واپس آنے پر ڈیٹا کی دوبارہ لوڈنگ
    _loadAllData();
  }

  void _loadAllData() async {
    if (!mounted) return;

    // ڈیٹا لوڈ کرنے سے پہلے اینیمیشن ری سیٹ کریں تاکہ دوبارہ چل سکے
    setState(() {
      _animationValue = 0.0;
    });

    try {
      final results = await Future.wait([
        HistoryService.getLast7Days(),
        HistoryService.getQuickStats(),
        HistoryService.getTodayLogs(),
      ]);

      if (mounted) {
        setState(() {
          _chartData = results[0] as List<Map<String, dynamic>>;
          _stats = results[1] as Map<String, dynamic>;
          _todayLogs = results[2] as List<IntakeEntry>;
          _isLoading = false;
          _refreshKey = UniqueKey(); // سکرول ری سیٹ کرنے کے لیے
        });

        // ڈیٹا لوڈ ہونے کے بعد اینیمیشن شروع کریں
        Future.delayed(const Duration(milliseconds: 50), () {
          if (mounted) {
            setState(() {
              _animationValue = 1.0;
            });
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      debugPrint("Error loading history: $e");
    }
  }

  void refreshData() {
    if (mounted) {
      _loadAllData();
    }
  }
// ==========================================

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color accentColor =
        isDark ? const Color(0xFF00B4D8) : Colors.blue.shade700;
    final Color cardColor =
        isDark ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.4);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'History',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.blue.shade900,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
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

        // ==========================================
        // SECTION LOCK: BACKGROUND & THEME SETTINGS
        // اس حصے کے ڈیزائن اور رنگوں کو تبدیل نہ کریں
        // ==========================================
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [const Color(0xFF0F172A), const Color(0xFF1E293B)]
                : [Colors.teal.shade300, Colors.cyan.shade100],
          ),
        ),
        // ==========================================

        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              bottom: 150,
              child: Opacity(
                opacity: 0.1,
                child: Icon(
                  Icons.history_toggle_off_rounded,
                  size: 280,
                  color: isDark ? Colors.white : Colors.blue.shade900,
                ),
              ),
            ),

            // 🔥 اب FutureBuilder کی جگہ براہِ راست UI لوڈ ہوگا
            if (_isLoading && _chartData.isEmpty)
               const Center(child: CircularProgressIndicator())
            else
              SingleChildScrollView(
                key: _refreshKey,
                padding: const EdgeInsets.only(
                    top: 120, left: 20, right: 20, bottom: 20),
                child: Column(
                  children: [
                    // 1. Weekly Progress Chart
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(24),
                        border:
                            Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Weekly Progress",
                            style: TextStyle(
                              color: isDark
                                  ? Colors.white70
                                  : Colors.blue.shade900,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            height: 150,
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: _chartData.map((dayData) {
                                return _buildBar(
                                  dayData['day'],
                                  dayData['amount'],
                                  2000, 
                                  accentColor,
                                  isDark,
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // 2. Stats Cards
                    Row(
                      children: [
                        _buildMiniStat(
                          "Average",
                          "${_stats['average'] ?? 0}ml",
                          Icons.waves_rounded,
                          cardColor,
                          isDark,
                        ),
                        const SizedBox(width: 10),
                        _buildMiniStat(
                          "Done",
                          "${_stats['completionRate'] ?? 0}%",
                          Icons.check_circle_outline_rounded,
                          cardColor,
                          isDark,
                        ),
                        const SizedBox(width: 10),
                        _buildMiniStat(
                          "Best",
                          "${_stats['bestDay'] ?? 0}ml",
                          Icons.star_rounded,
                          cardColor,
                          isDark,
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // 3. DAILY LOG LIST
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, bottom: 12),
                        child: Text(
                          "TODAY'S LOGS",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: isDark
                                ? Colors.white54
                                : Colors.blue.shade900.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ),

                    Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(24),
                        border:
                            Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: _todayLogs.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(30),
                              child: Center(
                                child: Text(
                                  "No entries for today yet",
                                  style: TextStyle(
                                      color: isDark
                                          ? Colors.white30
                                          : Colors.blue.shade400),
                                ),
                              ),
                            )
                          : ListView.separated(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _todayLogs.length,
                              separatorBuilder: (context, index) => Divider(
                                color: isDark
                                    ? Colors.white10
                                    : Colors.blue.withOpacity(0.1),
                                height: 1,
                                indent: 70,
                              ),
                              itemBuilder: (context, index) {
                                final log = _todayLogs[index];
                                return ListTile(
                                  visualDensity: const VisualDensity(
                                      vertical: -2),
                                  leading: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.water_drop,
                                        color: accentColor, size: 20),
                                  ),
                                  title: Text(
                                    "${log.amount} ml",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isDark
                                          ? Colors.white
                                          : Colors.blue.shade900,
                                    ),
                                  ),
                                  subtitle: Text(
                                    log.type,
                                    style: TextStyle(
                                        color: isDark
                                            ? Colors.white54
                                            : Colors.black87,
                                        fontSize: 12),
                                  ),
                                  trailing: Text(
                                    log.time,
                                    style: TextStyle(
                                        color: isDark
                                            ? Colors.white30
                                            : Colors.blue.shade600,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  ),
                                );
                              },
                            ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  // --- UI ہیلپر فنکشنز ---

Widget _buildBar(String day, int amount, int goal, Color color, bool isDark) {
  double percentage = (amount / goal).clamp(0.05, 1.0) * _animationValue;
  
  return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      AnimatedContainer(
        duration: const Duration(milliseconds: 800), 
        curve: Curves.easeOutCubic, 
        width: 16, 
        height: 120 * percentage, 
        decoration: BoxDecoration(
          color: isDark ? Colors.cyanAccent : Colors.blue.shade500, 
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            if (amount >= goal && _animationValue == 1.0) 
              BoxShadow(
                color: (isDark ? Colors.cyanAccent : Colors.blue).withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
      ),
      const SizedBox(height: 8),
      Text(
        day,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white70 : Colors.blue.shade900,
        ),
      ),
    ],
  );
}

  Widget _buildMiniStat(
      String label, String value, IconData icon, Color color, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon,
                color: isDark ? Colors.blue.shade300 : Colors.blue.shade700,
                size: 20),
            const SizedBox(height: 10),
            Text(label,
                style: TextStyle(
                  color: isDark 
                      ? Colors.white30 
                      : Colors.blue.shade900.withOpacity(0.8), 
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                )),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.blue.shade900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}