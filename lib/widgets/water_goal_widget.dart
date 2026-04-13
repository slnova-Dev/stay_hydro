import 'package:flutter/material.dart';
import 'dart:math' as math;

class WaterGoalWidget extends StatefulWidget {
  final int currentIntake;
  final int goal;

  const WaterGoalWidget({
    super.key,
    required this.currentIntake,
    required this.goal,
  });

  @override
  State<WaterGoalWidget> createState() => _WaterGoalWidgetState();
}

class _WaterGoalWidgetState extends State<WaterGoalWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double targetProgress = widget.goal > 0
        ? (widget.currentIntake / widget.goal).clamp(0.0, 1.0)
        : 0.0;

    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color backgroundColor = isDark
        ? const Color(0xFF242F3E)
        : Colors.blue.shade100;

    final Color waveColor = isDark
        ? const Color(0xFF0B4485) // گہرا نیلا (آپ کا پسندیدہ انتخاب)
        : Colors.blue.shade400;

// 1. درمیانی رنگ جو آپ کو چبھ رہا تھا (Center Progress)
    final Color innerBarColor = isDark 
        ? const Color(0xFF2A3A4F)  // متوازن اور پرسکون نیلا گرے
        : Colors.blue.shade200;

    // 2. بیرونی کناروں کا رنگ (Outer Edges)
    final Color outerBarColor = isDark
        ? const Color(0xFF7a7c7d)  // کوئی ہلکا سا رنگ (شارپ باؤنڈری کے لیے)
        : Colors.blue.shade600;

    final Color darkShadow = Colors.blue.shade900.withOpacity(0.6);
    final Color lightShadow = Colors.white.withOpacity(0.4);
    
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: targetProgress),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeInOutCubic,
      builder: (context, value, _) {
        // اینیمیشن ویلیو کے مطابق 1150ml (0.575) پر رنگ تبدیل کرنے کی لاجک
        bool isHalfway = value >= 0.575;

        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // 1. لہروں والا دائرہ
                  Container(
                    width: 145,
                    height: 145,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: backgroundColor,
                    ),
                    child: ClipOval(
                      child: AnimatedBuilder(
                        animation: _waveController,
                        builder: (context, child) {
                          return CustomPaint(
                            painter: WavePainter(
                              progress: value,
                              waveAnimation: _waveController.value,
                              color: waveColor,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // 2. ڈبل شیڈ لوڈنگ بار
                  SizedBox(
                    width: 175,
                    height: 175,
                    child: CustomPaint(
                      painter: CleanDoubleBarPainter(
                        progress: value,
                        innerColor: innerBarColor,
                        outerColor: outerBarColor,
                        strokeWidth: 12.0,
                        baseCircleSize: 145,
                      ),
                    ),
                  ),

                  // 3. متحرک ٹیکسٹ
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${widget.currentIntake}/${widget.goal} ml',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isHalfway
                              ? Colors
                                    .white // پانی کے اندر سفید ہی رہنے دیں
                              : (isDark
                                    ? const Color(0xFFC8C9CF)
                                    : Colors
                                          .blue
                                          .shade900), // ڈارک موڈ میں آپ کا پسندیدہ ہلکا رنگ
                          shadows: [
                            Shadow(
                              // اگر پانی آدھا ہے تو گہرا نیلا سایہ، ورنہ ڈارک موڈ میں کالا سایہ
                              color: isHalfway
                                  ? darkShadow
                                  : (isDark
                                        ? Colors.black.withOpacity(0.8)
                                        : lightShadow),
                              blurRadius: isHalfway ? 4.0 : 2.0,
                              offset: const Offset(1.0, 1.0),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Water Intake',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isHalfway
                              ? Colors
                                    .white // پانی کے اندر سفید ہی رہنے دیں
                              : (isDark
                                    ? const Color(0xFFC8C9CF)
                                    : Colors
                                          .blue
                                          .shade900), // ڈارک موڈ میں آپ کا پسندیدہ ہلکا رنگ
                          shadows: [
                            Shadow(
                              // اگر پانی آدھا ہے تو گہرا نیلا سایہ، ورنہ ڈارک موڈ میں کالا سایہ
                              color: isHalfway
                                  ? darkShadow
                                  : (isDark
                                        ? Colors.black.withOpacity(0.8)
                                        : lightShadow),
                              blurRadius: isHalfway ? 4.0 : 2.0,
                              offset: const Offset(1.0, 1.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class WavePainter extends CustomPainter {
  final double progress;
  final double waveAnimation;
  final Color color;

  WavePainter({
    required this.progress,
    required this.waveAnimation,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    final double yOffset = size.height * (1 - progress);
    const double waveHeight = 5.0;

    path.moveTo(0, yOffset);
    for (double x = 0; x <= size.width; x++) {
      double y =
          math.sin(
                (x / size.width * 2 * math.pi) + (waveAnimation * 2 * math.pi),
              ) *
              waveHeight +
          yOffset;
      path.lineTo(x, y);
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class CleanDoubleBarPainter extends CustomPainter {
  final double progress;
  final Color innerColor;
  final Color outerColor;
  final double strokeWidth;
  final double baseCircleSize;

  CleanDoubleBarPainter({
    required this.progress,
    required this.innerColor,
    required this.outerColor,
    required this.strokeWidth,
    required this.baseCircleSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (baseCircleSize + strokeWidth + 2) / 2;
    final sweepAngle = 2 * math.pi * progress;

    final outerPaint = Paint()
      ..color = outerColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final innerPaint = Paint()
      ..color = innerColor
      ..strokeWidth = strokeWidth * 0.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    if (progress > 0) {
      final rect = Rect.fromCircle(center: center, radius: radius);
      canvas.drawArc(rect, -math.pi / 2, sweepAngle, false, outerPaint);
      canvas.drawArc(rect, -math.pi / 2, sweepAngle, false, innerPaint);
    }
  }

  @override
  bool shouldRepaint(CleanDoubleBarPainter oldDelegate) => true;
}
