class MedicalRanges {
  static const int minPeriodDays = 2;
  static const int maxPeriodDays = 7;
  static const int idealPeriodMin = 4;
  static const int idealPeriodMax = 5;
  static const int minCycleDays = 21;
  static const int maxCycleDays = 35;
  static const int avgCycleDays = 28;
  static const int lateThresholdDays = 7;
  static const int missedThresholdDays = 30;
  static const int warningCycleShort = 21;
  static const int warningCycleLong = 35;
  static const int amenorrheaMonths = 3;
}

class CycleUtils {
  static String getPhaseName(int cycleDay, int cycleLength) {
    final ovulationDay = cycleLength - 14;
    if (cycleDay <= 5) return 'Menstrual';
    if (cycleDay <= ovulationDay - 1) return 'Follicular';
    if (cycleDay == ovulationDay || cycleDay == ovulationDay + 1)
      return 'Ovulation';
    return 'Luteal';
  }

  static String getPhaseNameBn(int cycleDay, int cycleLength) {
    final ovulationDay = cycleLength - 14;
    if (cycleDay <= 5) return 'মাসিক';
    if (cycleDay <= ovulationDay - 1) return 'ফলিকুলার';
    if (cycleDay == ovulationDay || cycleDay == ovulationDay + 1)
      return 'ডিম্বস্ফোটন';
    return 'লুটিয়াল';
  }

  static String getPhaseEmoji(int cycleDay, int cycleLength) {
    final ovulationDay = cycleLength - 14;
    if (cycleDay <= 5) return '🩸';
    if (cycleDay <= ovulationDay - 1) return '🌱';
    if (cycleDay == ovulationDay || cycleDay == ovulationDay + 1) return '🟡';
    return '🍂';
  }

  static int calculateOvulationDay(int cycleLength) => cycleLength - 14;

  static int calculateFertileStart(int ovulationDay) =>
      (ovulationDay - 5).clamp(1, 100);

  static int calculateFertileEnd(int ovulationDay, int cycleLength) =>
      (ovulationDay + 1).clamp(1, cycleLength);

  static double calculateFertilityScore(int cycleDay, int cycleLength) {
    final ovulationDay = calculateOvulationDay(cycleLength);
    if (cycleDay == ovulationDay) return 100;
    if (cycleDay >= ovulationDay - 5 && cycleDay <= ovulationDay + 1) {
      return (100 - (ovulationDay - cycleDay).abs() * 15)
          .clamp(0, 100)
          .toDouble();
    }
    return 0;
  }

  static String getFertilityLabel(double score) {
    if (score >= 100) return 'Peak';
    if (score >= 70) return 'High';
    if (score >= 30) return 'Medium';
    return 'Low';
  }

  static String getFertilityLabelBn(double score) {
    if (score >= 100) return 'সর্বোচ্চ';
    if (score >= 70) return 'অধিক';
    if (score >= 30) return 'মধ্যম';
    return 'নিম্ন';
  }

  static String getFlowLabel(String intensity) {
    switch (intensity) {
      case 'spotting':
        return 'Spotting';
      case 'light':
        return 'Light (1-3 pads)';
      case 'medium':
        return 'Moderate (3-6 pads)';
      case 'heavy':
        return 'Heavy (6+ pads)';
      default:
        return intensity;
    }
  }

  static String getFlowLabelBn(String intensity) {
    switch (intensity) {
      case 'spotting':
        return 'দাগ';
      case 'light':
        return 'হালকা (১-৩ প্যাড)';
      case 'medium':
        return 'মধ্যম (৩-৬ প্যাড)';
      case 'heavy':
        return 'ভারী (৬+ প্যাড)';
      default:
        return intensity;
    }
  }

  static String getCycleStatusLabel(String status) {
    switch (status) {
      case 'upcoming':
        return 'আসন্ন';
      case 'today_expected':
        return 'আজ আসার সম্ভাবনা';
      case 'delayed':
        return 'দেরি হচ্ছে';
      case 'late':
        return 'দেরি';
      case 'missed':
        return 'মিসড';
      default:
        return status;
    }
  }

