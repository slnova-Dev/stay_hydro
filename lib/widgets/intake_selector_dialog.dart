import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IntakeSelectorDialog extends StatefulWidget {
  final int currentValue;
  final Function(int) onSelected;

  const IntakeSelectorDialog({
    super.key,
    required this.currentValue,
    required this.onSelected,
  });

  @override
  State<IntakeSelectorDialog> createState() => _IntakeSelectorDialogState();
}

class _IntakeSelectorDialogState extends State<IntakeSelectorDialog> {
  late int _tempSelected;
  String? _errorText;
  final TextEditingController _customController = TextEditingController();

  final List<Map<String, dynamic>> presets = [
    {'amount': 100, 'asset': 'assets/buttons/100ml_button.svg'},
    {'amount': 150, 'asset': 'assets/buttons/150ml_button.svg'},
    {'amount': 200, 'asset': 'assets/buttons/200ml_button.svg'},
    {'amount': 250, 'asset': 'assets/buttons/250ml_button.svg'},
    {'amount': 300, 'asset': 'assets/buttons/300ml_button.svg'},
  ];

  @override
  void initState() {
    super.initState();
    _tempSelected = widget.currentValue;
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  bool _isInRange(int value) => value >= 50 && value <= 1000;
  bool _isStepValid(int value) => value % 50 == 0;

  void _onCustomChanged(String value) {
    final parsed = int.tryParse(value);
    if (parsed == null) {
      setState(() {
        _errorText = "نمبر درج کریں";
        _tempSelected = widget.currentValue;
      });
      return;
    }

    if (!_isInRange(parsed) || !_isStepValid(parsed)) {
      setState(() {
        _errorText = "50 سے 1000 کے درمیان (50 کا فرق)";
        _tempSelected = 0;
      });
    } else {
      setState(() {
        _errorText = null;
        _tempSelected = parsed;
      });
    }
  }

@override
Widget build(BuildContext context) {
  final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

  return Dialog(
    insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: SingleChildScrollView(
          // اب کی بورڈ کھلنے پر یہ صرف ضروری جگہ بنائے گا، ڈائیلاگ کو غیر ضروری اوپر نہیں اٹھائے گا
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? 10 : 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Select Intake Amount",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode
                      ? Colors.blue.shade300
                      : Colors.blue.shade700,
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: presets.map((p) => _buildSvgButton(p)).toList(),
              ),
              const SizedBox(height: 25),
              TextField(
                controller: _customController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: "Custom (50–1000 ml)",
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white54 : Colors.grey,
                  ),
                  errorText: _errorText,
                  filled: true,
                  fillColor: isDarkMode ? Colors.black26 : Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDarkMode
                          ? Colors.white10
                          : Colors.blue.shade100,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.blue.shade400,
                      width: 2,
                    ),
                  ),
                ),
                onChanged: _onCustomChanged,
              ),
 const SizedBox(height: 25),
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
                        // ہوم اسکرین والے بٹنز جیسی آؤٹ لائن
                        border: Border.all(
                          color: isDarkMode ? Colors.blue.shade900.withOpacity(0.5) : Colors.transparent,
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
                        onPressed: (_tempSelected > 0)
                            ? () => Navigator.pop(context, _tempSelected)
                            : null,
                        child: const Text(
                          "Save",
                          style: TextStyle(fontSize: 16, color: Colors.white),
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
    ),
  );
}

Widget _buildSvgButton(Map<String, dynamic> preset) {
  final bool isSelected = _tempSelected == preset['amount'];
  return GestureDetector(
    onTap: () {
      setState(() {
        _tempSelected = preset['amount'];
        _customController.clear();
        _errorText = null;
      });
    },
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