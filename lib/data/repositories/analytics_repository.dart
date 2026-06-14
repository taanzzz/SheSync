import '../remote/datasources/analytics_remote_datasource.dart';

class AnalyticsRepository {
  final AnalyticsRemoteDataSource _dataSource = AnalyticsRemoteDataSource();

  Future<Map<String, dynamic>> getHealthScore() => _dataSource.getHealthScore();
  Future<Map<String, dynamic>> getDashboardAnalytics() => _dataSource.getDashboardAnalytics();
}
