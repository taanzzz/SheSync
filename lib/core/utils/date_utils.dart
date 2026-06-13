import 'package:intl/intl.dart';

class AppDateUtils {
  static String format(DateTime date, {String format = 'yyyy-MM-dd'}) {
    return DateFormat(format).format(date);
  }

  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (diff < 7) return '$diff days ago';
    return DateFormat('MMM d, yyyy').format(date);
  }

  static String formatTime(String time) {
    if (time.isEmpty) return '';
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = parts[1];
    final amPm = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '${hour12.toString().padLeft(2, '0')}:$minute $amPm';
  }

  static DateTime get startOfMonth =>
      DateTime(DateTime.now().year, DateTime.now().month, 1);

  static DateTime get endOfMonth =>
      DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
}
