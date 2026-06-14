import '../api/api_client.dart';
import '../../../core/constants/api_endpoints.dart';

class MoodRemoteDataSource {
  final ApiClient _client = ApiClient();

  Future<Map<String, dynamic>> saveMood(Map<String, dynamic> data) =>
      _client.post(ApiEndpoints.moods, data: data);

  Future<Map<String, dynamic>> getTodayMood() =>
      _client.get(ApiEndpoints.moodToday);

  Future<Map<String, dynamic>> getWeeklyTrend() =>
      _client.get(ApiEndpoints.moodWeekly);

  Future<Map<String, dynamic>> getMonthlyTrend() =>
      _client.get(ApiEndpoints.moodMonthly);

  Future<Map<String, dynamic>> getCycleMoodCorrelation() =>
      _client.get(ApiEndpoints.moodCycleCorrelation);
}
