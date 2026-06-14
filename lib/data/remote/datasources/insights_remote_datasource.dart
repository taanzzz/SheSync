import '../api/api_client.dart';
import '../../../core/constants/api_endpoints.dart';

class InsightsRemoteDataSource {
  final ApiClient _client = ApiClient();

  Future<Map<String, dynamic>> getSmartInsights() =>
      _client.get(ApiEndpoints.insights);
}
