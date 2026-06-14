import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/cycle_provider.dart';
import '../../../shared/widgets/cycle_sync_button.dart';
import '../../../router/app_router.dart';
import '../../../core/utils/cycle_utils.dart';

class PremiumCalendarScreen extends StatefulWidget {
  const PremiumCalendarScreen({super.key});

  @override
  State<PremiumCalendarScreen> createState() => _PremiumCalendarScreenState();
}

class _PremiumCalendarScreenState extends State<PremiumCalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _format = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CycleProvider>().loadPremiumCalendar(
        _focusedDay.month,
        _focusedDay.year,
      );
      context.read<CycleProvider>().loadDashboard();
    });
  }

  void _onPageChanged(DateTime focused) {
    setState(() => _focusedDay = focused);
    context.read<CycleProvider>().loadPremiumCalendar(
      focused.month,
      focused.year,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cycleProvider = context.watch<CycleProvider>();
    final calendarData =
        cycleProvider.calendarData?['days'] as List<dynamic>? ?? [];
    final prediction = cycleProvider.prediction;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 100,
            floating: true,
            pinned: true,
            backgroundColor: const Color(0xFFFFF0E8),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                DateFormat('MMMM yyyy').format(_focusedDay),
                style: const TextStyle(
                  fontFamily: 'PlayfairDisplay',
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D2D3A),
                ),
              ),
              centerTitle: true,
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.add_circle_rounded,
                  color: Color(0xFFE8647A),
                ),
                onPressed: () =>
                    Navigator.pushNamed(context, AppRouter.periodLog),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE8647A).withOpacity(0.06),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                child: Column(
                  children: [
                    TableCalendar(
                      firstDay: DateTime(2020),
                      lastDay: DateTime(2030),
                      focusedDay: _focusedDay,
                      calendarFormat: _format,
                      onFormatChanged: (f) => setState(() => _format = f),
                      selectedDayPredicate: (day) =>
                          isSameDay(_selectedDay, day),
                      onDaySelected: (selected, focused) {
                        setState(() {
                          _selectedDay = selected;
                          _focusedDay = focused;
                        });
                      },
                      onPageChanged: _onPageChanged,
                      calendarStyle: CalendarStyle(
                        todayDecoration: const BoxDecoration(
                          color: Color(0xFFE8647A),
                          shape: BoxShape.circle,
                        ),
                        todayTextStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                        selectedDecoration: BoxDecoration(
                          color: const Color(0xFF2D2D3A),
                          shape: BoxShape.circle,
                        ),
                        selectedTextStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        defaultTextStyle: const TextStyle(
                          color: Color(0xFF2D2D3A),
                          fontWeight: FontWeight.w500,
                        ),
                        weekendTextStyle: const TextStyle(
                          color: Color(0xFF9E9EA8),
                          fontWeight: FontWeight.w500,
                        ),
                        outsideTextStyle: const TextStyle(
                          color: Color(0xFFD0D0D8),
                        ),
                        cellMargin: const EdgeInsets.all(3),
                        markerDecoration: const BoxDecoration(
                          color: Color(0xFFE8647A),
                          shape: BoxShape.circle,
                        ),
                      ),
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: true,
                        titleCentered: true,
                        formatButtonTextStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          color: Color(0xFFE8647A),
                          fontWeight: FontWeight.w600,
                        ),
                        formatButtonDecoration: BoxDecoration(
                          color: Color(0xFFFFE8EC),
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        leftChevronIcon: const Icon(
                          Icons.chevron_left_rounded,
                          color: Color(0xFFE8647A),
                        ),
                        rightChevronIcon: const Icon(
                          Icons.chevron_right_rounded,
                          color: Color(0xFFE8647A),
                        ),
                      ),
                      calendarBuilders: CalendarBuilders(
                        markerBuilder: (context, date, events) {
                          final dayData = _findDayData(calendarData, date);
                          if (dayData == null) return null;
                          final indicator = _DayIndicator(dayData: dayData);
                          final hasMarker =
                              dayData['events'] is List &&
                                  (dayData['events'] as List).isNotEmpty ||
                              dayData['isOvulation'] == true ||
                              dayData['isFertile'] == true;
                          if (!hasMarker) return null;
                          return Positioned(bottom: 1, child: indicator);
                        },
                        defaultBuilder: (context, date, _) {
                          final dayData = _findDayData(calendarData, date);
                          if (dayData == null) return null;
                          final phase = dayData['phase'] as String?;
                          final isToday = isSameDay(date, DateTime.now());
                          final isSelected = isSameDay(date, _selectedDay);
                          Color? bgColor;
                          if (phase != null && !isToday && !isSelected) {
                            bgColor = Color(
                              CycleUtils.getPhaseColor(phase),
                            ).withOpacity(0.15);
                          }
                          return Container(
                            decoration: BoxDecoration(
                              color: bgColor,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${date.day}',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: isToday
                                    ? Colors.white
                                    : const Color(0xFF2D2D3A),
                              ),
                            ),
                          );
                        },
                      ),
                      eventLoader: (day) {
                        final dayData = _findDayData(calendarData, day);
                        if (dayData != null &&
                            (dayData['events'] as List?)?.contains('period') ==
                                true) {
                          return [dayData];
                        }
                        return [];
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  _LegendItem(const Color(0xFF810B38), 'Menstrual'),
                  _LegendItem(const Color(0xFFFF97D0), 'Follicular'),
                  _LegendItem(const Color(0xFFF0E76F), 'Ovulation'),
                  _LegendItem(const Color(0xFF744577), 'Luteal'),
                  _LegendItem(const Color(0xFF9FA1FF), 'Fertile'),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
              child: Row(
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
                  if (prediction != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F0FF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Day ${prediction['currentCycleDay'] ?? '-'}',
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
            ),
          ),
          if (_selectedDay != null || prediction != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: _DailyCommandCenter(
                  selectedDay: _selectedDay ?? DateTime.now(),
                  dayData: _findDayData(calendarData, _selectedDay ?? DateTime.now()),
                  prediction: prediction,
                ),
              ),
            ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
              child: PrimaryButton(
                text: prediction != null
                    ? 'Log Period for Today 🌸'
                    : 'Log Your First Period 🌸',
                onPressed: () =>
                    Navigator.pushNamed(context, AppRouter.periodLog),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic>? _findDayData(
    List<dynamic> calendarDays,
    DateTime date,
  ) {
    for (final day in calendarDays) {
      final dayDate = DateTime.tryParse(day['date']?.toString() ?? '');
      if (dayDate != null && isSameDay(dayDate, date)) {
        return day as Map<String, dynamic>;
      }
    }
    return null;
  }
}

class _DayIndicator extends StatelessWidget {
  final Map<String, dynamic> dayData;
  const _DayIndicator({required this.dayData});

  @override
  Widget build(BuildContext context) {
    final events = dayData['events'] as List? ?? [];
    final flow = dayData['flow'] as String?;
    final isFertile = dayData['isFertile'] == true;
    final isOvulation = dayData['isOvulation'] == true;

    if (events.contains('period') && flow != null) {
      final color = flow == 'heavy'
          ? const Color(0xFF810B38)
          : flow == 'medium'
          ? const Color(0xFFE8647A)
          : flow == 'light'
          ? const Color(0xFFFF97D0)
          : const Color(0xFFFFCF95);
      return Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
    }
    if (events.contains('period')) {
      return Container(
        width: 6,
        height: 6,
        decoration: const BoxDecoration(
          color: Color(0xFFE8647A),
          shape: BoxShape.circle,
        ),
      );
    }
    if (isOvulation) {
      return Container(
        width: 6,
        height: 6,
        decoration: const BoxDecoration(
          color: Color(0xFFF0E76F),
          shape: BoxShape.circle,
        ),
      );
    }
    if (isFertile) {
      return Container(
        width: 6,
        height: 6,
        decoration: const BoxDecoration(
          color: Color(0xFF9FA1FF),
          shape: BoxShape.circle,
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendItem(this.color, this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 9,
              color: Color(0xFF9E9EA8),
            ),
          ),
        ],
      ),
    );
  }
}

class _PredictionSummary extends StatelessWidget {
  final Map<String, dynamic> prediction;
  const _PredictionSummary({required this.prediction});

  @override
  Widget build(BuildContext context) {
    final phase = prediction['currentPhase'] as String? ?? 'menstrual';
    final phaseName = CycleUtils.getPhaseNameBn(
      prediction['currentCycleDay'] ?? 1,
      prediction['avgCycleLength'] ?? 28,
    );
    final phaseEmoji = CycleUtils.getPhaseEmoji(
      prediction['currentCycleDay'] ?? 1,
      prediction['avgCycleLength'] ?? 28,
    );
    final nextPeriod = prediction['nextPeriodDate'] != null
        ? DateFormat(
            'MMM d',
          ).format(DateTime.parse(prediction['nextPeriodDate'].toString()))
        : '-';
    final ovulation = prediction['ovulationDate'] != null
        ? DateFormat(
            'MMM d',
          ).format(DateTime.parse(prediction['ovulationDate'].toString()))
        : '-';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFFF3F0FF), const Color(0xFFFFF0F7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '$phaseEmoji $phaseName',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D2D3A),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Color(
                    CycleUtils.getPhaseColor(phase),
                  ).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${prediction['daysUntilNext'] ?? '-'} days left',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(CycleUtils.getPhaseColor(phase)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _MiniStat(label: 'Next Period', value: nextPeriod),
              _MiniStat(label: 'Ovulation', value: ovulation),
              _MiniStat(
                label: 'Cycle',
                value: '${prediction['avgCycleLength'] ?? 28}d',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2D2D3A),
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 10,
              color: Color(0xFF9E9EA8),
            ),
          ),
        ],
      ),
    );
  }
}

