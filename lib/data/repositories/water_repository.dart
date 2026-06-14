import '../remote/datasources/water_remote_datasource.dart';

class WaterRepository {
  final WaterRemoteDataSource _dataSource = WaterRemoteDataSource();

  Future<Map<String, dynamic>> getConfig() => _dataSource.getConfig();
  Future<Map<String, dynamic>> saveConfig(Map<String, dynamic> data) => _dataSource.saveConfig(data);
  Future<Map<String, dynamic>> logWater(Map<String, dynamic> data) => _dataSource.logWater(data);
  Future<Map<String, dynamic>> removeLastEntry() => _dataSource.removeLastEntry();
  Future<Map<String, dynamic>> getTodayProgress() => _dataSource.getTodayProgress();
  Future<Map<String, dynamic>> getWeeklyStats() => _dataSource.getWeeklyStats();
  Future<Map<String, dynamic>> getMonthlyStats() => _dataSource.getMonthlyStats();
  Future<Map<String, dynamic>> getStreak() => _dataSource.getStreak();
}
