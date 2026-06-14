import 'package:flutter/material.dart';
import '../data/repositories/analytics_repository.dart';

class AnalyticsProvider extends ChangeNotifier {
  final AnalyticsRepository _repository = AnalyticsRepository();

  Map<String, dynamic>? _healthScore;
  Map<String, dynamic>? _dashboard;
  bool _isLoading = false;

  Map<String, dynamic>? get healthScore => _healthScore;
  Map<String, dynamic>? get dashboard => _dashboard;
  bool get isLoading => _isLoading;

  int get overallScore => _healthScore?['overall'] ?? 0;
  String get grade => _healthScore?['grade'] ?? 'N/A';
  Map<String, dynamic> get breakdown => Map<String, dynamic>.from(_healthScore?['breakdown'] ?? {});

  Future<void> loadHealthScore() async {
    try {
      final r = await _repository.getHealthScore();
      _healthScore = r['data'];
      notifyListeners();
    } catch (_) {}
  }

  Future<void> loadDashboard() async {
    _isLoading = true;
    notifyListeners();
    try {
      final r = await _repository.getDashboardAnalytics();
      _dashboard = r['data'];
      _healthScore = _dashboard?['healthScore'];
    } catch (_) {}
    _isLoading = false;
    notifyListeners();
  }
}
