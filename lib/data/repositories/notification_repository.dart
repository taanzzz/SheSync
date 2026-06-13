import '../remote/datasources/notification_remote_datasource.dart';

class NotificationRepository {
  final NotificationRemoteDataSource _dataSource =
      NotificationRemoteDataSource();

  Future<Map<String, dynamic>> getNotifications({
    int page = 1,
    int limit = 20,
  }) => _dataSource.getNotifications(page: page, limit: limit);

  Future<Map<String, dynamic>> markAsRead(String id) =>
      _dataSource.markAsRead(id);

  Future<Map<String, dynamic>> markAllAsRead() => _dataSource.markAllAsRead();

  Future<Map<String, dynamic>> deleteNotification(String id) =>
      _dataSource.deleteNotification(id);

  Future<Map<String, dynamic>> clearAll() => _dataSource.clearAll();
}
