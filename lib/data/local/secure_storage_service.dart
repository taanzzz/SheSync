import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) =>
      _storage.write(key: 'access_token', value: token);
  Future<void> saveRefreshToken(String token) =>
      _storage.write(key: 'refresh_token', value: token);
  Future<String?> getToken() => _storage.read(key: 'access_token');
  Future<String?> getRefreshToken() => _storage.read(key: 'refresh_token');
  Future<void> saveUserData(String data) =>
      _storage.write(key: 'user_data', value: data);
  Future<String?> getUserData() => _storage.read(key: 'user_data');
  Future<void> clearAll() => _storage.deleteAll();
}
