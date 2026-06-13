import '../api/api_client.dart';
import '../../../core/constants/api_endpoints.dart';

class VitalsRemoteDataSource {
  final ApiClient _client = ApiClient();

  Future<Map<String, dynamic>> createVitals(Map<String, dynamic> data) =>
      _client.post(ApiEndpoints.vitals, data: data);

  Future<Map<String, dynamic>> getVitalsHistory({
    int page = 1,
    int limit = 10,
  }) => _client.get(
    ApiEndpoints.vitals,
    queryParams: {'page': page, 'limit': limit},
  );

  Future<Map<String, dynamic>> getByDate(String date) =>
      _client.get('${ApiEndpoints.vitals}/date/$date');

  Future<Map<String, dynamic>> getChartData() =>
      _client.get(ApiEndpoints.vitalsCharts);

  Future<Map<String, dynamic>> updateVitals(
    String id,
    Map<String, dynamic> data,
  ) => _client.put('${ApiEndpoints.vitals}/$id', data: data);

  Future<Map<String, dynamic>> deleteVitals(String id) =>
      _client.delete('${ApiEndpoints.vitals}/$id');
}
