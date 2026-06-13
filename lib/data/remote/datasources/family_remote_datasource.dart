import '../api/api_client.dart';
import '../../../core/constants/api_endpoints.dart';

class FamilyRemoteDataSource {
  final ApiClient _client = ApiClient();

  Future<Map<String, dynamic>> createProfile(Map<String, dynamic> data) =>
      _client.post(ApiEndpoints.familyProfiles, data: data);

  Future<Map<String, dynamic>> getProfiles() =>
      _client.get(ApiEndpoints.familyProfiles);

  Future<Map<String, dynamic>> getProfile(String id) =>
      _client.get('${ApiEndpoints.familyProfiles}/$id');

  Future<Map<String, dynamic>> updateProfile(
    String id,
    Map<String, dynamic> data,
  ) => _client.put('${ApiEndpoints.familyProfiles}/$id', data: data);

  Future<Map<String, dynamic>> deleteProfile(String id) =>
      _client.delete('${ApiEndpoints.familyProfiles}/$id');

  Future<Map<String, dynamic>> switchProfile(String id) =>
      _client.put('${ApiEndpoints.familyProfiles}/$id/switch');
}
