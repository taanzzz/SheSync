import 'package:flutter/material.dart';
import '../data/repositories/vitals_repository.dart';

class VitalsProvider extends ChangeNotifier {
  final VitalsRepository _repository = VitalsRepository();

  List<Map<String, dynamic>> _vitalsList = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get vitalsList => _vitalsList;
  bool get isLoading => _isLoading;

  Future<void> loadVitals() async {
    _isLoading = true;
    notifyListeners();
    try {
      final r = await _repository.getVitalsHistory(limit: 50);
      _vitalsList = List<Map<String, dynamic>>.from(r['data'] ?? []);
    } catch (_) {}
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createVitals(Map<String, dynamic> data) async {
    try {
      await _repository.createVitals(data);
      await loadVitals();
      return true;
    } catch (_) {
      return false;
    }
  }
}
