import 'package:flutter/material.dart';
import '../data/repositories/weight_repository.dart';

class WeightProvider extends ChangeNotifier {
  final WeightRepository _repository = WeightRepository();

  List<Map<String, dynamic>> _history = [];
  Map<String, dynamic>? _trend;
  Map<String, dynamic>? _bmiResult;
  bool _isLoading = false;

  List<Map<String, dynamic>> get history => _history;
  Map<String, dynamic>? get trend => _trend;
  Map<String, dynamic>? get bmiResult => _bmiResult;
  bool get isLoading => _isLoading;

  double? get currentWeight => _trend?['current']?.toDouble();
  double? get weeklyChange => _trend?['weeklyChange']?.toDouble();
  double? get monthlyChange => _trend?['monthlyChange']?.toDouble();

  Future<void> logWeight(double weight, {String unit = 'kg'}) async {
    try {
      await _repository.logWeight({
        'weight': weight,
        'unit': unit,
        'date': DateTime.now().toIso8601String(),
      });
      await loadAll();
    } catch (_) {}
  }

  Future<void> loadHistory({int limit = 30}) async {
    try {
      final r = await _repository.getWeightHistory(limit: limit);
      _history = List<Map<String, dynamic>>.from(r['data'] ?? []);
      notifyListeners();
    } catch (_) {}
  }

  Future<void> loadTrend() async {
    try {
      final r = await _repository.getWeightTrend();
      _trend = r['data'];
      notifyListeners();
    } catch (_) {}
  }

  Future<void> calculateBMI(double weight, double heightCm) async {
    try {
      final r = await _repository.calculateBMI({
        'weight': weight,
        'height': heightCm,
      });
      _bmiResult = r['data'];
      notifyListeners();
    } catch (_) {}
  }

  Future<void> loadAll() async {
    _isLoading = true;
    notifyListeners();
    await Future.wait([loadHistory(), loadTrend()]);
    _isLoading = false;
    notifyListeners();
  }
}
