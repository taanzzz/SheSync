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

  Future<Map<String, dynamic>> getDashboard() =>
      _client.get(ApiEndpoints.cycleDashboard);

  Future<Map<String, dynamic>> getCycleAlerts() =>
      _client.get(ApiEndpoints.cycleAlerts);

  Future<Map<String, dynamic>> getFertilityPrediction() =>
      _client.get(ApiEndpoints.cycleFertility);

  Future<Map<String, dynamic>> getPremiumCalendar(int month, int year) =>
      _client.get(
        ApiEndpoints.cyclePremiumCalendar,
        queryParams: {'month': month, 'year': year},
      );

  Future<Map<String, dynamic>> getConfig() =>
      _client.get(ApiEndpoints.cycleConfig);

  Future<Map<String, dynamic>> saveConfig(Map<String, dynamic> data) =>
      _client.put(ApiEndpoints.cycleConfig, data: data);
}
