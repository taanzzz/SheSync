import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class CycleStatusCard extends StatelessWidget {
  final Map<String, dynamic>? prediction;
  final Map<String, dynamic>? statistics;

  const CycleStatusCard({super.key, this.prediction, this.statistics});

  @override
  Widget build(BuildContext context) {
    final predictedDate = prediction?['predictedDate'] != null
        ? DateTime.parse(prediction!['predictedDate'].toString())
        : null;
    final avgCycleLength = prediction?['avgCycleLength'] ?? 28;
    final confidence = prediction?['confidence'] ?? 'low';
    final phase = prediction?['phase'] ?? 'menstrual';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        constraints: const BoxConstraints(minHeight: 200),
        decoration: BoxDecoration(
          gradient: AppColors.phaseGradient(phase),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.phaseColor(phase).withValues(alpha: 0.3),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: 20,
              top: 20,
              child: SizedBox(
                width: 80,
                height: 80,
                child: CustomPaint(
                  painter: _CycleRingPainter(
                    progress: (avgCycleLength as num?)?.toDouble() ?? 0.5,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    (prediction?['phase'] ?? 'MENSTRUAL')
                        .toString()
                        .toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      letterSpacing: 2,
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${prediction?['cycleDay'] ?? '14'}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.1,
                    ),
                  ),
                  Text(
                    'days until period',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _PhaseDot(true, AppColors.deepBurgundy),
                      const SizedBox(width: 8),
                      _PhaseDot(false, AppColors.roseBlush),
                      const SizedBox(width: 8),
                      _PhaseDot(false, AppColors.goldenGlow),
                      const SizedBox(width: 8),
                      _PhaseDot(false, AppColors.mysticPlum),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: confidence == 'high'
                              ? AppColors.success.withValues(alpha: 0.3)
                              : Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          confidence == 'high' ? 'High Confidence' : 'Learning',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 16,
                    runSpacing: 6,
                    children: [
                      Text(
                        predictedDate != null
                            ? 'Next Period: ${predictedDate.day}/${predictedDate.month}'
                            : 'Next Period: --',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                      Text(
                        'Fertile: ${prediction?['fertileStart'] ?? '--'} - ${prediction?['fertileEnd'] ?? '--'}',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhaseDot extends StatelessWidget {
  final bool isActive;
  final Color color;
  const _PhaseDot(this.isActive, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isActive ? 10 : 8,
      height: isActive ? 10 : 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : color.withValues(alpha: 0.5),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _CycleRingPainter extends CustomPainter {
  final double progress;
  _CycleRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    final bgPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;
    canvas.drawCircle(center, radius, bgPaint);

    final progressPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      progressPaint,
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text: '${(progress * 28).round()}/28',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      center - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
