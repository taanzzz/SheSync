import '../api/api_client.dart';
import '../../../core/constants/api_endpoints.dart';

class MedicineRemoteDataSource {
  final ApiClient _client = ApiClient();

  Future<Map<String, dynamic>> createMedicine(Map<String, dynamic> data) =>
      _client.post(ApiEndpoints.medicines, data: data);

  Future<Map<String, dynamic>> getMedicines() =>
      _client.get(ApiEndpoints.medicines);

  Future<Map<String, dynamic>> getTodaysMedicines() =>
      _client.get(ApiEndpoints.medicinesToday);

  Future<Map<String, dynamic>> getAdherence() =>
      _client.get(ApiEndpoints.medicinesAdherence);

  Future<Map<String, dynamic>> updateMedicine(
    String id,
    Map<String, dynamic> data,
  ) => _client.put('${ApiEndpoints.medicines}/$id', data: data);

  Future<Map<String, dynamic>> deleteMedicine(String id) =>
      _client.delete('${ApiEndpoints.medicines}/$id');

  Future<Map<String, dynamic>> logMedicine(
    String id,
    Map<String, dynamic> data,
  ) => _client.post('${ApiEndpoints.medicines}/$id/log', data: data);

  Future<Map<String, dynamic>> getMedicineLogs(String id) =>
      _client.get('${ApiEndpoints.medicines}/$id/logs');
}
