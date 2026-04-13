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
    final Color accentColor = isDark
        ? const Color(0xFF00B4D8)
        : Colors.blue.shade700;
    final Color cardColor = isDark
        ? Colors.white.withOpacity(0.05)
        : Colors.white.withOpacity(0.3);

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
                : [Colors.teal.shade300, Colors.cyan.shade100],
          ),
        ),

        // ==========================================
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: HistoryService.getLast7Days(), // یہ لائن ہر بار اسکرین کھلنے پر ڈیٹا لوڈ کرتی ہے
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final data = snapshot.data ?? [];

            return SingleChildScrollView(
              padding: const EdgeInsets.only(
                top: 120,
                left: 20,
                right: 20,
                bottom: 20,
              ),
              child: Column(
                children: [
                  // Weekly Progress Chart
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: data.map((dayData) {
                              return _buildBar(
                                dayData['day'],
                                dayData['amount'],
                                2500,
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

                  // Stats Cards
                  Row(
                    children: [
                      _buildMiniStat(
                        "Average",
                        _calculateAverage(data),
                        Icons.waves_rounded,
                        cardColor,
                        isDark,
                      ),
                      const SizedBox(width: 15),
                      _buildMiniStat(
                        "Streak",
                        "Calculating...",
                        Icons.local_fire_department_rounded,
                        cardColor,
                        isDark,
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Clock Background Icon
                  Opacity(
                    opacity: 0.3,
                    child: Icon(
                      Icons.history_toggle_off_rounded,
                      size: 60,
                      color: isDark
                          ? Colors.blue.shade400
                          : Colors.blue.shade700,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // --- بار اور سٹیٹس کے فنکشنز وہی رہیں گے جو پہلے تھے ---
  Widget _buildBar(String day, int amount, int goal, Color color, bool isDark) {
    double percentage = (amount / goal).clamp(0.05, 1.0);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 12,
          height: 100 * percentage,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          day,
          style: TextStyle(
            fontSize: 12,
            color: isDark
                ? Colors.white60
                : Colors.blue.shade900.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildMiniStat(
    String label,
    String value,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: isDark ? Colors.blue.shade300 : Colors.blue.shade700,
              size: 20,
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.blue.shade900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _calculateAverage(List<Map<String, dynamic>> data) {
    if (data.isEmpty || data.every((e) => e['amount'] == 0)) return "0 ml";
    var filteredData = data.where((e) => e['amount'] > 0).toList();
    if (filteredData.isEmpty) return "0 ml";
    double avg =
        filteredData.map((e) => e['amount'] as int).reduce((a, b) => a + b) /
        filteredData.length;
    return "${avg.toStringAsFixed(0)} ml";
  }
}
