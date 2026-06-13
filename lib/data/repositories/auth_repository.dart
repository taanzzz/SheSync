import 'dart:convert';
import '../remote/datasources/auth_remote_datasource.dart';
import '../local/secure_storage_service.dart';

class AuthRepository {
  final AuthRemoteDataSource _dataSource = AuthRemoteDataSource();
  final SecureStorageService _storage = SecureStorageService();

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _dataSource.login(email, password);
    final data = response['data'];
    await _storage.saveToken(data['accessToken']);
    await _storage.saveRefreshToken(data['refreshToken']);
    await _storage.saveUserData(jsonEncode(data['user']));
    return response;
  }

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    final response = await _dataSource.register(name, email, password);
    final data = response['data'];
    await _storage.saveToken(data['accessToken']);
    await _storage.saveRefreshToken(data['refreshToken']);
    if (data['user'] != null) {
      await _storage.saveUserData(jsonEncode(data['user']));
    }
    return response;
  }

  Future<void> logout() async {
    final refreshToken = await _storage.getRefreshToken();
    if (refreshToken != null) {
      try {
        await _dataSource.logout(refreshToken);
      } catch (_) {}
    }
    await _storage.clearAll();
  }

  Future<String?> getToken() => _storage.getToken();

  Future<bool> isLoggedIn() async => await _storage.getToken() != null;

  Future<Map<String, dynamic>?> getUser() async {
    final data = await _storage.getUserData();
    if (data != null) {
      try {
        return jsonDecode(data);
      } catch (_) {}
    }
    return null;
  }
}
