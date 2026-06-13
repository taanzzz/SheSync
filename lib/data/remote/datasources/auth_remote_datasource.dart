import '../api/api_client.dart';
import '../../../core/constants/api_endpoints.dart';

class AuthRemoteDataSource {
  final ApiClient _client = ApiClient();

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    return _client.post(
      ApiEndpoints.register,
      data: {'name': name, 'email': email, 'password': password},
    );
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    return _client.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );
  }

  Future<Map<String, dynamic>> logout(String refreshToken) async {
    return _client.post(
      ApiEndpoints.logout,
      data: {'refreshToken': refreshToken},
    );
  }

  Future<Map<String, dynamic>> refreshToken(String token) async {
    return _client.post(
      ApiEndpoints.refreshToken,
      data: {'refreshToken': token},
    );
  }

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    return _client.post(ApiEndpoints.forgotPassword, data: {'email': email});
  }

  Future<Map<String, dynamic>> resetPassword(
    String email,
    String otp,
    String newPassword,
  ) async {
    return _client.post(
      ApiEndpoints.resetPassword,
      data: {'email': email, 'otp': otp, 'newPassword': newPassword},
    );
  }

  Future<Map<String, dynamic>> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    return _client.put(
      ApiEndpoints.changePassword,
      data: {'currentPassword': currentPassword, 'newPassword': newPassword},
    );
  }
}
