import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/analytics_provider.dart';

class AnalyticsDashboardScreen extends StatefulWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  State<AnalyticsDashboardScreen> createState() => _AnalyticsDashboardScreenState();
}

class _AnalyticsDashboardScreenState extends State<AnalyticsDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AnalyticsProvider>().loadDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, color: Color(0xFF2D2D3A)), onPressed: () => Navigator.pop(context)),
        title: const Text('Health Analytics', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, color: Color(0xFF2D2D3A), fontSize: 20)),
        centerTitle: true,
      ),
      body: Consumer<AnalyticsProvider>(
        builder: (context, analytics, _) {
          if (analytics.isLoading) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFFF6B9D)));
          }
          final dashboard = analytics.dashboard;
          return RefreshIndicator(
            onRefresh: () => analytics.loadDashboard(),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                const SizedBox(height: 8),
                _buildHealthScoreCard(analytics),
                const SizedBox(height: 20),
                _buildSectionTitle('Cycle Health'),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: _buildMetricCard('Cycle Length', '${dashboard?['cycleStats']?['avgCycleLength'] ?? '--'}', 'days avg', Icons.loop_rounded, const Color(0xFFFF6B9D))),
                  const SizedBox(width: 12),
                  Expanded(child: _buildMetricCard('Period Length', '${dashboard?['cycleStats']?['avgPeriodLength'] ?? '--'}', 'days avg', Icons.water_drop_rounded, const Color(0xFFE8647A))),
                ]),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: _buildMetricCard('Consistency', '${dashboard?['cycleStats']?['consistency'] ?? 0}%', dashboard?['cycleStats']?['isIrregular'] == true ? 'Irregular' : 'Regular', Icons.timeline_rounded, const Color(0xFF8B7EC8))),
                  const SizedBox(width: 12),
                  Expanded(child: _buildMetricCard('Tracked', '${dashboard?['cycleStats']?['totalTracked'] ?? 0}', 'cycles', Icons.analytics_rounded, const Color(0xFF6BAF8A))),
                ]),
                const SizedBox(height: 24),
                _buildSectionTitle('Hydration'),
                const SizedBox(height: 12),
                _buildWideMetricCard(
                  'Water Goal Completion',
                  dashboard?['waterStats']?['weeklyCompletion'] ?? 0,
                  dashboard?['waterStats']?['monthlyCompletion'] ?? 0,
                  dashboard?['waterStats']?['avgDailyIntake'] ?? 0,
                  const Color(0xFF2EC4B6),
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Medicine & Mood'),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: _buildMetricCard('Medicine', '${dashboard?['medicineStats']?['compliance'] ?? 0}%', '${dashboard?['medicineStats']?['totalActive'] ?? 0} active', Icons.medication_rounded, const Color(0xFF6BAF8A))),
                  const SizedBox(width: 12),
                  Expanded(child: _buildMetricCard('Mood', '${dashboard?['moodStats']?['weeklyAverage'] ?? '--'}', _getTrendLabel(dashboard?['moodStats']?['trend']), Icons.mood_rounded, const Color(0xFFE8A87C))),
                ]),
                const SizedBox(height: 24),
                _buildSectionTitle('Weight'),
                const SizedBox(height: 12),
                _buildWeightCard(dashboard?['weightStats']),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHealthScoreCard(AnalyticsProvider analytics) {
    final score = analytics.overallScore;
    final grade = analytics.grade;
    final color = score >= 80 ? const Color(0xFF6BAF8A) : score >= 60 ? const Color(0xFFD4A843) : score >= 40 ? const Color(0xFFE8A87C) : const Color(0xFFE8647A);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color.withOpacity(0.9), color], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 24, offset: const Offset(0, 10))],
      ),
      child: Row(children: [
        SizedBox(
          width: 100, height: 100,
          child: CustomPaint(
            painter: _ScoreRingPainter(score / 100, Colors.white),
            child: Center(child: Text('$score', style: const TextStyle(fontFamily: 'Poppins', fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white))),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Health Score', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Colors.white70)),
          const SizedBox(height: 4),
          Text(grade, style: const TextStyle(fontFamily: 'Poppins', fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
          const SizedBox(height: 8),
          _buildBreakdownBar('Cycle', analytics.breakdown['cycleRegularity'] ?? 0),
          _buildBreakdownBar('Water', analytics.breakdown['waterGoal'] ?? 0),
          _buildBreakdownBar('Medicine', analytics.breakdown['medicineCompliance'] ?? 0),
          _buildBreakdownBar('Mood', analytics.breakdown['moodStability'] ?? 0),
          _buildBreakdownBar('Logging', analytics.breakdown['loggingConsistency'] ?? 0),
        ])),
      ]),
    );
  }

  Widget _buildBreakdownBar(String label, int value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(children: [
        SizedBox(width: 52, child: Text(label, style: TextStyle(fontFamily: 'Poppins', fontSize: 9, color: Colors.white.withOpacity(0.7)))),
        Expanded(child: ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(value: value / 100, backgroundColor: Colors.white.withOpacity(0.15), valueColor: const AlwaysStoppedAnimation(Colors.white), minHeight: 4),
        )),
        const SizedBox(width: 6),
        Text('$value', style: TextStyle(fontFamily: 'Poppins', fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white.withOpacity(0.8))),
      ]),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF2D2D3A)));
  }

  Widget _buildMetricCard(String title, String value, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(22),
        boxShadow: [BoxShadow(color: color.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 14),
        Text(value, style: TextStyle(fontFamily: 'Poppins', fontSize: 24, fontWeight: FontWeight.w800, color: color)),
        const SizedBox(height: 2),
        Text(title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2D2D3A))),
        Text(subtitle, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF9E9EA8))),
      ]),
    );
  }

  Widget _buildWideMetricCard(String title, int weeklyPct, int monthlyPct, int avgIntake, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(22),
        boxShadow: [BoxShadow(color: color.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)), child: Icon(Icons.water_drop_rounded, color: color, size: 20)),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF2D2D3A))),
        ]),
        const SizedBox(height: 18),
        Row(children: [
          Expanded(child: _buildProgressCol('This Week', weeklyPct, color)),
          const SizedBox(width: 16),
          Expanded(child: _buildProgressCol('This Month', monthlyPct, color)),
          const SizedBox(width: 16),
          Expanded(child: Column(children: [
            Text('$avgIntake', style: TextStyle(fontFamily: 'Poppins', fontSize: 22, fontWeight: FontWeight.w800, color: color)),
            const Text('ml/day avg', style: TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Color(0xFF9E9EA8))),
          ])),
        ]),
      ]),
    );
  }

  Widget _buildProgressCol(String label, int pct, Color color) {
    return Column(children: [
      SizedBox(
        width: 52, height: 52,
        child: CustomPaint(
          painter: _ScoreRingPainter(pct / 100, color),
          child: Center(child: Text('$pct%', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w800, color: color))),
        ),
      ),
      const SizedBox(height: 6),
      Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Color(0xFF9E9EA8))),
    ]);
  }

  Widget _buildWeightCard(Map<String, dynamic>? stats) {
    final current = stats?['current'];
    final change = stats?['change'];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), boxShadow: [BoxShadow(color: const Color(0xFFFF6B9D).withOpacity(0.08), blurRadius: 16, offset: const Offset(0, 4))]),
      child: Row(children: [
        Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFFFE4EC), borderRadius: BorderRadius.circular(16)), child: const Icon(Icons.monitor_weight_outlined, color: Color(0xFFFF6B9D), size: 24)),
        const SizedBox(width: 16),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(current != null ? '$current ${stats?['unit'] ?? 'kg'}' : 'No data', style: const TextStyle(fontFamily: 'Poppins', fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF2D2D3A))),
          if (change != null) Row(children: [
            Icon(change > 0 ? Icons.trending_up : change < 0 ? Icons.trending_down : Icons.trending_flat, size: 16, color: change > 0 ? const Color(0xFFE8647A) : const Color(0xFF6BAF8A)),
            const SizedBox(width: 4),
            Text('${change > 0 ? '+' : ''}$change ${stats?['unit'] ?? 'kg'} recent', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: change > 0 ? const Color(0xFFE8647A) : const Color(0xFF6BAF8A))),
          ]),
        ]),
      ]),
    );
  }

  String _getTrendLabel(String? trend) {
    switch (trend) {
      case 'improving': return '📈 Improving';
      case 'declining': return '📉 Declining';
      default: return '➡️ Stable';
    }
  }
}

class _ScoreRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  _ScoreRingPainter(this.progress, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 5;
    final bg = Paint()..color = color.withOpacity(0.15)..style = PaintingStyle.stroke..strokeWidth = 6..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bg);
    final fg = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 6..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2, 2 * pi * progress.clamp(0.0, 1.0), false, fg);
  }

  @override
  bool shouldRepaint(covariant _ScoreRingPainter old) => old.progress != progress;
}
