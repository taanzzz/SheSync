import '../remote/datasources/vitals_remote_datasource.dart';

class VitalsRepository {
  final VitalsRemoteDataSource _dataSource = VitalsRemoteDataSource();

  Future<Map<String, dynamic>> createVitals(Map<String, dynamic> data) =>
      _dataSource.createVitals(data);

  Future<Map<String, dynamic>> getVitalsHistory({
    int page = 1,
    int limit = 10,
  }) => _dataSource.getVitalsHistory(page: page, limit: limit);

  Future<Map<String, dynamic>> getByDate(String date) =>
      _dataSource.getByDate(date);

  Future<Map<String, dynamic>> getChartData() => _dataSource.getChartData();

  Future<Map<String, dynamic>> updateVitals(
    String id,
    Map<String, dynamic> data,
  ) => _dataSource.updateVitals(id, data);

  Future<Map<String, dynamic>> deleteVitals(String id) =>
      _dataSource.deleteVitals(id);
}
