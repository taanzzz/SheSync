import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../features/home/widgets/quick_log_sheet.dart';

class CycleSyncBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabChanged;

  const CycleSyncBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
  });

  void _handleTabChange(int index) {
    HapticFeedback.lightImpact();
    onTabChanged(index);
  }

  void _handleFabTap(BuildContext context) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const QuickLogSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return SizedBox(
      height: AppSizes.bottomNavHeight + bottomPadding + 28,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          // ── Nav Bar Body ─────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _NavBarBody(
              bottomPadding: bottomPadding,
              currentIndex: currentIndex,
              onTabChanged: _handleTabChange,
            ),
          ),

          // ── Floating FAB ─────────────────────────────
          Positioned(
            top: 0,
            child: _FloatingFab(
              onTap: () => _handleFabTap(context),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════
//  NAV BAR BODY
// ══════════════════════════════════════════
class _NavBarBody extends StatelessWidget {
  final double bottomPadding;
  final int currentIndex;
  final ValueChanged<int> onTabChanged;

  const _NavBarBody({
    required this.bottomPadding,
    required this.currentIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(32),
        topRight: Radius.circular(32),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: AppSizes.bottomNavHeight + bottomPadding,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.92),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
            border: Border(
              top: BorderSide(
                color: Colors.white.withOpacity(0.6),
                width: 1,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE8647A).withOpacity(0.06),
                blurRadius: 30,
                offset: const Offset(0, -8),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 20,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Top gradient fade line
              Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      const Color(0xFFE8647A).withOpacity(0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: bottomPadding > 0 ? bottomPadding : 8,
                    top: 4,
                  ),
                  child: Row(
                    children: [
                      // Home
                      _NavTab(
                        icon: Icons.home_rounded,
                        activeIcon: Icons.home_rounded,
                        label: 'Home',
                        isActive: currentIndex == 0,
                        onTap: () => onTabChanged(0),
                      ),

                      // Calendar
                      _NavTab(
                        icon: Icons.calendar_month_outlined,
                        activeIcon: Icons.calendar_month_rounded,
                        label: 'Calendar',
                        isActive: currentIndex == 1,
                        onTap: () => onTabChanged(1),
                      ),

                      // Center spacer for FAB
                      const SizedBox(width: 72),

                      // Medicine
                      _NavTab(
                        icon: Icons.medication_outlined,
                        activeIcon: Icons.medication_rounded,
                        label: 'Medicine',
                        isActive: currentIndex == 2,
                        onTap: () => onTabChanged(2),
                      ),

                      // Profile
                      _NavTab(
                        icon: Icons.person_outline_rounded,
                        activeIcon: Icons.person_rounded,
                        label: 'Profile',
                        isActive: currentIndex == 3,
                        onTap: () => onTabChanged(3),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════
//  NAV TAB
// ══════════════════════════════════════════
class _NavTab extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavTab({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon with pill indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 7,
              ),
              decoration: BoxDecoration(
                color: isActive
                    ? const Color(0xFFE8647A).withOpacity(0.10)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  isActive ? activeIcon : icon,
                  key: ValueKey(isActive),
                  size: 23,
                  color: isActive
                      ? const Color(0xFFE8647A)
                      : const Color(0xFFB0AEBF),
                ),
              ),
            ),

            const SizedBox(height: 3),

            // Label
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10,
                fontWeight:
                    isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive
                    ? const Color(0xFFE8647A)
                    : const Color(0xFFB0AEBF),
              ),
              child: Text(label),
            ),

            // Active dot indicator
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              width: isActive ? 18 : 0,
              height: isActive ? 3 : 0,
              decoration: BoxDecoration(
                gradient: isActive
                    ? const LinearGradient(
                        colors: [
                          Color(0xFFE8647A),
                          Color(0xFFFF9A8B),
                        ],
                      )
                    : null,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════
//  FLOATING FAB
// ══════════════════════════════════════════
class _FloatingFab extends StatefulWidget {
  final VoidCallback onTap;
  const _FloatingFab({required this.onTap});

  @override
  State<_FloatingFab> createState() => _FloatingFabState();
}

class _FloatingFabState extends State<_FloatingFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: AppSizes.fabSize + 16,
        height: AppSizes.fabSize + 16,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Pulse ring
            AnimatedBuilder(
              animation: _pulseAnim,
              builder: (_, __) => Transform.scale(
                scale: _pulseAnim.value,
                child: Container(
                  width: AppSizes.fabSize + 14,
                  height: AppSizes.fabSize + 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFE8647A).withOpacity(0.18),
                        const Color(0xFFE8647A).withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // White border ring
            Container(
              width: AppSizes.fabSize + 6,
              height: AppSizes.fabSize + 6,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),

            // FAB button
            Container(
              width: AppSizes.fabSize,
              height: AppSizes.fabSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFF6B8A),
                    Color(0xFFE8647A),
                    Color(0xFFC94B6B),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE8647A).withOpacity(0.45),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                  BoxShadow(
                    color: const Color(0xFFE8647A).withOpacity(0.2),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}