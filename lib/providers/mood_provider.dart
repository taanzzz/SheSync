import 'package:flutter/material.dart';
import '../data/repositories/mood_repository.dart';

class MoodProvider extends ChangeNotifier {
  final MoodRepository _repository = MoodRepository();

  Map<String, dynamic>? _todayMood;
  Map<String, dynamic>? _weeklyTrend;
  Map<String, dynamic>? _monthlyTrend;
  Map<String, dynamic>? _cycleMoodCorrelation;
  bool _isLoading = false;

  Map<String, dynamic>? get todayMood => _todayMood;
  Map<String, dynamic>? get weeklyTrend => _weeklyTrend;
  Map<String, dynamic>? get monthlyTrend => _monthlyTrend;
  Map<String, dynamic>? get cycleMoodCorrelation => _cycleMoodCorrelation;
  bool get isLoading => _isLoading;

  String? get todayMoodValue => _todayMood?['mood'];
  int? get todayMoodScore => _todayMood?['score'];

  List<Map<String, dynamic>> get weeklyDays {
    final days = _weeklyTrend?['days'];
    if (days == null) return [];
    return List<Map<String, dynamic>>.from(days);
  }

  Future<void> saveMood(String mood, int score, {String? note}) async {
    try {
      final r = await _repository.saveMood({
        'mood': mood,
        'score': score,
        if (note != null) 'note': note,
        'date': DateTime.now().toIso8601String(),
      });
      _todayMood = r['data'];
      notifyListeners();
    } catch (_) {}
  }

  Future<void> loadTodayMood() async {
    try {
      final r = await _repository.getTodayMood();
      _todayMood = r['data'];
      notifyListeners();
    } catch (_) {}
  }

  Future<void> loadWeeklyTrend() async {
    try {
      final r = await _repository.getWeeklyTrend();
      _weeklyTrend = r['data'];
      notifyListeners();
    } catch (_) {}
  }

  Future<void> loadMonthlyTrend() async {
    try {
      final r = await _repository.getMonthlyTrend();
      _monthlyTrend = r['data'];
      notifyListeners();
    } catch (_) {}
  }

  Future<void> loadCycleMoodCorrelation() async {
    try {
      final r = await _repository.getCycleMoodCorrelation();
      _cycleMoodCorrelation = r['data'];
      notifyListeners();
    } catch (_) {}
  }

  Future<void> loadAll() async {
    _isLoading = true;
    notifyListeners();
    await Future.wait([
      loadTodayMood(),
      loadWeeklyTrend(),
    ]);
    _isLoading = false;
    notifyListeners();
  }
}
