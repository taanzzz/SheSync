import '../api/api_client.dart';
import '../../../core/constants/api_endpoints.dart';

class NotificationRemoteDataSource {
  final ApiClient _client = ApiClient();

  Future<Map<String, dynamic>> getNotifications({
    int page = 1,
    int limit = 20,
  }) => _client.get(
    ApiEndpoints.notificationsList,
    queryParams: {'page': page, 'limit': limit},
  );

  Future<Map<String, dynamic>> markAsRead(String id) =>
      _client.put('${ApiEndpoints.notificationsList}/$id/read');

  Future<Map<String, dynamic>> markAllAsRead() =>
      _client.put(ApiEndpoints.notificationsReadAll);

  Future<Map<String, dynamic>> deleteNotification(String id) =>
      _client.delete('${ApiEndpoints.notificationsList}/$id');

  Future<Map<String, dynamic>> clearAll() =>
      _client.delete(ApiEndpoints.notificationsClearAll);
}