class _DailyCommandCenter extends StatelessWidget {
  final DateTime selectedDay;
  final Map<String, dynamic>? dayData;
  final Map<String, dynamic>? prediction;

  const _DailyCommandCenter({
    required this.selectedDay,
    this.dayData,
    this.prediction,
  });

  @override
  Widget build(BuildContext context) {
    final isToday = isSameDay(selectedDay, DateTime.now());
    final phase = dayData?['phase'] as String? ?? prediction?['currentPhase'] as String? ?? 'menstrual';
    
    final mood = dayData?['mood'];
    final water = dayData?['water'];
    final medicines = dayData?['medicines'] as List<dynamic>? ?? [];
    final symptoms = dayData?['symptoms'] as List<dynamic>? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isToday && prediction != null) ...[
          _PredictionSummary(prediction: prediction!),
          const SizedBox(height: 16),
        ],
        
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isToday ? 'Today\'s Log' : DateFormat('MMMM d, yyyy').format(selectedDay),
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2D2D3A),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(CycleUtils.getPhaseColor(phase)).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      phase.toUpperCase(),
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(CycleUtils.getPhaseColor(phase)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Mood & Water Row
              Row(
                children: [
                  Expanded(
                    child: _LogMetricCard(
                      icon: Icons.mood_rounded,
                      color: const Color(0xFF8B7EC8),
                      title: 'Mood',
                      value: mood != null ? mood['label'] ?? 'Logged' : 'None',
                      hasData: mood != null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _LogMetricCard(
                      icon: Icons.water_drop_rounded,
                      color: const Color(0xFF2EC4B6),
                      title: 'Water',
                      value: water != null ? '${water['glasses']}/${water['goal']} glasses' : '0 glasses',
                      hasData: water != null && water['glasses'] > 0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Medicine & Symptoms Row
              Row(
                children: [
                  Expanded(
                    child: _LogMetricCard(
                      icon: Icons.medication_rounded,
                      color: const Color(0xFFE8647A),
                      title: 'Medicine',
                      value: medicines.isNotEmpty ? '${medicines.where((m) => m['taken'] == true).length}/${medicines.length} taken' : 'None scheduled',
                      hasData: medicines.isNotEmpty,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _LogMetricCard(
                      icon: Icons.healing_rounded,
                      color: const Color(0xFFD4A843),
                      title: 'Symptoms',
                      value: symptoms.isNotEmpty ? '${symptoms.length} logged' : 'None',
                      hasData: symptoms.isNotEmpty,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LogMetricCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String value;
  final bool hasData;

  const _LogMetricCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.value,
    required this.hasData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: hasData ? color.withOpacity(0.08) : const Color(0xFFF8F8FC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasData ? color.withOpacity(0.2) : Colors.transparent,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: hasData ? color : const Color(0xFF9E9EA8)),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: hasData ? color : const Color(0xFF9E9EA8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: hasData ? const Color(0xFF2D2D3A) : const Color(0xFF9E9EA8),
            ),
          ),
        ],
      ),
    );
  }
}
