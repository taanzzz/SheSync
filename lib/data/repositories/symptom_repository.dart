import '../remote/datasources/symptom_remote_datasource.dart';

class SymptomRepository {
  final SymptomRemoteDataSource _dataSource = SymptomRemoteDataSource();

  Future<Map<String, dynamic>> logSymptoms(Map<String, dynamic> data) =>
      _dataSource.logSymptoms(data);

  Future<Map<String, dynamic>> getHistory({int page = 1, int limit = 10}) =>
      _dataSource.getHistory(page: page, limit: limit);

  Future<Map<String, dynamic>> getByDate(String date) =>
      _dataSource.getByDate(date);

  Future<Map<String, dynamic>> getCategories() => _dataSource.getCategories();

  Future<Map<String, dynamic>> getFrequency() => _dataSource.getFrequency();

  Future<Map<String, dynamic>> updateLog(
    String id,
    Map<String, dynamic> data,
  ) => _dataSource.updateLog(id, data);

  Future<Map<String, dynamic>> deleteLog(String id) =>
      _dataSource.deleteLog(id);
}
