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

  Future<Map<String, dynamic>> getDashboard() => _dataSource.getDashboard();

  Future<Map<String, dynamic>> getCycleAlerts() => _dataSource.getCycleAlerts();

  Future<Map<String, dynamic>> getFertilityPrediction() =>
      _dataSource.getFertilityPrediction();

  Future<Map<String, dynamic>> getPremiumCalendar(int month, int year) =>
      _dataSource.getPremiumCalendar(month, year);

  Future<Map<String, dynamic>> getConfig() => _dataSource.getConfig();

  Future<Map<String, dynamic>> saveConfig(Map<String, dynamic> data) =>
      _dataSource.saveConfig(data);
}
