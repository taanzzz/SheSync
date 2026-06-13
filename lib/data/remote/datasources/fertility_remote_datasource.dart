import '../api/api_client.dart';
import '../../../core/constants/api_endpoints.dart';

class FertilityRemoteDataSource {
  final ApiClient _client = ApiClient();

  Future<Map<String, dynamic>> getFertilityWindow({int? avgCycleLength}) =>
      _client.get(
        ApiEndpoints.fertilityWindow,
        queryParams: avgCycleLength != null
            ? {'avgCycleLength': avgCycleLength}
            : {},
      );

  Future<Map<String, dynamic>> getOvulation() =>
      _client.get(ApiEndpoints.fertilityOvulation);

  Future<Map<String, dynamic>> logBBT(Map<String, dynamic> data) =>
      _client.post(ApiEndpoints.bbt, data: data);

  Future<Map<String, dynamic>> getBBTHistory() => _client.get(ApiEndpoints.bbt);

  Future<Map<String, dynamic>> logMucus(Map<String, dynamic> data) =>
      _client.post(ApiEndpoints.mucus, data: data);

  Future<Map<String, dynamic>> getMucusHistory() =>
      _client.get(ApiEndpoints.mucus);

  Future<Map<String, dynamic>> getChartData() =>
      _client.get(ApiEndpoints.fertilityChart);
}
