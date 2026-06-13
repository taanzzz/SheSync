import '../remote/datasources/journal_remote_datasource.dart';

class JournalRepository {
  final JournalRemoteDataSource _dataSource = JournalRemoteDataSource();

  Future<Map<String, dynamic>> createJournal(Map<String, dynamic> data) =>
      _dataSource.createJournal(data);

  Future<Map<String, dynamic>> getJournals({int page = 1, int limit = 10}) =>
      _dataSource.getJournals(page: page, limit: limit);

  Future<Map<String, dynamic>> getJournal(String id) =>
      _dataSource.getJournal(id);

  Future<Map<String, dynamic>> getByDate(String date) =>
      _dataSource.getByDate(date);

  Future<Map<String, dynamic>> updateJournal(
    String id,
    Map<String, dynamic> data,
  ) => _dataSource.updateJournal(id, data);

  Future<Map<String, dynamic>> deleteJournal(String id) =>
      _dataSource.deleteJournal(id);

  Future<Map<String, dynamic>> getMoodTrends() => _dataSource.getMoodTrends();
}
