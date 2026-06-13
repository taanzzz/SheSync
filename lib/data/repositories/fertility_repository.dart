import '../remote/datasources/fertility_remote_datasource.dart';

class FertilityRepository {
  final FertilityRemoteDataSource _dataSource = FertilityRemoteDataSource();

  Future<Map<String, dynamic>> getFertilityWindow({int? avgCycleLength}) =>
      _dataSource.getFertilityWindow(avgCycleLength: avgCycleLength);

  Future<Map<String, dynamic>> getOvulation() => _dataSource.getOvulation();

  Future<Map<String, dynamic>> logBBT(Map<String, dynamic> data) =>
      _dataSource.logBBT(data);

  Future<Map<String, dynamic>> getBBTHistory() => _dataSource.getBBTHistory();

  Future<Map<String, dynamic>> logMucus(Map<String, dynamic> data) =>
      _dataSource.logMucus(data);

  Future<Map<String, dynamic>> getMucusHistory() =>
      _dataSource.getMucusHistory();

  Future<Map<String, dynamic>> getChartData() => _dataSource.getChartData();
}
