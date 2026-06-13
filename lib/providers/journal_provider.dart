import 'package:flutter/material.dart';
import '../data/repositories/journal_repository.dart';

class JournalProvider extends ChangeNotifier {
  final JournalRepository _repository = JournalRepository();

  List<Map<String, dynamic>> _journals = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get journals => _journals;
  bool get isLoading => _isLoading;

  Future<void> loadJournals() async {
    _isLoading = true;
    notifyListeners();
    try {
      final r = await _repository.getJournals(limit: 50);
      _journals = List<Map<String, dynamic>>.from(r['data'] ?? []);
    } catch (_) {}
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createJournal(Map<String, dynamic> data) async {
    try {
      await _repository.createJournal(data);
      await loadJournals();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteJournal(String id) async {
    try {
      await _repository.deleteJournal(id);
      await loadJournals();
      return true;
    } catch (_) {
      return false;
    }
  }
}
