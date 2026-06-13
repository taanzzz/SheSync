import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../router/app_router.dart';
import 'quick_log_sheet.dart';

class QuickLogBar extends StatelessWidget {
  const QuickLogBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardSurface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _QuickAction(
                  icon: Icons.water_drop_rounded,
                  label: 'Period',
                  color: AppColors.deepBurgundy,
                  onTap: () =>
                      Navigator.pushNamed(context, AppRouter.periodLog),
                ),
                _QuickAction(
                  icon: Icons.healing_rounded,
                  label: 'Symptom',
                  color: AppColors.roseBlush,
                  onTap: () =>
                      Navigator.pushNamed(context, AppRouter.symptomLog),
                ),
                _QuickAction(
                  icon: Icons.emoji_emotions_rounded,
                  label: 'Mood',
                  color: AppColors.peachSunset,
                  onTap: () => Navigator.pushNamed(context, AppRouter.journal),
                ),
                _QuickAction(
                  icon: Icons.add_rounded,
                  label: 'More',
                  color: AppColors.lavenderDream,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => const QuickLogSheet(),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
