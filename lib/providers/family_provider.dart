import 'package:flutter/material.dart';
import '../data/repositories/family_repository.dart';

class FamilyProvider extends ChangeNotifier {
  final FamilyRepository _repository = FamilyRepository();

  List<Map<String, dynamic>> _profiles = [];
  String? _activeProfileId;
  bool _isLoading = false;

  List<Map<String, dynamic>> get profiles => _profiles;
  String? get activeProfileId => _activeProfileId;
  bool get isLoading => _isLoading;

  Future<void> loadProfiles() async {
    _isLoading = true;
    notifyListeners();
    try {
      final r = await _repository.getProfiles();
      _profiles = List<Map<String, dynamic>>.from(r['data'] ?? []);
    } catch (_) {}
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createProfile(Map<String, dynamic> data) async {
    try {
      await _repository.createProfile(data);
      await loadProfiles();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> switchProfile(String id) async {
    try {
      await _repository.switchProfile(id);
      _activeProfileId = id;
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteProfile(String id) async {
    try {
      await _repository.deleteProfile(id);
      await loadProfiles();
      return true;
    } catch (_) {
      return false;
    }
  }
}
