import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class PhaseBadge extends StatelessWidget {
  final String phase;
  final double fontSize;

  const PhaseBadge({super.key, required this.phase, this.fontSize = 11});

  @override
  Widget build(BuildContext context) {
    final config = _getConfig();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: config.color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        config.label,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
          color: config.textColor,
        ),
      ),
    );
  }

  _PhaseConfig _getConfig() {
    switch (phase.toLowerCase()) {
      case 'menstrual':
        return _PhaseConfig(
          AppColors.menstrualPhase,
          Colors.white,
          'MENSTRUAL',
        );
      case 'follicular':
        return _PhaseConfig(
          AppColors.follicularPhase,
          Colors.white,
          'FOLLICULAR',
        );
      case 'ovulation':
        return _PhaseConfig(
          AppColors.ovulationPhase,
          AppColors.textDark,
          'OVULATION',
        );
      case 'luteal':
        return _PhaseConfig(AppColors.lutealPhase, Colors.white, 'LUTEAL');
      case 'fertile':
        return _PhaseConfig(AppColors.fertileWindow, Colors.white, 'FERTILE');
      case 'safe':
        return _PhaseConfig(AppColors.safeDay, AppColors.textDark, 'SAFE DAY');
      default:
        return _PhaseConfig(
          AppColors.roseBlush,
          Colors.white,
          phase.toUpperCase(),
        );
    }
  }
}

class _PhaseConfig {
  final Color color;
  final Color textColor;
  final String label;

  _PhaseConfig(this.color, this.textColor, this.label);
}
