import 'package:flutter/material.dart';

class AppColors {
  static const roseBlush = Color(0xFFFF97D0);
  static const peachSunset = Color(0xFFFFCF95);
  static const crimsonHeart = Color(0xFFCB2957);
  static const midnightBase = Color(0xFF000000);
  static const goldenGlow = Color(0xFFF0E76F);
  static const lavenderDream = Color(0xFF9FA1FF);
  static const skyBreeze = Color(0xFFAEE2FF);
  static const deepBurgundy = Color(0xFF810B38);
  static const creamPuff = Color(0xFFFFF9D2);
  static const mysticPlum = Color(0xFF744577);

  static const menstrualPhase = Color(0xFF810B38);
  static const follicularPhase = Color(0xFFFF97D0);
  static const ovulationPhase = Color(0xFFF0E76F);
  static const lutealPhase = Color(0xFF744577);
  static const fertileWindow = Color(0xFF9FA1FF);
  static const safeDay = Color(0xFFAEE2FF);

  static const scaffoldBg = Color(0xFFFFF9D2);
  static const cardSurface = Color(0xFFFFFFFF);
  static const cardSoft = Color(0xFFFFF0F7);
  static const inputFill = Color(0xFFFFF0F7);
  static const dividerColor = Color(0xFFFFD6EC);
  static const shimmerBase = Color(0xFFFFE4F2);

  static const textDark = Color(0xFF1A0A10);
  static const textMedium = Color(0xFF744577);
  static const textLight = Color(0xFFB07090);
  static const textOnDark = Color(0xFFFFF9D2);

  static const primaryGradient = LinearGradient(
    colors: [Color(0xFFFF97D0), Color(0xFFCB2957)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const warmGradient = LinearGradient(
    colors: [Color(0xFFFFCF95), Color(0xFFFF97D0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const calmGradient = LinearGradient(
    colors: [Color(0xFFAEE2FF), Color(0xFF9FA1FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const heroGradient = LinearGradient(
    colors: [Color(0xFFFFF9D2), Color(0xFFFFE4F2), Color(0xFFFF97D0)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static LinearGradient phaseGradient(String phase) {
    switch (phase) {
      case 'menstrual':
        return const LinearGradient(
          colors: [Color(0xFF810B38), Color(0xFFCB2957)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'follicular':
        return const LinearGradient(
          colors: [Color(0xFFFF97D0), Color(0xFFFFCF95)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'ovulation':
        return const LinearGradient(
          colors: [Color(0xFFF0E76F), Color(0xFFFFCF95)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'luteal':
        return const LinearGradient(
          colors: [Color(0xFF744577), Color(0xFF9FA1FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return const LinearGradient(
          colors: [Color(0xFFFF97D0), Color(0xFFCB2957)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  static Color phaseColor(String phase) {
    switch (phase) {
      case 'menstrual':
        return deepBurgundy;
      case 'follicular':
        return roseBlush;
      case 'ovulation':
        return goldenGlow;
      case 'luteal':
        return mysticPlum;
      default:
        return roseBlush;
    }
  }

  static const Color primary = Color(0xFFFF97D0);
  static const Color primaryLight = Color(0xFFFFCF95);
  static const Color primaryDark = Color(0xFFCB2957);
  static const Color menstrual = Color(0xFF810B38);
  static const Color follicular = Color(0xFFFF97D0);
  static const Color ovulation = Color(0xFFF0E76F);
  static const Color luteal = Color(0xFF744577);
  static const Color fertile = Color(0xFF9FA1FF);
  static const Color highFertile = Color(0xFFF0E76F);
  static const Color lowFertile = Color(0xFFAEE2FF);
  static const Color background = Color(0xFFFFF9D2);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1A0A10);
  static const Color textSecondary = Color(0xFF744577);
  static const Color divider = Color(0xFFFFD6EC);
  static const Color success = Color(0xFF48BB78);
  static const Color warning = Color(0xFFED8936);
  static const Color error = Color(0xFFE53E3E);
  static const Color info = Color(0xFF9FA1FF);
}
