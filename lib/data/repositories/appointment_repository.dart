import '../remote/datasources/appointment_remote_datasource.dart';

class AppointmentRepository {
  final AppointmentRemoteDataSource _dataSource = AppointmentRemoteDataSource();

  Future<Map<String, dynamic>> createAppointment(Map<String, dynamic> data) =>
      _dataSource.createAppointment(data);

  Future<Map<String, dynamic>> getAppointments({
    int page = 1,
    int limit = 10,
  }) => _dataSource.getAppointments(page: page, limit: limit);

  Future<Map<String, dynamic>> getUpcoming() => _dataSource.getUpcoming();

  Future<Map<String, dynamic>> getAppointment(String id) =>
      _dataSource.getAppointment(id);

  Future<Map<String, dynamic>> updateAppointment(
    String id,
    Map<String, dynamic> data,
  ) => _dataSource.updateAppointment(id, data);

  Future<Map<String, dynamic>> deleteAppointment(String id) =>
      _dataSource.deleteAppointment(id);

  Future<Map<String, dynamic>> createDoctor(Map<String, dynamic> data) =>
      _dataSource.createDoctor(data);

  Future<Map<String, dynamic>> getDoctors() => _dataSource.getDoctors();
}
