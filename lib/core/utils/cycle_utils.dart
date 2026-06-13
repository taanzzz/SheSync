class CycleUtils {
  static String getPhaseName(int cycleDay, int cycleLength) {
    final ovulationDay = cycleLength - 14;
    if (cycleDay <= 5) return 'Menstrual';
    if (cycleDay <= ovulationDay - 1) return 'Follicular';
    if (cycleDay == ovulationDay || cycleDay == ovulationDay + 1) {
      return 'Ovulation';
    }
    return 'Luteal';
  }

  static int calculateOvulationDay(int cycleLength) => cycleLength - 14;

  static int calculateFertileStart(int ovulationDay) => ovulationDay - 5;

  static int calculateFertileEnd(int ovulationDay) => ovulationDay + 1;

  static double calculateFertilityScore(int cycleDay, int cycleLength) {
    final ovulationDay = calculateOvulationDay(cycleLength);
    if (cycleDay == ovulationDay) return 100;
    if (cycleDay >= ovulationDay - 5 && cycleDay <= ovulationDay + 1) {
      return 100 - (ovulationDay - cycleDay).abs() * 15;
    }
    return 0;
  }
}
