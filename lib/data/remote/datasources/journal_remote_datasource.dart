import '../api/api_client.dart';
import '../../../core/constants/api_endpoints.dart';

class JournalRemoteDataSource {
  final ApiClient _client = ApiClient();

  Future<Map<String, dynamic>> createJournal(Map<String, dynamic> data) =>
      _client.post(ApiEndpoints.journals, data: data);

  Future<Map<String, dynamic>> getJournals({int page = 1, int limit = 10}) =>
      _client.get(
        ApiEndpoints.journals,
        queryParams: {'page': page, 'limit': limit},
      );

  Future<Map<String, dynamic>> getJournal(String id) =>
      _client.get('${ApiEndpoints.journals}/$id');

  Future<Map<String, dynamic>> getByDate(String date) =>
      _client.get('${ApiEndpoints.journals}/date/$date');

  Future<Map<String, dynamic>> updateJournal(
    String id,
    Map<String, dynamic> data,
  ) => _client.put('${ApiEndpoints.journals}/$id', data: data);

  Future<Map<String, dynamic>> deleteJournal(String id) =>
      _client.delete('${ApiEndpoints.journals}/$id');

  Future<Map<String, dynamic>> getMoodTrends() =>
      _client.get(ApiEndpoints.moodTrends);
}
