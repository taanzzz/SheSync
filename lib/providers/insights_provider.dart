import 'package:flutter/material.dart';
import '../data/repositories/insights_repository.dart';

class InsightsProvider extends ChangeNotifier {
  final InsightsRepository _repository = InsightsRepository();

  List<Map<String, dynamic>> _insights = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get insights => _insights;
  bool get isLoading => _isLoading;

  Future<void> loadInsights() async {
    _isLoading = true;
    notifyListeners();
    try {
      final r = await _repository.getSmartInsights();
      _insights = List<Map<String, dynamic>>.from(r['data'] ?? []);
    } catch (_) {}
    _isLoading = false;
    notifyListeners();
  }
}
