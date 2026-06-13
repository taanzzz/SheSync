import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../router/app_router.dart';

class _LogOption {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final String route;

  const _LogOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.route,
  });
}

const List<_LogOption> _logOptions = [
  _LogOption(
    icon: Icons.water_drop_rounded,
    title: 'Period',
    subtitle: 'Start/End',
    color: AppColors.deepBurgundy,
    route: AppRouter.periodLog,
  ),
  _LogOption(
    icon: Icons.healing_rounded,
    title: 'Symptom',
    subtitle: 'Log',
    color: AppColors.roseBlush,
    route: AppRouter.symptomLog,
  ),
  _LogOption(
    icon: Icons.emoji_emotions_rounded,
    title: 'Mood',
    subtitle: 'Today',
    color: AppColors.peachSunset,
    route: AppRouter.journal,
  ),
  _LogOption(
    icon: Icons.water_drop_outlined,
    title: 'Water',
    subtitle: 'Intake',
    color: AppColors.skyBreeze,
    route: '',
  ),
  _LogOption(
    icon: Icons.monitor_weight_rounded,
    title: 'Weight',
    subtitle: 'Log',
    color: AppColors.lavenderDream,
    route: '',
  ),
  _LogOption(
    icon: Icons.thermostat_rounded,
    title: 'Temp',
    subtitle: 'Log',
    color: AppColors.goldenGlow,
    route: '',
  ),
];

class QuickLogSheet extends StatelessWidget {
  const QuickLogSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      maxChildSize: 0.9,
      minChildSize: 0.3,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.cardSurface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'What would you like to log? 🌸',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.3,
                ),
                itemCount: _logOptions.length,
                itemBuilder: (context, index) => _LogOptionCard(
                  option: _logOptions[index],
                  onTap: () {
                    Navigator.pop(context);
                    if (_logOptions[index].route.isNotEmpty) {
                      Navigator.pushNamed(context, _logOptions[index].route);
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LogOptionCard extends StatelessWidget {
  final _LogOption option;
  final VoidCallback onTap;

  const _LogOptionCard({required this.option, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: option.color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(option.icon, color: option.color, size: 32),
              const SizedBox(height: 12),
              Text(
                option.title,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              Text(
                option.subtitle,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
