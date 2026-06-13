import '../remote/datasources/cycle_remote_datasource.dart';

class CycleRepository {
  final CycleRemoteDataSource _dataSource = CycleRemoteDataSource();

  Future<Map<String, dynamic>> createCycle(Map<String, dynamic> data) =>
      _dataSource.createCycle(data);

  Future<Map<String, dynamic>> getCycles({int page = 1, int limit = 10}) =>
      _dataSource.getCycles(page: page, limit: limit);

  Future<Map<String, dynamic>> getPrediction() => _dataSource.getPrediction();

  Future<Map<String, dynamic>> getCalendarData(int month, int year) =>
      _dataSource.getCalendarData(month, year);

  Future<Map<String, dynamic>> getStatistics() => _dataSource.getStatistics();

  Future<Map<String, dynamic>> updateCycle(
    String id,
    Map<String, dynamic> data,
  ) => _dataSource.updateCycle(id, data);

  Future<Map<String, dynamic>> deleteCycle(String id) =>
      _dataSource.deleteCycle(id);
}
