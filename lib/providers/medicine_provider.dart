import 'package:flutter/material.dart';
import '../data/repositories/medicine_repository.dart';

class MedicineProvider extends ChangeNotifier {
  final MedicineRepository _repository = MedicineRepository();

  List<Map<String, dynamic>> _medicines = [];
  List<Map<String, dynamic>> _todaysMedicines = [];
  Map<String, dynamic>? _adherence;
  bool _isLoading = false;

  List<Map<String, dynamic>> get medicines => _medicines;
  List<Map<String, dynamic>> get todaysMedicines => _todaysMedicines;
  Map<String, dynamic>? get adherence => _adherence;
  bool get isLoading => _isLoading;

  Future<void> loadMedicines() async {
    _isLoading = true;
    notifyListeners();
    try {
      final r = await _repository.getMedicines();
      _medicines = List<Map<String, dynamic>>.from(r['data'] ?? []);
    } catch (_) {}
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadTodaysMedicines() async {
    try {
      final r = await _repository.getTodaysMedicines();
      _todaysMedicines = List<Map<String, dynamic>>.from(r['data'] ?? []);
      notifyListeners();
    } catch (_) {}
  }

  Future<void> loadAdherence() async {
    try {
      final r = await _repository.getAdherence();
      _adherence = r['data'];
      notifyListeners();
    } catch (_) {}
  }

  Future<bool> createMedicine(Map<String, dynamic> data) async {
    try {
      await _repository.createMedicine(data);
      await loadMedicines();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteMedicine(String id) async {
    try {
      await _repository.deleteMedicine(id);
      await loadMedicines();
      return true;
    } catch (_) {
      return false;
    }
  }
}
