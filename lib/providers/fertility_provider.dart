import 'package:flutter/material.dart';
import '../data/repositories/fertility_repository.dart';

class FertilityProvider extends ChangeNotifier {
  final FertilityRepository _repository = FertilityRepository();

  Map<String, dynamic>? _fertilityWindow;
  List<Map<String, dynamic>> _bbtLogs = [];
  List<Map<String, dynamic>> _mucusLogs = [];
  bool _isLoading = false;

  Map<String, dynamic>? get fertilityWindow => _fertilityWindow;
  List<Map<String, dynamic>> get bbtLogs => _bbtLogs;
  List<Map<String, dynamic>> get mucusLogs => _mucusLogs;
  bool get isLoading => _isLoading;

  Future<void> loadFertilityWindow({int? avgCycleLength}) async {
    _isLoading = true;
    notifyListeners();
    try {
      final r = await _repository.getFertilityWindow(
        avgCycleLength: avgCycleLength,
      );
      _fertilityWindow = r['data'];
    } catch (_) {}
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadBBTHistory() async {
    try {
      final r = await _repository.getBBTHistory();
      _bbtLogs = List<Map<String, dynamic>>.from(r['data'] ?? []);
      notifyListeners();
    } catch (_) {}
  }

  Future<void> loadMucusHistory() async {
    try {
      final r = await _repository.getMucusHistory();
      _mucusLogs = List<Map<String, dynamic>>.from(r['data'] ?? []);
      notifyListeners();
    } catch (_) {}
  }

  Future<bool> logBBT(Map<String, dynamic> data) async {
    try {
      await _repository.logBBT(data);
      await loadBBTHistory();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> logMucus(Map<String, dynamic> data) async {
    try {
      await _repository.logMucus(data);
      await loadMucusHistory();
      return true;
    } catch (_) {
      return false;
    }
  }
}
