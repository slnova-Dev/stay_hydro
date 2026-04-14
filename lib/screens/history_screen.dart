import 'package:flutter/material.dart';
import 'package:stay_hydro/services/history_service.dart'; // مکمل پاتھ

// ہم نے اسے StatefulWidget میں بدل دیا ہے تاکہ ڈیٹا ری فریش ہو سکے
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // ڈیٹا ری فریش کرنے کے لیے کی (Key)
  Key _refreshKey = UniqueKey();

  void refreshData() {
    setState(() {
      _refreshKey = UniqueKey();
    });
  }

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
        key: _refreshKey, // اسکرین ری فریش کرنے کے لیے
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
                : [Colors.blue.shade300, Colors.blue.shade50],
          ),
        ),

        // ==========================================
        // ڈیٹا لوڈ کرنے کے لیے فیوچر بلڈر
        // ==========================================
        child: FutureBuilder(
          // ہم یہاں چارٹ ڈیٹا اور اسٹیٹس دونوں ایک ساتھ لوڈ کریں گے
          future: Future.wait([
            HistoryService.getLast7Days(),
            HistoryService.getQuickStats(),
            HistoryService.getTodayLogs(),
          ]),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final List<Map<String, dynamic>> chartData =
                snapshot.data?[0] ?? [];
            final Map<String, dynamic> stats = snapshot.data?[1] ?? {};
            final List<IntakeEntry> todayLogs = snapshot.data?[2] ?? [];

            return SingleChildScrollView(
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
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Weekly Progress",
                          style: TextStyle(
                            color:
                                isDark ? Colors.white70 : Colors.blue.shade900,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          height: 150,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: chartData.map((dayData) {
                              return _buildBar(
                                dayData['day'],
                                dayData['amount'],
                                2500, // ہدف (Target)
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

                  // 2. Stats Cards (Average & Best Day)
                  Row(
                    children: [
                      _buildMiniStat(
                        "Average",
                        "${stats['average'] ?? 0} ml",
                        Icons.waves_rounded,
                        cardColor,
                        isDark,
                      ),
                      const SizedBox(width: 15),
                      _buildMiniStat(
                        "Best Day",
                        "${stats['bestDay'] ?? 0} ml",
                        Icons.star_rounded,
                        cardColor,
                        isDark,
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // ==========================================
                  // SECTION LOCK: DAILY LOG LIST
                  // آج پیے گئے پانی کی تفصیلی لسٹ
                  // ==========================================
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
                              : Colors.blue.shade900.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ),

                  Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: todayLogs.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(30),
                            child: Center(
                              child: Text(
                                "No entries for today yet",
                                style: TextStyle(
                                    color: isDark
                                        ? Colors.white30
                                        : Colors.blue.shade200),
                              ),
                            ),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: todayLogs.length,
                            separatorBuilder: (context, index) => Divider(
                              color:
                                  isDark ? Colors.white10 : Colors.blue.shade50,
                              indent: 70,
                            ),
                            itemBuilder: (context, index) {
                              final log = todayLogs[index];
                              return ListTile(
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
                                          : Colors.black54,
                                      fontSize: 12),
                                ),
                                trailing: Text(
                                  log.time,
                                  style: TextStyle(
                                      color: isDark
                                          ? Colors.white30
                                          : Colors.blue.shade300,
                                      fontSize: 12),
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // --- UI ہیلپر فنکشنز ---

  Widget _buildBar(String day, int amount, int goal, Color color, bool isDark) {
    double percentage = (amount / goal).clamp(0.05, 1.0);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 14,
          height: 100 * percentage,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          day,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color:
                isDark ? Colors.white60 : Colors.blue.shade900.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildMiniStat(
      String label, String value, IconData icon, Color color, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon,
                color: isDark ? Colors.blue.shade300 : Colors.blue.shade700,
                size: 22),
            const SizedBox(height: 12),
            Text(label,
                style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 4),
          