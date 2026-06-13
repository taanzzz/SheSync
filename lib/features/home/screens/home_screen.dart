import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/cycle_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../router/app_router.dart';
import '../../../shared/widgets/cycle_sync_bottom_nav.dart';
import '../widgets/cycle_status_card.dart';
import '../widgets/quick_log_bar.dart';
import '../../../features/calendar/screens/calendar_screen.dart';
import '../../../features/medicine/screens/medicine_screen.dart';
import '../../../features/settings/screens/settings_screen.dart';
import '../../../features/notifications/screens/notifications_screen.dart';
import '../../../shared/widgets/cycle_sync_button.dart';

// ─────────────────────────────────────────────
//  ROOT SHELL — unchanged navigation wrapper
// ─────────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const _HomeTab(),
    const CalendarScreen(),
    const MedicineScreen(),
    const _ProfileTab(),
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: CycleSyncBottomNavBar(
        currentIndex: _currentIndex,
        onTabChanged: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();
  @override
  Widget build(BuildContext context) => const SettingsScreen();
}

// ─────────────────────────────────────────────
//  HOME TAB — state + data loading
// ─────────────────────────────────────────────
class _HomeTab extends StatefulWidget {
  const _HomeTab();
  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab> {
  // Water tracker local state
  int _waterGlasses = 4;
  final int _waterGoal = 8;

  // Mood selection
  int? _selectedMoodIndex;

  // Medicine taken state
  final List<bool?> _medicineTaken = [true, false, null];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CycleProvider>().loadPrediction();
      context.read<CycleProvider>().loadStatistics();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cycleProvider = context.watch<CycleProvider>();
    final authProvider = context.watch<AuthProvider>();
    final userName = authProvider.user?['name'] ?? 'Sarah';
    final avatarUrl =
        'https://api.dicebear.com/7.x/lorelei/png?seed=${Uri.encodeComponent(userName)}';

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFFAF8F5),
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── 1. IMMERSIVE HERO HEADER ──────────────────
            SliverToBoxAdapter(
              child: _ImmersiveHeader(
                userName: userName,
                avatarUrl: avatarUrl,
                cycleProvider: cycleProvider,
                onNotificationTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const NotificationsScreen()),
                ),
              ),
            ),

            // ── 2. CYCLE ORBIT SECTION ────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: _CycleOrbitSection(
                  prediction: cycleProvider.prediction,
                  statistics: cycleProvider.statistics,
                ),
              ),
            ),

            // ── 3. DAILY MOOD CHECK-IN ────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: _DailyCheckInStrip(
                  selectedIndex: _selectedMoodIndex,
                  onMoodSelected: (i) =>
                      setState(() => _selectedMoodIndex = i),
                ),
              ),
            ),

            // ── 4. QUICK LOG ACTIONS ──────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: const QuickLogBar(),
              ),
            ),

            // ── 5. WELLNESS SNAPSHOT ROW ──────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: _WellnessSnapshotRow(
                  waterGlasses: _waterGlasses,
                  waterGoal: _waterGoal,
                  onAddWater: () {
                    if (_waterGlasses < _waterGoal) {
                      setState(() => _waterGlasses++);
                      HapticFeedback.lightImpact();
                    }
                  },
                ),
              ),
            ),

            // ── 6. MEDICINE TIMELINE ──────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: _MedicineTimeline(
                  taken: _medicineTaken,
                  onToggle: (i) {
                    setState(() {
                      _medicineTaken[i] =
                          _medicineTaken[i] == true ? false : true;
                    });
                    HapticFeedback.mediumImpact();
                  },
                ),
              ),
            ),

            // ── 7. WELLNESS STORY CARD ────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: const _WellnessStoryCard(),
              ),
            ),

            // ── 8. STREAK MOTIVATION ──────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
                child: const _StreakMotivationBanner(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  SECTION 1 — IMMERSIVE HERO HEADER
// ══════════════════════════════════════════════════════════
class _ImmersiveHeader extends StatelessWidget {
  final String userName;
  final String avatarUrl;
  final CycleProvider cycleProvider;
  final VoidCallback onNotificationTap;

  const _ImmersiveHeader({
    required this.userName,
    required this.avatarUrl,
    required this.cycleProvider,
    required this.onNotificationTap,
  });

  String _getGreeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good Morning';
    if (h < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  String _getGreetingEmoji() {
    final h = DateTime.now().hour;
    if (h < 12) return '🌸';
    if (h < 17) return '✨';
    return '🌙';
  }

  String _getPhaseLabel() {
    final prediction = cycleProvider.prediction;
    if (prediction == null) return 'Ovulation Phase';
    return prediction['phase'] ?? 'Ovulation Phase';
  }

  String _getPhaseMoodCopy() {
    final phase = _getPhaseLabel().toLowerCase();
    if (phase.contains('ovulat')) {
      return 'Your energy peaks today perfect\nfor big decisions & connection 💫';
    } else if (phase.contains('menstrual') || phase.contains('period')) {
      return 'Rest is your superpower today —\nhonour your body\'s rhythm 🌿';
    } else if (phase.contains('follicular')) {
      return 'New energy is rising within you —\nembrace fresh beginnings 🌱';
    } else {
      return 'Soften your pace today — your\nbody is preparing beautifully 🍂';
    }
  }

  Color _getPhaseColor() {
    final phase = _getPhaseLabel().toLowerCase();
    if (phase.contains('ovulat')) return const Color(0xFFD4A843);
    if (phase.contains('menstrual') || phase.contains('period'))
      return const Color(0xFFC96B6B);
    if (phase.contains('follicular')) return const Color(0xFF6BAF8A);
    return const Color(0xFF8B7EC8);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final phaseColor = _getPhaseColor();
    final now = DateTime.now();
    final dayLabel =
        ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][now.weekday - 1];
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    final dateLabel = '$dayLabel, ${now.day} ${months[now.month - 1]}';

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFFFF0E8),
            Color(0xFFFDE8F0),
            Color(0xFFEDE8FA),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background decorative elements
          Positioned(
            top: -40,
            right: -30,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFD6E7).withOpacity(0.35),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFD6E8FF).withOpacity(0.3),
              ),
            ),
          ),

          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // --- TOP ROW: Avatar + Greeting + Notification ---
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar with gradient border
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [phaseColor.withOpacity(0.6), phaseColor],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: phaseColor.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(2.5),
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Image.network(
                            avatarUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.person_rounded,
                              color: phaseColor,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Greeting & Name
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dateLabel,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF9E9EA8),
                              ),
                            ),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${_getGreeting()}, $userName ${_getGreetingEmoji()}',
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF2D2D3A),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Notification
                      GestureDetector(
                        onTap: onNotificationTap,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              const Icon(
                                Icons.notifications_none_rounded,
                                size: 24,
                                color: Color(0xFF2D2D3A),
                              ),
                              Positioned(
                                top: 10,
                                right: 12,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8647A),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 1.5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // --- MIDDLE SECTION: Content + Image ---
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Text Content
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Phase chip
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: phaseColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: phaseColor.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: phaseColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      _getPhaseLabel(),
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: phaseColor,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Mood copy
                            Text(
                              _getPhaseMoodCopy().replaceAll('\n', ' '),
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                color: Color(0xFF6B6B7B),
                                height: 1.6,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(width: 16),
                      
                      // Illustration
                      Expanded(
                        flex: 2,
                        child: Container(
                          constraints: const BoxConstraints(maxHeight: 140),
                          alignment: Alignment.bottomRight,
                          child: Image.network(
                            'https://res.cloudinary.com/dol0wdten/image/upload/v1781188781/girl_cvxm2g.png',
                            fit: BoxFit.contain,
                            alignment: Alignment.bottomRight,
                            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  SECTION 2 — CYCLE ORBIT SECTION
// ══════════════════════════════════════════════════════════
class _CycleOrbitSection extends StatelessWidget {
  final Map<String, dynamic>? prediction;
  final Map<String, dynamic>? statistics;

  const _CycleOrbitSection({this.prediction, this.statistics});

  int get _cycleDay => prediction?['currentDay'] ?? 14;
  int get _totalDays => prediction?['cycleLength'] ?? 28;
  int get _daysUntilNext => prediction?['daysUntilNext'] ?? 14;
  String get _phase => prediction?['phase'] ?? 'Ovulation Phase';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8647A).withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Section label
          Row(
            children: [
              const Text(
                'Cycle Overview',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D2D3A),
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F0FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Day $_cycleDay',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF8B7EC8),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Orbit Ring + Center
          SizedBox(
            width: 200,
            height: 200,
            child: _CycleOrbitRing(
              cycleDay: _cycleDay,
              totalDays: _totalDays,
              phase: _phase,
            ),
          ),

          const SizedBox(height: 24),

          // Stats row
          Row(
            children: [
              _CycleStat(
                label: 'Cycle Day',
                value: '$_cycleDay',
                unit: 'of $_totalDays',
                color: const Color(0xFFE8647A),
              ),
              _VerticalDivider(),
              _CycleStat(
                label: 'Next Period',
                value: '$_daysUntilNext',
                unit: 'days away',
                color: const Color(0xFF8B7EC8),
              ),
              _VerticalDivider(),
              _CycleStat(
                label: 'Avg Cycle',
                value:
                    '${statistics?['avgCycleLength'] ?? _totalDays}',
                unit: 'days',
                color: const Color(0xFF6BAF8A),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Progress bar with phase zones
          _PhaseProgressBar(
            cycleDay: _cycleDay,
            totalDays: _totalDays,
          ),
        ],
      ),
    );
  }
}

class _CycleOrbitRing extends StatelessWidget {
  final int cycleDay;
  final int totalDays;
  final String phase;

  const _CycleOrbitRing({
    required this.cycleDay,
    required this.totalDays,
    required this.phase,
  });

  Color _phaseColor(String p) {
    final lower = p.toLowerCase();
    if (lower.contains('ovulat')) return const Color(0xFFD4A843);
    if (lower.contains('menstrual') || lower.contains('period'))
      return const Color(0xFFE8647A);
    if (lower.contains('follicular')) return const Color(0xFF6BAF8A);
    return const Color(0xFF8B7EC8);
  }

  @override
  Widget build(BuildContext context) {
    final color = _phaseColor(phase);
    return CustomPaint(
      painter: _OrbitPainter(
        cycleDay: cycleDay,
        totalDays: totalDays,
        activeColor: color,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$cycleDay',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 48,
                fontWeight: FontWeight.w800,
                color: color,
                height: 1,
              ),
            ),
            const Text(
              'Days',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF9E9EA8),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                phase.length > 16
                    ? '${phase.substring(0, 14)}...'
                    : phase,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrbitPainter extends CustomPainter {
  final int cycleDay;
  final int totalDays;
  final Color activeColor;

  const _OrbitPainter({
    required this.cycleDay,
    required this.totalDays,
    required this.activeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 16;
    final dotRadius = 4.5;
    final activeDotRadius = 7.0;

    // Track ring
    final trackPaint = Paint()
      ..color = const Color(0xFFF0EEF8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, trackPaint);

    for (int i = 0; i < totalDays; i++) {
      final angle = (2 * math.pi * i / totalDays) - (math.pi / 2);
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      final isActive = i < cycleDay;
      final isCurrent = i == cycleDay - 1;

      if (isCurrent) {
        // Glow ring
        final glowPaint = Paint()
          ..color = activeColor.withOpacity(0.2)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(x, y), activeDotRadius + 3, glowPaint);

        // Active dot
        final activePaint = Paint()
          ..color = activeColor
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(x, y), activeDotRadius, activePaint);
      } else {
        final dotPaint = Paint()
          ..color = isActive
              ? activeColor.withOpacity(0.45)
              : const Color(0xFFE8E6F0)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(x, y), dotRadius, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(_OrbitPainter old) =>
      old.cycleDay != cycleDay || old.totalDays != totalDays;
}

class _CycleStat extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color color;

  const _CycleStat({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          Text(
            unit,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 10,
              color: Color(0xFF9E9EA8),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B6B7B),
            ),
          ),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      color: const Color(0xFFEEECF5),
    );
  }
}

class _PhaseProgressBar extends StatelessWidget {
  final int cycleDay;
  final int totalDays;

  const _PhaseProgressBar(
      {required this.cycleDay, required this.totalDays});

  @override
  Widget build(BuildContext context) {
    final progress = cycleDay / totalDays;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Menstrual',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 9,
                    color: Color(0xFFE8647A),
                    fontWeight: FontWeight.w600)),
            Text('Follicular',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 9,
                    color: Color(0xFF6BAF8A),
                    fontWeight: FontWeight.w600)),
            Text('Ovulation',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 9,
                    color: Color(0xFFD4A843),
                    fontWeight: FontWeight.w600)),
            Text('Luteal',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 9,
                    color: Color(0xFF8B7EC8),
                    fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            height: 8,
            child: Stack(
              children: [
                // Phase zones background
                Row(
                  children: [
                    _PhaseZone(flex: 5, color: const Color(0xFFFFE8EC)),
                    _PhaseZone(flex: 9, color: const Color(0xFFE8F5EE)),
                    _PhaseZone(flex: 3, color: const Color(0xFFFFF8E6)),
                    _PhaseZone(flex: 11, color: const Color(0xFFF0EDFA)),
                  ],
                ),
                // Progress fill
                FractionallySizedBox(
                  widthFactor: progress.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFE8647A).withOpacity(0.6),
                          const Color(0xFFD4A843).withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PhaseZone extends StatelessWidget {
  final int flex;
  final Color color;
  const _PhaseZone({required this.flex, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(color: color),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  SECTION 3 — DAILY MOOD CHECK-IN STRIP
// ══════════════════════════════════════════════════════════
class _DailyCheckInStrip extends StatelessWidget {
  final int? selectedIndex;
  final ValueChanged<int> onMoodSelected;

  const _DailyCheckInStrip({
    required this.selectedIndex,
    required this.onMoodSelected,
  });

  static const _moods = [
    {'emoji': '😴', 'label': 'Tired'},
    {'emoji': '💪', 'label': 'Energetic'},
    {'emoji': '😊', 'label': 'Happy'},
    {'emoji': '😌', 'label': 'Calm'},
    {'emoji': '😟', 'label': 'Anxious'},
    {'emoji': '🌧️', 'label': 'Low'},
    {'emoji': '🩸', 'label': 'Cramping'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'How are you feeling?',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2D2D3A),
                  ),
                ),
                Text(
                  'Track your mood for better insights',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: Color(0xFF9E9EA8),
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 14),

        // Mood pills
        SizedBox(
          height: 72,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _moods.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, i) {
              final mood = _moods[i];
              final isSelected = selectedIndex == i;
              return GestureDetector(
                onTap: () => onMoodSelected(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF2D2D3A)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF2D2D3A)
                          : const Color(0xFFEEECF5),
                      width: 1.5,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: const Color(0xFF2D2D3A)
                                  .withOpacity(0.15),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        mood['emoji']!,
                        style: TextStyle(
                          fontSize: isSelected ? 22 : 20,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        mood['label']!,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF6B6B7B),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════
//  SECTION 5 — WELLNESS SNAPSHOT ROW
// ══════════════════════════════════════════════════════════
class _WellnessSnapshotRow extends StatelessWidget {
  final int waterGlasses;
  final int waterGoal;
  final VoidCallback onAddWater;

  const _WellnessSnapshotRow({
    required this.waterGlasses,
    required this.waterGoal,
    required this.onAddWater,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Today\'s Wellness',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2D2D3A),
          ),
        ),
        const SizedBox(height: 14),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Water tracker — left card
              Expanded(
                flex: 5,
                child: _WaterRingCard(
                  glasses: waterGlasses,
                  goal: waterGoal,
                  onAdd: onAddWater,
                ),
              ),
              const SizedBox(width: 14),
              // Phase insight — right card (taller)
              Expanded(
                flex: 6,
                child: const _PhaseInsightCard(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WaterRingCard extends StatelessWidget {
  final int glasses;
  final int goal;
  final VoidCallback onAdd;

  const _WaterRingCard({
    required this.glasses,
    required this.goal,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final progress = glasses / goal;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2EC4B6), Color(0xFF1A9E93)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2EC4B6).withOpacity(0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Hydration',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Circular progress ring
          SizedBox(
            width: 90,
            height: 90,
            child: CustomPaint(
              painter: _ArcPainter(
                progress: progress,
                trackColor: Colors.white.withOpacity(0.2),
                fillColor: Colors.white,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$glasses',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1,
                      ),
                    ),
                    Text(
                      'of $goal',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        color: Colors.white.withOpacity(0.75),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Add button
          GestureDetector(
            onTap: onAdd,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: Colors.white.withOpacity(0.4), width: 1),
              ),
              child: const FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add_rounded, color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'Add glass',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color fillColor;

  const _ArcPainter({
    required this.progress,
    required this.trackColor,
    required this.fillColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 8;
    const startAngle = -math.pi / 2;
    const strokeWidth = 8.0;

    // Track
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      2 * math.pi,
      false,
      Paint()
        ..color = trackColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );

    // Progress
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      2 * math.pi * progress.clamp(0.0, 1.0),
      false,
      Paint()
        ..color = fillColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_ArcPainter old) => old.progress != progress;
}

class _PhaseInsightCard extends StatelessWidget {
  const _PhaseInsightCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3D2C8D), Color(0xFF6B52C8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3D2C8D).withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              '🌙 Tonight',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Progesterone\nis rising.',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Prioritise rest and reduce screen time before bed tonight.',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: Colors.white.withOpacity(0.75),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    'Sleep tips',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.arrow_forward_rounded,
                    color: Colors.white.withOpacity(0.9), size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  SECTION 6 — MEDICINE TIMELINE
// ══════════════════════════════════════════════════════════
class _MedicineTimeline extends StatelessWidget {
  final List<bool?> taken;
  final ValueChanged<int> onToggle;

  const _MedicineTimeline({
    required this.taken,
    required this.onToggle,
  });

  static const _medicines = [
    {'time': '8:00 AM', 'name': 'Folic Acid', 'dose': '400mcg', 'period': 'Morning'},
    {'time': '2:00 PM', 'name': 'Iron Tablet', 'dose': '65mg', 'period': 'Afternoon'},
    {'time': '10:00 PM', 'name': 'Vitamin D3', 'dose': '1000IU', 'period': 'Night'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6BAF8A).withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5EE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.medication_rounded,
                  color: Color(0xFF6BAF8A),
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today\'s Ritual',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2D2D3A),
                    ),
                  ),
                  Text(
                    'Your daily supplements',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      color: Color(0xFF9E9EA8),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'View All',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6BAF8A),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Timeline row
          Row(
            children: List.generate(_medicines.length, (i) {
              final med = _medicines[i];
              final status = taken[i];
              final isLast = i == _medicines.length - 1;

              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: _MedicineTimelineItem(
                        time: med['time']!,
                        name: med['name']!,
                        dose: med['dose']!,
                        period: med['period']!,
                        status: status,
                        onTap: () => onToggle(i),
                      ),
                    ),
                    if (!isLast)
                      Container(
                        width: 28,
                        height: 1.5,
                        color: const Color(0xFFEEECF5),
                        margin:
                            const EdgeInsets.only(bottom: 24),
                      ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _MedicineTimelineItem extends StatelessWidget {
  final String time;
  final String name;
  final String dose;
  final String period;
  final bool? status;
  final VoidCallback onTap;

  const _MedicineTimelineItem({
    required this.time,
    required this.name,
    required this.dose,
    required this.period,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isTaken = status == true;
    final isPending = status == null;

    final dotColor = isTaken
        ? const Color(0xFF6BAF8A)
        : isPending
            ? const Color(0xFFD4D4DC)
            : const Color(0xFFE8647A);

    final cardColor = isTaken
        ? const Color(0xFFE8F5EE)
        : isPending
            ? const Color(0xFFF8F8FC)
            : const Color(0xFFFFF0F2);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          // Status dot
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: dotColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              isTaken
                  ? Icons.check_rounded
                  : isPending
                      ? Icons.schedule_rounded
                      : Icons.add_rounded,
              color: Colors.white,
              size: 14,
            ),
          ),

          const SizedBox(height: 10),

          // Time
          Text(
            time,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: Color(0xFF9E9EA8),
              letterSpacing: 0.3,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // Medicine card
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2D2D3A),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2),
                Text(
                  dose,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10,
                    color: Color(0xFF9E9EA8),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  isTaken
                      ? '✓ Taken'
                      : isPending
                          ? 'Pending'
                          : 'Take Now',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: dotColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  SECTION 7 — WELLNESS STORY CARD
// ══════════════════════════════════════════════════════════
class _WellnessStoryCard extends StatelessWidget {
  const _WellnessStoryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 220),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B4332), Color(0xFF2D6A4F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B4332).withOpacity(0.3),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background blob
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),

          // Illustration — happy_1.png bleeding out from right
          Positioned(
            right: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(32),
              ),
              child: SizedBox(
                height: 180,
                width: 130,
                child: Image.network(
                  'https://res.cloudinary.com/dol0wdten/image/upload/v1781177632/happy_1_ztnjj9.png',
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomRight,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 160, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF52B788).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF52B788).withOpacity(0.4),
                      width: 1,
                    ),
                  ),
                  child: const Text(
                    '🌿 Phase Wisdom',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF95D5B2),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                const Text(
                  '"Your peak\nenergy window\nis now."',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 14),

                _WellnessBullet('Exercise benefits peak this week'),
                const SizedBox(height: 6),
                _WellnessBullet('Social energy is at its highest'),
                const SizedBox(height: 6),
                _WellnessBullet('Creative work flows with ease'),

                const SizedBox(height: 18),

                GestureDetector(
                  onTap: () {},
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Explore Phase Guide',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF95D5B2),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: const Color(0xFF52B788).withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward_rounded,
                          color: Color(0xFF95D5B2),
                          size: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WellnessBullet extends StatelessWidget {
  final String text;
  const _WellnessBullet(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 5,
          height: 5,
          decoration: BoxDecoration(
            color: const Color(0xFF95D5B2),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: Colors.white.withOpacity(0.78),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════
//  SECTION 8 — STREAK MOTIVATION BANNER
// ══════════════════════════════════════════════════════════
class _StreakMotivationBanner extends StatelessWidget {
  const _StreakMotivationBanner();

  static const _weekDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  static const _streakDays = [true, true, true, true, true, true, false];
  static const _streakCount = 6;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF9A3C), Color(0xFFFFB547)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF9A3C).withOpacity(0.28),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('🔥', style: TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '$_streakCount-Day Streak!',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Keep it going — you\'re on fire!',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Week dots
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(7, (i) {
              final done = _streakDays[i];
              return Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: done
                          ? Colors.white
                          : Colors.white.withOpacity(0.25),
                      shape: BoxShape.circle,
                      boxShadow: done
                          ? [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.4),
                                blurRadius: 8,
                              ),
                            ]
                          : [],
                    ),
                    child: Center(
                      child: done
                          ? const Icon(
                              Icons.check_rounded,
                              color: Color(0xFFFF9A3C),
                              size: 16,
                            )
                          : Text(
                              '○',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.6),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _weekDays[i],
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: done
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                    ),
                  ),
                ],
              );
            }),
          ),

          const SizedBox(height: 18),

          // Motivational quote
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Text('💕', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'You\'re building a beautiful habit of self-care.',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.92),
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}