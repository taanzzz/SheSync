import 'package:flutter/material.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/family_repository.dart';
import '../core/errors/app_exception.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  final FamilyRepository _familyRepository = FamilyRepository();

  AuthStatus _status = AuthStatus.initial;
  String? _errorMessage;
  Map<String, dynamic>? _user;
  List<Map<String, dynamic>> _profiles = [];

  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get user => _user;
  List<Map<String, dynamic>> get profiles => _profiles;

  Future<void> checkAuth() async {
    final loggedIn = await _authRepository.isLoggedIn();
    if (loggedIn) {
      _user = await _authRepository.getUser();
    }
    _status = loggedIn ? AuthStatus.authenticated : AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    try {
      _status = AuthStatus.loading;
      notifyListeners();
      final response = await _authRepository.login(email, password);
      _user = response['data']['user'];
      _status = AuthStatus.authenticated;
      _errorMessage = null;
      notifyListeners();
      return true;
    } on AppException catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.message;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      _status = AuthStatus.loading;
      notifyListeners();
      final response = await _authRepository.register(name, email, password);
      _user = response['data']['user'];
      _status = AuthStatus.authenticated;
      _errorMessage = null;
      notifyListeners();
      return true;
    } on AppException catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.message;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    _status = AuthStatus.unauthenticated;
    _user = null;
    _profiles = [];
    notifyListeners();
  }

  Future<void> loadProfiles() async {
    try {
      final response = await _familyRepository.getProfiles();
      _profiles = List<Map<String, dynamic>>.from(response['data'] ?? []);
      notifyListeners();
    } catch (_) {}
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
