import '../api/api_client.dart';
import '../../../core/constants/api_endpoints.dart';

class WeightRemoteDataSource {
  final ApiClient _client = ApiClient();

  Future<Map<String, dynamic>> logWeight(Map<String, dynamic> data) =>
      _client.post(ApiEndpoints.weight, data: data);

  Future<Map<String, dynamic>> getWeightHistory({int limit = 30}) =>
      _client.get(ApiEndpoints.weightHistory, queryParams: {'limit': limit});

  Future<Map<String, dynamic>> getWeightTrend() =>
      _client.get(ApiEndpoints.weightTrend);

  Future<Map<String, dynamic>> calculateBMI(Map<String, dynamic> data) =>
      _client.post(ApiEndpoints.weightBmi, data: data);
}
