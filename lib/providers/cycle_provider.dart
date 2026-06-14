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

  Map<String, dynamic>? _dashboard;
  List<Map<String, dynamic>> _alerts = [];
  Map<String, dynamic>? _fertility;
  Map<String, dynamic>? _calendarData;
  Map<String, dynamic>? _config;

  Map<String, dynamic>? get dashboard => _dashboard;
  List<Map<String, dynamic>> get alerts => _alerts;
  Map<String, dynamic>? get fertility => _fertility;
  Map<String, dynamic>? get calendarData => _calendarData;
  Map<String, dynamic>? get config => _config;

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
      await loadDashboard();
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
      await loadDashboard();
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
      await loadDashboard();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> loadDashboard() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _repository.getDashboard();
      _dashboard = response['data'];
      _alerts = List<Map<String, dynamic>>.from(
        response['data']?['alerts'] ?? [],
      );
      _prediction = response['data']?['prediction'];
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadAlerts() async {
    try {
      final response = await _repository.getCycleAlerts();
      _alerts = List<Map<String, dynamic>>.from(response['data'] ?? []);
      notifyListeners();
    } catch (_) {}
  }

  Future<void> loadFertility() async {
    try {
      final response = await _repository.getFertilityPrediction();
      _fertility = response['data'];
      notifyListeners();
    } catch (_) {}
  }

  Future<void> loadPremiumCalendar(int month, int year) async {
    try {
      final response = await _repository.getPremiumCalendar(month, year);
      _calendarData = response['data'];
      notifyListeners();
    } catch (_) {}
  }

  Future<void> loadConfig() async {
    try {
      final response = await _repository.getConfig();
      _config = response['data'];
      notifyListeners();
    } catch (_) {}
  }

  Future<bool> saveConfig(Map<String, dynamic> data) async {
    try {
      final response = await _repository.saveConfig(data);
      _config = response['data'];
      await loadDashboard();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
