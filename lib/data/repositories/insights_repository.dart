import '../remote/datasources/insights_remote_datasource.dart';

class InsightsRepository {
  final InsightsRemoteDataSource _dataSource = InsightsRemoteDataSource();

  Future<Map<String, dynamic>> getSmartInsights() => _dataSource.getSmartInsights();
}
