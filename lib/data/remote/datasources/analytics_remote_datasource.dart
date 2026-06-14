import '../api/api_client.dart';
import '../../../core/constants/api_endpoints.dart';

class AnalyticsRemoteDataSource {
  final ApiClient _client = ApiClient();

  Future<Map<String, dynamic>> getHealthScore() =>
      _client.get(ApiEndpoints.analyticsHealthScore);

  Future<Map<String, dynamic>> getDashboardAnalytics() =>
      _client.get(ApiEndpoints.analyticsDashboard);
}
