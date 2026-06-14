import '../api/api_client.dart';
import '../../../core/constants/api_endpoints.dart';

class WaterRemoteDataSource {
  final ApiClient _client = ApiClient();

  Future<Map<String, dynamic>> getConfig() =>
      _client.get(ApiEndpoints.waterConfig);

  Future<Map<String, dynamic>> saveConfig(Map<String, dynamic> data) =>
      _client.put(ApiEndpoints.waterConfig, data: data);

  Future<Map<String, dynamic>> logWater(Map<String, dynamic> data) =>
      _client.post(ApiEndpoints.waterLog, data: data);

  Future<Map<String, dynamic>> removeLastEntry() =>
      _client.delete(ApiEndpoints.waterLogLast);

  Future<Map<String, dynamic>> getTodayProgress() =>
      _client.get(ApiEndpoints.waterToday);

  Future<Map<String, dynamic>> getWeeklyStats() =>
      _client.get(ApiEndpoints.waterWeekly);

  Future<Map<String, dynamic>> getMonthlyStats() =>
      _client.get(ApiEndpoints.waterMonthly);

  Future<Map<String, dynamic>> getStreak() =>
      _client.get(ApiEndpoints.waterStreak);
}
