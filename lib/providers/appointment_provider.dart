import 'package:flutter/material.dart';
import '../data/repositories/appointment_repository.dart';

class AppointmentProvider extends ChangeNotifier {
  final AppointmentRepository _repository = AppointmentRepository();

  List<Map<String, dynamic>> _appointments = [];
  List<Map<String, dynamic>> _upcoming = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get appointments => _appointments;
  List<Map<String, dynamic>> get upcoming => _upcoming;
  bool get isLoading => _isLoading;

  Future<void> loadAppointments() async {
    _isLoading = true;
    notifyListeners();
    try {
      final r = await _repository.getAppointments(limit: 50);
      _appointments = List<Map<String, dynamic>>.from(r['data'] ?? []);
    } catch (_) {}
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadUpcoming() async {
    try {
      final r = await _repository.getUpcoming();
      _upcoming = List<Map<String, dynamic>>.from(r['data'] ?? []);
      notifyListeners();
    } catch (_) {}
  }

  Future<bool> createAppointment(Map<String, dynamic> data) async {
    try {
      await _repository.createAppointment(data);
      await loadAppointments();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteAppointment(String id) async {
    try {
      await _repository.deleteAppointment(id);
      await loadAppointments();
      return true;
    } catch (_) {
      return false;
    }
  }
}
