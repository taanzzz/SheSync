import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

enum SnackbarType { success, error, info }

class AppSnackbar {
  static void show(BuildContext context, String message, SnackbarType type) {
    final config = _getConfig(type);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Text(config.icon, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: config.color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        duration: const Duration(seconds: 3),
        dismissDirection: DismissDirection.horizontal,
      ),
    );
  }

  static void success(BuildContext context, String message) {
    show(context, message, SnackbarType.success);
  }

  static void error(BuildContext context, String message) {
    show(context, message, SnackbarType.error);
  }

  static void info(BuildContext context, String message) {
    show(context, message, SnackbarType.info);
  }

  static _SnackbarConfig _getConfig(SnackbarType type) {
    switch (type) {
      case SnackbarType.success:
        return _SnackbarConfig(const Color(0xFF2F855A), '✅');
      case SnackbarType.error:
        return _SnackbarConfig(AppColors.deepBurgundy, '❌');
      case SnackbarType.info:
        return _SnackbarConfig(const Color(0xFF6B46C1), 'ℹ️');
    }
  }
}

class _SnackbarConfig {
  final Color color;
  final String icon;

  _SnackbarConfig(this.color, this.icon);
}
