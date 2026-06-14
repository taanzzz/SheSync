import 'package:flutter/material.dart';
import '../data/repositories/water_repository.dart';

class WaterProvider extends ChangeNotifier {
  final WaterRepository _repository = WaterRepository();

  Map<String, dynamic>? _config;
  Map<String, dynamic>? _todayProgress;
  Map<String, dynamic>? _weeklyStats;
  Map<String, dynamic>? _monthlyStats;
  int _streak = 0;
  int _hydrationScore = 0;
  bool _isLoading = false;

  Map<String, dynamic>? get config => _config;
  Map<String, dynamic>? get todayProgress => _todayProgress;
  Map<String, dynamic>? get weeklyStats => _weeklyStats;
  Map<String, dynamic>? get monthlyStats => _monthlyStats;
  int get streak => _streak;
  int get hydrationScore => _hydrationScore;
  bool get isLoading => _isLoading;

  int get glasses => _todayProgress?['glasses'] ?? 0;
  int get totalMl => _todayProgress?['totalMl'] ?? 0;
  int get goalMl => _todayProgress?['goalMl'] ?? 2000;
  int get percentage => _todayProgress?['percentage'] ?? 0;
  int get remaining => _todayProgress?['remaining'] ?? 2000;
  bool get goalMet => _todayProgress?['goalMet'] ?? false;
  bool get isConfigured => _config?['isConfigured'] ?? false;
  int get glassSize => _config?['glassSize'] ?? _todayProgress?['glassSize'] ?? 250;

  Future<void> loadConfig() async {
    try {
      final r = await _repository.getConfig();
      _config = r['data'];
      notifyListeners();
    } catch (_) {}
  }

  Future<void> saveConfig(Map<String, dynamic> data) async {
    try {
      final r = await _repository.saveConfig(data);
      _config = r['data'];
      notifyListeners();
      await loadTodayProgress();
    } catch (_) {}
  }

  Future<void> logWater({int? amount, int? glassSize}) async {
    try {
      final r = await _repository.logWater({
        if (amount != null) 'amount': amount,
        if (glassSize != null) 'glassSize': glassSize,
      });
      _todayProgress = r['data'];
      notifyListeners();
    } catch (_) {}
  }

  Future<void> removeLastEntry() async {
    try {
      final r = await _repository.removeLastEntry();
      if (r['data'] != null) {
        _todayProgress = r['data'];
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> loadTodayProgress() async {
    try {
      final r = await _repository.getTodayProgress();
      _todayProgress = r['data'];
      notifyListeners();
    } catch (_) {}
  }

  Future<void> loadWeeklyStats() async {
    try {
      final r = await _repository.getWeeklyStats();
      _weeklyStats = r['data'];
      notifyListeners();
    } catch (_) {}
  }

  Future<void> loadMonthlyStats() async {
    try {
      final r = await _repository.getMonthlyStats();
      _monthlyStats = r['data'];
      notifyListeners();
    } catch (_) {}
  }

  Future<void> loadStreak() async {
    try {
      final r = await _repository.getStreak();
      _streak = r['data']?['current'] ?? 0;
      notifyListeners();
    } catch (_) {}
  }

  Future<void> loadAll() async {
    _isLoading = true;
    notifyListeners();
    await Future.wait([
      loadConfig(),
      loadTodayProgress(),
      loadStreak(),
    ]);
    _isLoading = false;
    notifyListeners();
  }
}
