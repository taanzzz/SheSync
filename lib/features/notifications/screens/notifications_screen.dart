import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/notification_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/date_utils.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().loadNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (provider.unreadCount > 0)
            TextButton(
              onPressed: () => provider.markAllAsRead(),
              child: const Text('Mark All Read'),
            ),
          TextButton(
            onPressed: () => provider.clearAll(),
            child: const Text('Clear All'),
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.notifications.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off,
                    size: 64,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No notifications',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: provider.notifications.length,
              itemBuilder: (_, i) {
                final notif = provider.notifications[i];
                return ListTile(
                  leading: Icon(
                    notif['type'] == 'PERIOD_REMINDER'
                        ? Icons.water_drop
                        : notif['type'] == 'MEDICINE_REMINDER'
                        ? Icons.medication
                        : notif['type'] == 'APPOINTMENT_REMINDER'
                        ? Icons.calendar_today
                        : Icons.notifications,
                    color: notif['isRead'] == true
                        ? AppColors.textSecondary
                        : AppColors.primary,
                  ),
                  title: Text(
                    notif['title'] ?? '',
                    style: TextStyle(
                      fontWeight: notif['isRead'] == true
                          ? FontWeight.normal
                          : FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(notif['body'] ?? ''),
                      Text(
                        AppDateUtils.formatRelative(
                          DateTime.parse(notif['createdAt']),
                        ),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  onTap: () => provider.markAsRead(notif['_id']),
                );
              },
            ),
    );
  }
}