  static String getPeriodStatusMessage(int periodLength) {
    if (periodLength < MedicalRanges.minPeriodDays) {
      return '২ দিনের কম — ডাক্তার দেখানো উচিত';
    }
    if (periodLength > MedicalRanges.maxPeriodDays) {
      return '৭ দিনের বেশি — ডাক্তার দেখানো উচিত';
    }
    if (periodLength >= MedicalRanges.idealPeriodMin &&
        periodLength <= MedicalRanges.idealPeriodMax) {
      return '৪-৫ দিন — আদর্শ';
    }
    return 'স্বাভাবিক সীমার মধ্যে';
  }

  static String getPeriodStatusColor(int periodLength) {
    if (periodLength < MedicalRanges.minPeriodDays ||
        periodLength > MedicalRanges.maxPeriodDays)
      return 'red';
    if (periodLength >= MedicalRanges.idealPeriodMin &&
        periodLength <= MedicalRanges.idealPeriodMax)
      return 'green';
    return 'yellow';
  }

  static int calculateNextPeriodDate(DateTime lastPeriod, int avgCycleLength) {
    return DateTime(
      lastPeriod.year,
      lastPeriod.month,
      lastPeriod.day + avgCycleLength,
    ).millisecondsSinceEpoch;
  }

  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return to.difference(from).inDays;
  }

  static bool isLatePeriod(DateTime expectedDate) {
    final today = DateTime.now();
    final diff = daysBetween(expectedDate, today);
    return diff > MedicalRanges.lateThresholdDays;
  }

  static bool isMissedPeriod(DateTime expectedDate) {
    final today = DateTime.now();
    final diff = daysBetween(expectedDate, today);
    return diff > MedicalRanges.missedThresholdDays;
  }

  static Map<String, dynamic> getPhaseInsight(String phase) {
    final insights = {
      'menstrual': {
        'title': 'আপনার পিরিয়ড চলছে',
        'tip': 'বিশ্রাম নিন, হিট প্যাড ব্যবহার করুন',
        'food': 'আয়রন সমৃদ্ধ খাবার খান',
        'exercise': 'হালকা স্ট্রেচিং করুন',
        'mood': 'বিরক্তি লাগতে পারে',
        'color': 0xFF810B38,
      },
      'follicular': {
        'title': 'ফলিকুলার ফেজ',
        'tip': 'নতুন শক্তি আসছে 🌱',
        'food': 'প্রোটিন সমৃদ্ধ খাবার',
        'exercise': 'মাঝারি ব্যায়াম ভালো',
        'mood': 'শক্তিশালী ও উদ্যমী',
        'color': 0xFFFF97D0,
      },
      'ovulation': {
        'title': 'ডিম্বস্ফোটন চলছে',
        'tip': 'সর্বোচ্চ উর্বর সময় 💫',
        'food': 'স্বাস্থ্যকর খাবার',
        'exercise': 'শক্তি অনুযায়ী ব্যায়াম',
        'mood': 'সবচেয়ে উদ্যমী',
        'color': 0xFFF0E76F,
      },
      'luteal': {
        'title': 'লুটিয়াল ফেজ',
        'tip': 'আস্তে চলুন, শরীর প্রস্তুতি নিচ্ছে 🍂',
        'food': 'ম্যাগনেসিয়াম ও ভিটামিন বি৬ নিন',
        'exercise': 'হালকা যোগব্যায়াম',
        'mood': 'PMS উপসর্গ দেখা দিতে পারে',
        'color': 0xFF744577,
      },
    };
    return insights[phase] ?? insights['menstrual']!;
  }

  static int getPhaseColor(String phase) {
    switch (phase) {
      case 'menstrual':
        return 0xFF810B38;
      case 'follicular':
        return 0xFFFF97D0;
      case 'ovulation':
        return 0xFFF0E76F;
      case 'luteal':
        return 0xFF744577;
      default:
        return 0xFFFF97D0;
    }
  }

  static int getPhaseProgress(int cycleDay, int cycleLength) {
    return ((cycleDay / cycleLength) * 100).round().clamp(0, 100);
  }

  static Map<String, dynamic> calculateFertileWindow(int cycleLength) {
    final ovulationDay = calculateOvulationDay(cycleLength);
    return {
      'ovulationDay': ovulationDay,
      'fertileStart': calculateFertileStart(ovulationDay),
      'fertileEnd': calculateFertileEnd(ovulationDay, cycleLength),
      'fertileDays': 7,
    };
  }
}
