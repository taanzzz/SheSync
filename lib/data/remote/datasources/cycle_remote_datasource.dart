import '../api/api_client.dart';
import '../../../core/constants/api_endpoints.dart';

class CycleRemoteDataSource {
  final ApiClient _client = ApiClient();

  Future<Map<String, dynamic>> createCycle(Map<String, dynamic> data) =>
      _client.post(ApiEndpoints.cycles, data: data);

  Future<Map<String, dynamic>> getCycles({int page = 1, int limit = 10}) =>
      _client.get(
        ApiEndpoints.cycles,
        queryParams: {'page': page, 'limit': limit},
      );

  Future<Map<String, dynamic>> getPrediction() =>
      _client.get(ApiEndpoints.cyclePrediction);

  Future<Map<String, dynamic>> getCalendarData(int month, int year) =>
      _client.get(
        ApiEndpoints.cycleCalendar,
        queryParams: {'month': month, 'year': year},
      );

  Future<Map<String, dynamic>> getStatistics() =>
      _client.get(ApiEndpoints.cycleStatistics);

  Future<Map<String, dynamic>> updateCycle(
    String id,
    Map<String, dynamic> data,
  ) => _client.put('${ApiEndpoints.cycles}/$id', data: data);

  Future<Map<String, dynamic>> deleteCycle(String id) =>
      _client.delete('${ApiEndpoints.cycles}/$id');
}
