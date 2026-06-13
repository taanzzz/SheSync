import 'package:flutter/material.dart';
import '../data/repositories/notification_repository.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationRepository _repository = NotificationRepository();

  List<Map<String, dynamic>> _notifications = [];
  int _unreadCount = 0;
  bool _isLoading = false;

  List<Map<String, dynamic>> get notifications => _notifications;
  int get unreadCount => _unreadCount;
  bool get isLoading => _isLoading;

  Future<void> loadNotifications() async {
    _isLoading = true;
    notifyListeners();
    try {
      final r = await _repository.getNotifications();
      _notifications = List<Map<String, dynamic>>.from(r['data'] ?? []);
      _unreadCount = _notifications.where((n) => n['isRead'] == false).length;
    } catch (_) {}
    _isLoading = false;
    notifyListeners();
  }

  Future<void> markAsRead(String id) async {
    try {
      await _repository.markAsRead(id);
      await loadNotifications();
    } catch (_) {}
  }

  Future<void> markAllAsRead() async {
    try {
      await _repository.markAllAsRead();
      await loadNotifications();
    } catch (_) {}
  }

  Future<void> clearAll() async {
    try {
      await _repository.clearAll();
      await loadNotifications();
    } catch (_) {}
  }
}
