import 'package:flutter/material.dart';
import '../data/repositories/symptom_repository.dart';

class SymptomProvider extends ChangeNotifier {
  final SymptomRepository _repository = SymptomRepository();

  List<Map<String, dynamic>> _symptoms = [];
  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get symptoms => _symptoms;
  List<Map<String, dynamic>> get categories => _categories;
  bool get isLoading => _isLoading;

  Future<void> loadSymptoms() async {
    _isLoading = true;
    notifyListeners();
    try {
      final r = await _repository.getHistory(limit: 50);
      _symptoms = List<Map<String, dynamic>>.from(r['data'] ?? []);
    } catch (_) {}
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadCategories() async {
    try {
      final r = await _repository.getCategories();
      _categories = List<Map<String, dynamic>>.from(r['data'] ?? []);
      notifyListeners();
    } catch (_) {}
  }

  Future<bool> logSymptoms(Map<String, dynamic> data) async {
    try {
      await _repository.logSymptoms(data);
      await loadSymptoms();
      return true;
    } catch (_) {
      return false;
    }
  }
}
