import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/cycle_sync_button.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final List<_JournalEntry> _entries = [
    _JournalEntry(
      'Feeling great today!',
      'Had lots of energy...',
      '😊',
      'Happy',
      DateTime.now().subtract(const Duration(days: 0)),
    ),
    _JournalEntry(
      'A bit tired',
      'Work was exhausting...',
      '😴',
      'Tired',
      DateTime.now().subtract(const Duration(days: 1)),
    ),
    _JournalEntry(
      'Productive morning',
      'Completed all tasks...',
      '😌',
      'Calm',
      DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  Color _moodBorder(String mood) {
    switch (mood) {
      case 'Happy':
        return AppColors.goldenGlow;
      case 'Sad':
        return AppColors.skyBreeze;
      case 'Anxious':
        return AppColors.lavenderDream;
      case 'Angry':
        return AppColors.deepBurgundy;
      default:
        return AppColors.dividerColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final moods = ['😊', '😢', '😌', '😤', '😊', '😴', '😊'];
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text('My Journal 📓'),
        actions: [
          TextButton.icon(
            onPressed: () => _showAddJournal(context),
            icon: const Icon(Icons.add_rounded, color: AppColors.crimsonHeart),
            label: const Text(
              'New Entry',
              style: TextStyle(color: AppColors.crimsonHeart),
            ),
          ),
        ],
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
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(7, (i) {
                    final isToday = i == DateTime.now().weekday - 1;
                    return Column(
                      children: [
                        Text(
                          moods[i],
                          style: TextStyle(fontSize: isToday ? 28 : 22),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          days[i],
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11,
                            fontWeight: isToday
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: isToday
                                ? AppColors.crimsonHeart
                                : AppColors.textLight,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ..._entries.map(
            (entry) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardSurface,
                borderRadius: BorderRadius.circular(20),
                border: Border(
                  left: BorderSide(color: _moodBorder(entry.mood), width: 3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(entry.emoji, style: const TextStyle(fontSize: 20)),
                      const Spacer(),
                      Text(
                        _formatDate(entry.date),
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    entry.title,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    entry.preview,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    return '${d.day}/${d.month}/${d.year}';
  }

  void _showAddJournal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.95,
        builder: (_, ctrl) => Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: AppColors.cardSurface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          child: ListView(
            controller: ctrl,
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
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Give it a title...',
                  hintStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textLight,
                  ),
                  border: InputBorder.none,
                ),
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 52,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: '😊😢😌😤😴😰🥰'
                      .split('')
                      .map(
                        (e) => Container(
                          width: 44,
                          height: 44,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: AppColors.cardSoft,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Center(
                            child: Text(
                              e,
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 16),
              const TextField(
                maxLines: 8,
                decoration: InputDecoration(
                  hintText: 'How are you feeling?',
                  hintStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: AppColors.textLight,
                  ),
                  border: InputBorder.none,
                  filled: true,
                  fillColor: AppColors.inputFill,
                ),
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  _ToolBtn(Icons.photo_library_outlined, 'Photo'),
                  const SizedBox(width: 12),
                  _ToolBtn(Icons.label_outline, 'Tag'),
                  const SizedBox(width: 12),
                  _ToolBtn(Icons.lock_outline, 'Private'),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                text: '💾 Save Entry',
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToolBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ToolBtn(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.inputFill,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: AppColors.crimsonHeart),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: AppColors.crimsonHeart,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _JournalEntry {
  final String title;
  final String preview;
  final String emoji;
  final String mood;
  final DateTime date;
  _JournalEntry(this.title, this.preview, this.emoji, this.mood, this.date);
}
