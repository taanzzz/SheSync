import '../api/api_client.dart';
import '../../../core/constants/api_endpoints.dart';

class SymptomRemoteDataSource {
  final ApiClient _client = ApiClient();

  Future<Map<String, dynamic>> logSymptoms(Map<String, dynamic> data) =>
      _client.post(ApiEndpoints.symptoms, data: data);

  Future<Map<String, dynamic>> getHistory({int page = 1, int limit = 10}) =>
      _client.get(
        ApiEndpoints.symptoms,
        queryParams: {'page': page, 'limit': limit},
      );

  Future<Map<String, dynamic>> getByDate(String date) =>
      _client.get('${ApiEndpoints.symptoms}/date/$date');

  Future<Map<String, dynamic>> getCategories() =>
      _client.get(ApiEndpoints.symptomCategories);

  Future<Map<String, dynamic>> getFrequency() =>
      _client.get(ApiEndpoints.symptomFrequency);

  Future<Map<String, dynamic>> updateLog(
    String id,
    Map<String, dynamic> data,
  ) => _client.put('${ApiEndpoints.symptoms}/$id', data: data);

  Future<Map<String, dynamic>> deleteLog(String id) =>
      _client.delete('${ApiEndpoints.symptoms}/$id');
}
