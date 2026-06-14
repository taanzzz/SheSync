import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../providers/water_provider.dart';

class WaterTrackingScreen extends StatefulWidget {
  const WaterTrackingScreen({super.key});

  @override
  State<WaterTrackingScreen> createState() => _WaterTrackingScreenState();
}

class _WaterTrackingScreenState extends State<WaterTrackingScreen> with TickerProviderStateMixin {
  int _selectedTab = 0;
  int _selectedGlassSize = 250;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  static const _glassSizes = [150, 200, 250, 300, 500];
  static const _glassLabels = ['150ml', '200ml', '250ml', '300ml', '500ml'];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WaterProvider>().loadAll();
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _addWater() {
    HapticFeedback.mediumImpact();
    _pulseController.forward().then((_) => _pulseController.reverse());
    context.read<WaterProvider>().logWater(glassSize: _selectedGlassSize);
  }

  void _removeWater() {
    HapticFeedback.lightImpact();
    context.read<WaterProvider>().removeLastEntry();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FAFA),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, color: Color(0xFF2D2D3A)), onPressed: () => Navigator.pop(context)),
        title: const Text('Hydration Tracker', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, color: Color(0xFF2D2D3A), fontSize: 20)),
        centerTitle: true,
      ),
      body: Consumer<WaterProvider>(
        builder: (context, water, _) {
          return RefreshIndicator(
            onRefresh: () => water.loadAll(),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                const SizedBox(height: 8),
                _buildProgressCard(water),
                const SizedBox(height: 20),
                _buildGlassSizeSelector(),
                const SizedBox(height: 20),
                _buildActionButtons(water),
                const SizedBox(height: 24),
                _buildStatsRow(water),
                const SizedBox(height: 24),
                _buildTabBar(),
                const SizedBox(height: 16),
                if (_selectedTab == 0) _buildDailyView(water),
                if (_selectedTab == 1) _buildWeeklyView(water),
                if (_selectedTab == 2) _buildMonthlyView(water),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgressCard(WaterProvider water) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF2EC4B6), Color(0xFF20A4F3)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [BoxShadow(color: const Color(0xFF2EC4B6).withOpacity(0.3), blurRadius: 24, offset: const Offset(0, 10))],
      ),
      child: Column(children: [
        ScaleTransition(
          scale: _pulseAnimation,
          child: SizedBox(
            width: 180, height: 180,
            child: CustomPaint(
              painter: _WaterRingPainter(water.percentage / 100),
              child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text('${water.glasses}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 48, fontWeight: FontWeight.w800, color: Colors.white)),
                Text('of ${(water.goalMl / _selectedGlassSize).ceil()} glasses', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Colors.white.withOpacity(0.8))),
              ])),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text('${water.totalMl} ml / ${water.goalMl} ml', style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
        const SizedBox(height: 4),
        if (water.remaining > 0)
          Text('${water.remaining} ml remaining', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.white.withOpacity(0.7)))
        else
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text('🎉', style: TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text('Goal achieved!', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white.withOpacity(0.95))),
          ]),
      ]),
    );
  }

  Widget _buildGlassSizeSelector() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Glass Size', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF2D2D3A))),
      const SizedBox(height: 10),
      Row(children: List.generate(_glassSizes.length, (i) {
        final selected = _selectedGlassSize == _glassSizes[i];
        return Expanded(child: Padding(
          padding: EdgeInsets.only(right: i < _glassSizes.length - 1 ? 8 : 0),
          child: GestureDetector(
            onTap: () { HapticFeedback.selectionClick(); setState(() => _selectedGlassSize = _glassSizes[i]); },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: selected ? const Color(0xFF2EC4B6).withOpacity(0.12) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: selected ? const Color(0xFF2EC4B6) : const Color(0xFFE8E8EE), width: 1.5),
              ),
              child: Column(children: [
                Text('💧', style: TextStyle(fontSize: selected ? 18 : 14)),
                const SizedBox(height: 4),
                Text(_glassLabels[i], style: TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: selected ? FontWeight.w700 : FontWeight.w500, color: selected ? const Color(0xFF2EC4B6) : const Color(0xFF9E9EA8))),
              ]),
            ),
          ),
        ));
      })),
    ]);
  }

  Widget _buildActionButtons(WaterProvider water) {
    return Row(children: [
      Expanded(
        child: GestureDetector(
          onTap: water.glasses > 0 ? _removeWater : null,
          child: Container(
            height: 56, alignment: Alignment.center,
            decoration: BoxDecoration(
              color: water.glasses > 0 ? Colors.white : const Color(0xFFF0F0F4),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE8E8EE)),
            ),
            child: const Icon(Icons.remove_rounded, color: Color(0xFF9E9EA8), size: 28),
          ),
        ),
      ),
      const SizedBox(width: 16),
      Expanded(
        flex: 3,
        child: GestureDetector(
          onTap: _addWater,
          child: Container(
            height: 56, alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF2EC4B6), Color(0xFF20A4F3)]),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: const Color(0xFF2EC4B6).withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.add_rounded, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Text('Add ${_selectedGlassSize}ml', style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
            ]),
          ),
        ),
      ),
    ]);
  }

  Widget _buildStatsRow(WaterProvider water) {
    return Row(children: [
      _buildStatCard('🔥', '${water.streak}', 'Day Streak', const Color(0xFFFF9A3C)),
      const SizedBox(width: 12),
      _buildStatCard('💧', '${water.percentage}%', 'Today', const Color(0xFF2EC4B6)),
      const SizedBox(width: 12),
      _buildStatCard('⚡', '${water.glasses}', 'Glasses', const Color(0xFF8B7EC8)),
    ]);
  }

  Widget _buildStatCard(String emoji, String value, String label, Color color) {
    return Expanded(child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: color.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 6),
        Text(value, style: TextStyle(fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.w800, color: color)),
        Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF9E9EA8))),
      ]),
    ));
  }

  Widget _buildTabBar() {
    final tabs = ['Daily', 'Weekly', 'Monthly'];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(children: List.generate(3, (i) => Expanded(child: GestureDetector(
        onTap: () {
          setState(() => _selectedTab = i);
          if (i == 1) context.read<WaterProvider>().loadWeeklyStats();
          if (i == 2) context.read<WaterProvider>().loadMonthlyStats();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: _selectedTab == i ? const Color(0xFF2EC4B6) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(tabs[i], textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w700, color: _selectedTab == i ? Colors.white : const Color(0xFF9E9EA8))),
        ),
      )))),
    );
  }

  Widget _buildDailyView(WaterProvider water) {
    final entries = water.todayProgress?['entries'] as List? ?? [];
    if (entries.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32), alignment: Alignment.center,
        child: Column(children: [
          const Text('💧', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          const Text('No water logged yet today', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Color(0xFF9E9EA8))),
          const SizedBox(height: 4),
          const Text('Tap the + button to start tracking!', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFFCCCCD4))),
        ]),
      );
    }
    return Column(children: List.generate(entries.length, (i) {
      final e = entries[i] is Map ? entries[i] : {};
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Row(children: [
          const Text('💧', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 12),
          Text('${e['amount'] ?? _selectedGlassSize} ml', style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600)),
          const Spacer(),
          Text(e['time'] ?? '', style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF9E9EA8))),
        ]),
      );
    }));
  }

  Widget _buildWeeklyView(WaterProvider water) {
    final days = (water.weeklyStats?['days'] as List?) ?? [];
    if (days.isEmpty) return const Center(child: CircularProgressIndicator());
    final maxMl = days.fold<int>(1, (m, d) => max(m, (d['goalMl'] as int?) ?? 2000));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('${water.weeklyStats?['completionRate'] ?? 0}% completion', style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF2D2D3A))),
          Text('Avg ${water.weeklyStats?['avgIntake'] ?? 0} ml/day', style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF9E9EA8))),
        ]),
        const SizedBox(height: 20),
        SizedBox(
          height: 140,
          child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: List.generate(days.length, (i) {
            final d = days[i];
            final pct = min(1.0, (d['totalMl'] ?? 0) / maxMl);
            final met = d['goalMet'] == true;
            return Expanded(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                Text('${d['totalMl'] ?? 0}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 9, color: Color(0xFF9E9EA8))),
                const SizedBox(height: 4),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: max(8.0, 100 * pct),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: met ? [const Color(0xFF2EC4B6), const Color(0xFF20A4F3)] : [const Color(0xFFE0E0E8), const Color(0xFFE0E0E8)],
                      begin: Alignment.bottomCenter, end: Alignment.topCenter,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 6),
                Text(d['dayLabel'] ?? '', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w600, color: met ? const Color(0xFF2EC4B6) : const Color(0xFF9E9EA8))),
              ]),
            ));
          })),
        ),
      ]),
    );
  }

  Widget _buildMonthlyView(WaterProvider water) {
    final days = (water.monthlyStats?['days'] as List?) ?? [];
    if (days.isEmpty) return const Center(child: CircularProgressIndicator());

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('${water.monthlyStats?['completionRate'] ?? 0}% completion', style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w700)),
          Text('${water.monthlyStats?['daysCompleted'] ?? 0}/30 days', style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF9E9EA8))),
        ]),
        const SizedBox(height: 16),
        Wrap(spacing: 6, runSpacing: 6, children: List.generate(days.length, (i) {
          final met = days[i]['goalMet'] == true;
          return Container(
            width: 28, height: 28,
            decoration: BoxDecoration(
              color: met ? const Color(0xFF2EC4B6) : const Color(0xFFF0F0F4),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(child: Text('${i + 1}', style: TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w600, color: met ? Colors.white : const Color(0xFF9E9EA8)))),
          );
        })),
      ]),
    );
  }
}

class _WaterRingPainter extends CustomPainter {
  final double progress;
  _WaterRingPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 12;

    final bgPaint = Paint()..color = Colors.white.withOpacity(0.2)..style = PaintingStyle.stroke..strokeWidth = 10..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    final fgPaint = Paint()
      ..shader = const LinearGradient(colors: [Colors.white, Color(0xFFB0F0E8)]).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke..strokeWidth = 10..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2, 2 * pi * progress.clamp(0.0, 1.0), false, fgPaint);
  }

  @override
  bool shouldRepaint(covariant _WaterRingPainter old) => old.progress != progress;
}
