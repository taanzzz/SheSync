import '../remote/datasources/mood_remote_datasource.dart';

class MoodRepository {
  final MoodRemoteDataSource _dataSource = MoodRemoteDataSource();

  Future<Map<String, dynamic>> saveMood(Map<String, dynamic> data) => _dataSource.saveMood(data);
  Future<Map<String, dynamic>> getTodayMood() => _dataSource.getTodayMood();
  Future<Map<String, dynamic>> getWeeklyTrend() => _dataSource.getWeeklyTrend();
  Future<Map<String, dynamic>> getMonthlyTrend() => _dataSource.getMonthlyTrend();
  Future<Map<String, dynamic>> getCycleMoodCorrelation() => _dataSource.getCycleMoodCorrelation();
}
