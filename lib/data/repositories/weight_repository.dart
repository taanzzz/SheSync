import '../remote/datasources/weight_remote_datasource.dart';

class WeightRepository {
  final WeightRemoteDataSource _dataSource = WeightRemoteDataSource();

  Future<Map<String, dynamic>> logWeight(Map<String, dynamic> data) => _dataSource.logWeight(data);
  Future<Map<String, dynamic>> getWeightHistory({int limit = 30}) => _dataSource.getWeightHistory(limit: limit);
  Future<Map<String, dynamic>> getWeightTrend() => _dataSource.getWeightTrend();
  Future<Map<String, dynamic>> calculateBMI(Map<String, dynamic> data) => _dataSource.calculateBMI(data);
}
