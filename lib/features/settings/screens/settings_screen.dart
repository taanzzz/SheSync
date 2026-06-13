import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../router/app_router.dart';
import '../../../features/notifications/screens/notifications_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final theme = context.watch<ThemeProvider>();
    final userName = auth.user?['name'] ?? 'User';
    final userEmail = auth.user?['email'] ?? 'email@example.com';
    final avatarUrl = 'https://api.dicebear.com/7.x/lorelei/png?seed=${Uri.encodeComponent(userName)}';

    return Scaffold(
      backgroundColor: AppColors.creamPuff,
      appBar: AppBar(
        title: const Text('Settings ⚙️'),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardSurface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.cardSoft,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.network(
                    avatarUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.roseBlush, AppColors.crimsonHeart],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.person_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                      Text(
                        userEmail,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
                const Text(
                  'Edit →',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    color: AppColors.crimsonHeart,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _SettingsSection(
            title: 'Account',
            color: AppColors.roseBlush,
            items: [
              _SettingItem(
                Icons.person_outline_rounded,
                'Edit Profile',
                () => _settingsPage(context, 'Edit Profile'),
              ),
              _SettingItem(Icons.cake_outlined, 'Date of Birth', null),
              _SettingItem(
                Icons.notifications_outlined,
                'Notifications',
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NotificationsScreen(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SettingsSection(
            title: 'Health',
            color: AppColors.lavenderDream,
            items: [
              _SettingItem(Icons.repeat_rounded, 'Cycle Settings', null),
              _SettingItem(
                Icons.medication_outlined,
                'Medicine Preferences',
                null,
              ),
              _SettingItem(
                Icons.assessment_rounded,
                'Export Health Report',
                () => Navigator.pushNamed(context, AppRouter.reports),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SettingsSection(
            title: 'Privacy & Security',
            color: AppColors.peachSunset,
            items: [
              _SettingItem(Icons.lock_outline_rounded, 'App Lock', null),
              _SettingItem(Icons.shield_outlined, 'Privacy Settings', null),
              _SettingItem(Icons.cloud_outlined, 'Cloud Backup', null),
            ],
          ),
          const SizedBox(height: 16),
          _SettingsSection(
            title: 'App',
            color: AppColors.skyBreeze,
            items: [
              _SettingItem(
                Icons.dark_mode_outlined,
                'Dark Mode',
                null,
                trailing: Switch(
                  value: theme.themeMode == ThemeMode.dark,
                  onChanged: (_) => theme.toggleTheme(),
                  activeColor: AppColors.crimsonHeart,
                ),
              ),
              _SettingItem(Icons.language_outlined, 'Language', null),
              _SettingItem(Icons.star_outline_rounded, 'Rate App', null),
              _SettingItem(Icons.mail_outline_rounded, 'Contact Support', null),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 56,
            child: OutlinedButton.icon(
              onPressed: () async {
                await auth.logout();
                if (context.mounted)
                  Navigator.pushReplacementNamed(context, AppRouter.login);
              },
              icon: const Icon(
                Icons.logout_rounded,
                color: AppColors.deepBurgundy,
              ),
              label: const Text(
                'Logout',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  color: AppColors.deepBurgundy,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: AppColors.deepBurgundy.withValues(alpha: 0.3),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                backgroundColor: AppColors.cardSurface,
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _settingsPage(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title coming soon'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _SettingItem {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Widget? trailing;

  _SettingItem(this.icon, this.title, this.onTap, {this.trailing});
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final Color color;
  final List<_SettingItem> items;

  const _SettingsSection({
    required this.title,
    required this.color,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
              color: color,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardSurface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: List.generate(items.length, (i) {
              final item = items[i];
              return Column(
                children: [
                  if (i > 0)
                    const Divider(height: 1, color: AppColors.dividerColor),
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(item.icon, color: color, size: 22),
                    ),
                    title: Text(
                      item.title,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textDark,
                      ),
                    ),
                    trailing:
                        item.trailing ??
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: AppColors.textLight,
                        ),
                    onTap: item.onTap,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 0,
                    ),
                    minVerticalPadding: 0,
                    horizontalTitleGap: 12,
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}
