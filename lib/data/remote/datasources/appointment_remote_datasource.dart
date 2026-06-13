import '../api/api_client.dart';
import '../../../core/constants/api_endpoints.dart';

class AppointmentRemoteDataSource {
  final ApiClient _client = ApiClient();

  Future<Map<String, dynamic>> createAppointment(Map<String, dynamic> data) =>
      _client.post(ApiEndpoints.appointments, data: data);

  Future<Map<String, dynamic>> getAppointments({
    int page = 1,
    int limit = 10,
  }) => _client.get(
    ApiEndpoints.appointments,
    queryParams: {'page': page, 'limit': limit},
  );

  Future<Map<String, dynamic>> getUpcoming() =>
      _client.get(ApiEndpoints.appointmentsUpcoming);

  Future<Map<String, dynamic>> getAppointment(String id) =>
      _client.get('${ApiEndpoints.appointments}/$id');

  Future<Map<String, dynamic>> updateAppointment(
    String id,
    Map<String, dynamic> data,
  ) => _client.put('${ApiEndpoints.appointments}/$id', data: data);

  Future<Map<String, dynamic>> deleteAppointment(String id) =>
      _client.delete('${ApiEndpoints.appointments}/$id');

  Future<Map<String, dynamic>> createDoctor(Map<String, dynamic> data) =>
      _client.post(ApiEndpoints.doctors, data: data);

  Future<Map<String, dynamic>> getDoctors() =>
      _client.get(ApiEndpoints.doctors);
}
