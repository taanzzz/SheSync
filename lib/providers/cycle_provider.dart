import 'package:flutter/material.dart';
import '../data/repositories/cycle_repository.dart';

class CycleProvider extends ChangeNotifier {
  final CycleRepository _repository = CycleRepository();

  Map<String, dynamic>? _currentCycle;
  Map<String, dynamic>? _prediction;
  List<Map<String, dynamic>> _cycles = [];
  Map<String, dynamic>? _statistics;
  bool _isLoading = false;
  String? _error;

  Map<String, dynamic>? get currentCycle => _currentCycle;
  Map<String, dynamic>? get prediction => _prediction;
  List<Map<String, dynamic>> get cycles => _cycles;
  Map<String, dynamic>? get statistics => _statistics;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCycles() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _repository.getCycles(limit: 50);
      _cycles = List<Map<String, dynamic>>.from(response['data'] ?? []);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadPrediction() async {
    try {
      final response = await _repository.getPrediction();
      _prediction = response['data'];
      notifyListeners();
    } catch (_) {}
  }

  Future<void> loadStatistics() async {
    try {
      final response = await _repository.getStatistics();
      _statistics = response['data'];
      notifyListeners();
    } catch (_) {}
  }

  Future<bool> createCycle(Map<String, dynamic> data) async {
    try {
      await _repository.createCycle(data);
      await loadCycles();
      await loadPrediction();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateCycle(String id, Map<String, dynamic> data) async {
    try {
      await _repository.updateCycle(id, data);
      await loadCycles();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteCycle(String id) async {
    try {
      await _repository.deleteCycle(id);
      await loadCycles();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
