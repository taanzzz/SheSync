import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/cycle_provider.dart';
import '../../../shared/widgets/phase_badge.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  // ignore: unused_field
  Map<DateTime, List<Map<String, dynamic>>> _events = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CycleProvider>().loadCycles();
      context.read<CycleProvider>().loadPrediction();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cycleProvider = context.watch<CycleProvider>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(title: Text(DateFormat('MMMM yyyy').format(_focusedDay))),
      body: Column(
        children: [
          _MonthSelector(
            selectedMonth: _focusedDay,
            onChanged: (m) => setState(() {
              _focusedDay = DateTime(_focusedDay.year, m, _focusedDay.day);
            }),
          ),
          TableCalendar(
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selected, focused) {
              setState(() {
                _selectedDay = selected;
                _focusedDay = focused;
              });
            },
            onPageChanged: (focused) => _focusedDay = focused,
            calendarStyle: CalendarStyle(
              todayDecoration: const BoxDecoration(
                color: AppColors.crimsonHeart,
                shape: BoxShape.circle,
              ),
              todayTextStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              selectedDecoration: BoxDecoration(
                color: AppColors.roseBlush.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              defaultDecoration: const BoxDecoration(shape: BoxShape.circle),
              markerDecoration: const BoxDecoration(
                color: AppColors.deepBurgundy,
                shape: BoxShape.circle,
              ),
              cellMargin: const EdgeInsets.all(4),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: AppColors.crimsonHeart,
                fontSize: 16,
              ),
              leftChevronIcon: Icon(
                Icons.chevron_left_rounded,
                color: AppColors.crimsonHeart,
              ),
              rightChevronIcon: Icon(
                Icons.chevron_right_rounded,
                color: AppColors.crimsonHeart,
              ),
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  return Positioned(
                    bottom: 2,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: _isPeriodDay(date, cycleProvider.cycles)
                            ? AppColors.deepBurgundy
                            : AppColors.roseBlush,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }
                return null;
              },
            ),
            eventLoader: (day) {
              final cycles = cycleProvider.cycles;
              for (final cycle in cycles) {
                final start = DateTime.parse(cycle['startDate'].toString());
                if (isSameDay(day, start)) return [cycle];
              }
              return [];
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _LegendItem(AppColors.deepBurgundy, 'Menstrual'),
                const SizedBox(width: 12),
                _LegendItem(AppColors.roseBlush, 'Follicular'),
                const SizedBox(width: 12),
                _LegendItem(AppColors.goldenGlow, 'Ovulation'),
                const SizedBox(width: 12),
                _LegendItem(AppColors.mysticPlum, 'Luteal'),
              ],
            ),
          ),
          const Divider(height: 1),
          if (_selectedDay != null)
            Expanded(
              child: _DayDetailSheet(
                day: _selectedDay!,
                cycleProvider: cycleProvider,
              ),
            ),
        ],
      ),
    );
  }

  bool _isPeriodDay(DateTime day, List<dynamic> cycles) {
    for (final cycle in cycles) {
      final start = DateTime.parse(cycle['startDate'].toString());
      if (isSameDay(day, start)) return true;
    }
    return false;
  }
}

class _MonthSelector extends StatelessWidget {
  final DateTime selectedMonth;
  final ValueChanged<int> onChanged;

  const _MonthSelector({required this.selectedMonth, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: 12,
        itemBuilder: (context, index) {
          final month = index + 1;
          final isActive = month == selectedMonth.month;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onChanged(month),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.crimsonHeart : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  DateFormat('MMM').format(DateTime(2024, month)),
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                    color: isActive ? Colors.white : AppColors.textLight,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendItem(this.color, this.label);

  @override
  Widget build(BuildContext context) {
    return Row(
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
            fontSize: 10,
            color: AppColors.textLight,
          ),
        ),
      ],
    );
  }
}

class _DayDetailSheet extends StatelessWidget {
  final DateTime day;
  final CycleProvider cycleProvider;

  const _DayDetailSheet({required this.day, required this.cycleProvider});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    DateFormat('EEEE, MMMM d').format(day),
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const PhaseBadge(phase: 'follicular', fontSize: 9),
              ],
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                _DetailSection(
                  icon: Icons.water_drop_rounded,
                  label: 'Period',
                  value: 'No data',
                ),
                SizedBox(width: 16),
                _DetailSection(
                  icon: Icons.healing_rounded,
                  label: 'Symptoms',
                  value: '2 logged',
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Row(
              children: [
                _DetailSection(
                  icon: Icons.emoji_emotions_rounded,
                  label: 'Mood',
                  value: 'Happy 😊',
                ),
                SizedBox(width: 16),
                _DetailSection(
                  icon: Icons.medication_rounded,
                  label: 'Medicine',
                  value: '3 taken',
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.edit_rounded,
                  size: 18,
                  color: AppColors.crimsonHeart,
                ),
                label: const Text(
                  'Add Log for this day',
                  style: TextStyle(color: AppColors.crimsonHeart),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.crimsonHeart),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailSection({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.cardSoft,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.crimsonHeart),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10,
                      color: AppColors.textLight,
                    ),
                  ),
                  Text(
                    value,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
