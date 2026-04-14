import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ==========================================
// سیکشن 1: مسڈ انٹری ڈائیلاگ کلاس
// یہ کلاس اس وقت کھلتی ہے جب یوزر پرانی ٹائمنگ کی انٹری کرنا چاہے
// ==========================================
class MissedEntryDialog extends StatefulWidget {
  const MissedEntryDialog({super.key});

  @override
  State<MissedEntryDialog> createState() => _MissedEntryDialogState();
}

// ==========================================
// سیکشن 2: اسٹیٹ مینجمنٹ اور ویری ایبلز
// یہاں وقت اور پانی کی مقدار کا ڈیٹا محفوظ ہوتا ہے
// ==========================================
class _MissedEntryDialogState extends State<MissedEntryDialog> {
  TimeOfDay _selectedTime = TimeOfDay.now();
  int _selectedAmount = 200;

  // پانی کی مقدار کے بٹنوں کا ڈیٹا (SVG پاتھ اور ویلیو)
  final List<Map<String, dynamic>> presets = [
    {'amount': 100, 'asset': 'assets/buttons/100ml_button.svg'},
    {'amount': 150, 'asset': 'assets/buttons/150ml_button.svg'},
    {'amount': 200, 'asset': 'assets/buttons/200ml_button.svg'},
    {'amount': 250, 'asset': 'assets/buttons/250ml_button.svg'},
    {'amount': 300, 'asset': 'assets/buttons/300ml_button.svg'},
  ];

  // ==========================================
  // سیکشن 3: ٹائم پکر فنکشن (Custom Theme)
  // یہ فنکشن گھڑی والا ڈائیلاگ کھولتا ہے اور اس کی مکمل تھیمنگ یہاں ہے
  // ==========================================
  Future<void> _pickTime() async {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final TimeOfDay? picked = await showGeneralDialog<TimeOfDay>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) => const SizedBox.shrink(),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(
              CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                // کرسر اور ٹیکسٹ سلیکشن کا رنگ
                textSelectionTheme: TextSelectionThemeData(
                  cursorColor: isDarkMode
                      ? Colors.blue.shade400
                      : Colors.blue.shade700,
                  selectionColor: Colors.blue.withOpacity(0.3),
                  selectionHandleColor: Colors.blue.shade400,
                ),
                colorScheme: isDarkMode
                    ? ColorScheme.dark(
                        primary: Colors.blue.shade400,
                        onPrimary: Colors.white,
                        surface: const Color(0xFF1E293B),
                        onSurface: Colors.white,
                      )
                    : ColorScheme.light(
                        primary: Colors.blue.shade600,
                        onPrimary: Colors.white,
                        surface: Colors.white,
                        onSurface: Colors.blue.shade900,
                      ),
                timePickerTheme: TimePickerThemeData(
                  backgroundColor: isDarkMode
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFF5F6FA),
                  hourMinuteColor: WidgetStateColor.resolveWith(
                    (states) => states.contains(WidgetState.selected)
                        ? (isDarkMode
                            ? const Color(0xFF334155)
                            : Colors.blue.shade100)
                        : (isDarkMode ? Colors.black26 : Colors.white),
                  ),
                  hourMinuteTextColor: WidgetStateColor.resolveWith(
                    (states) => states.contains(WidgetState.selected)
                        ? (isDarkMode ? Colors.white : Colors.blue.shade900)
                        : (isDarkMode ? Colors.white70 : Colors.blue.shade400),
                  ),
                  dialBackgroundColor: isDarkMode
                      ? Colors.black26
                      : Colors.white,
                  dialHandColor: Colors.blue.shade400,
                  dialTextColor: isDarkMode ? Colors.white : Colors.black,
                  entryModeIconColor: Colors.blue.shade400,
                  // مینوئل ان پٹ باکس کی سیٹنگز
                  inputDecorationTheme: InputDecorationTheme(
                    filled: true,
                    fillColor: isDarkMode ? Colors.black26 : Colors.white,
                    contentPadding: const EdgeInsets.all(8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                // لائٹ موڈ میں ٹائم ان پٹ غائب ہونے کا حل
                textTheme: TextTheme(
                  bodyLarge: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                  bodyMedium: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              child: TimePickerDialog(initialTime: _selectedTime),
            ),
          ),
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  // ==========================================
  // سیکشن 4: ڈائیلاگ کا ظاہری ڈیزائن (UI Build)
  // یہاں کارڈز، بٹنز اور مین لے آؤٹ تیار ہوتا ہے
  // ==========================================
  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: isDarkMode
          ? const Color(0xFF1E293B)
          : const Color(0xFFF5F6FA),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDarkMode ? Colors.white10 : Colors.transparent,
            width: 1,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ہیڈر ٹائٹل
              Text(
                "Add Missed Entry",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode
                      ? Colors.blue.shade300
                      : Colors.blue.shade700,
                ),
              ),
              const SizedBox(height: 20),

              // ٹائم سلیکٹر کارڈ (جس پر کلک کر کے وقت بدلا جاتا ہے)
              InkWell(
                onTap: _pickTime,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.black26 : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDarkMode ? Colors.white10 : Colors.blue.shade100,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time_filled,
                        color: Colors.blue.shade400,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Intake Time",
                            style: TextStyle(
                              fontSize: 12,
                              color: isDarkMode ? Colors.white54 : Colors.grey,
                            ),
                          ),
                          Text(
                            _selectedTime.format(context),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Icon(Icons.edit, size: 16, color: Colors.blue.shade200),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Divider(
                height: 1,
                color: isDarkMode ? Colors.white10 : Colors.grey.shade300,
              ),
              const SizedBox(height: 15),

              // مقدار کے انتخاب کا ٹائٹل
              Text(
                "Select Amount",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode
                      ? Colors.blue.shade300
                      : Colors.blue.shade700,
                ),
              ),
              const SizedBox(height: 15),

              // ایس وی جی (SVG) بٹنوں کا مجموعہ
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: presets.map((p) => _buildSvgButton(p)).toList(),
              ),

              const SizedBox(height: 25),

              // ایکشن بٹنز (کینسل اور ایڈ انٹری)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: isDarkMode
                              ? Colors.blue.shade900.withOpacity(0.5)
                              : Colors.blue.shade200,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: isDarkMode
                              ? Colors.blue.shade200
                              : Colors.blue.shade400,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isDarkMode
                              ? Colors.blue.shade900.withOpacity(0.5)
                              : Colors.transparent,
                          width: 1,
                        ),
                        gradient: LinearGradient(
                          colors: isDarkMode
                              ? [
                                  const Color(0xFF1E293B), // ڈارک اوپر
                                  const Color(0xFF334155), // لائٹ نیچے
                                ]
                              : [Colors.blue.shade400, Colors.blue.shade600],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            offset: const Offset(0, 4),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context, {
                          'amount': _selectedAmount,
                          'time': _selectedTime,
                        }),
                        child: const FittedBox(
                          child: Text(
                            "Add Entry",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // سیکشن 5: مددگار ویجیٹ (SVG Button Builder)
  // یہ مخصوص پانی کی مقدار والے بٹن تیار کرتا ہے
  // ==========================================
  Widget _buildSvgButton(Map<String, dynamic> preset) {
    final bool isSelected = _selectedAmount == preset['amount'];
    return GestureDetector(
      onTap: () => setState(() => _selectedAmount = preset['amount']),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blue.shade400 : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: SvgPicture.asset(preset['asset'], width: 70),
      ),
    );
  }
}