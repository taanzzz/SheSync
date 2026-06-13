import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/symptom_provider.dart';
import '../../../shared/widgets/cycle_sync_button.dart';

class SymptomLogScreen extends StatefulWidget {
  const SymptomLogScreen({super.key});

  @override
  State<SymptomLogScreen> createState() => _SymptomLogScreenState();
}

class _SymptomLogScreenState extends State<SymptomLogScreen> {
  final List<Map<String, dynamic>> _selectedSymptoms = [];
  final Map<String, int> _severities = {};
  String _activeCategory = 'All';

  final List<_SymptomItem> _allSymptoms = [
    _SymptomItem('Cramps', '😣', 'Physical'),
    _SymptomItem('Bloating', '😤', 'Physical'),
    _SymptomItem('Headache', '🤕', 'Physical'),
    _SymptomItem('Fatigue', '😴', 'Physical'),
    _SymptomItem('Nausea', '🤢', 'Digestive'),
    _SymptomItem('Backache', '😩', 'Physical'),
    _SymptomItem('Anxiety', '😰', 'Emotional'),
    _SymptomItem('Sad mood', '😢', 'Emotional'),
    _SymptomItem('Irritable', '😤', 'Emotional'),
    _SymptomItem('Insomnia', '💤', 'Emotional'),
    _SymptomItem('Acne', '😫', 'Skin'),
    _SymptomItem('Dizziness', '😵', 'Physical'),
  ];

  List<_SymptomItem> get _filteredSymptoms {
    if (_activeCategory == 'All') return _allSymptoms;
    return _allSymptoms.where((s) => s.category == _activeCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(title: const Text('Log Symptoms 😣')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: ['All', 'Physical', 'Emotional', 'Digestive', 'Skin']
                    .map((cat) {
                      final isActive = _activeCategory == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => setState(() => _activeCategory = cat),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? AppColors.roseBlush
                                  : AppColors.cardSurface,
                              borderRadius: BorderRadius.circular(20),
                              border: isActive
                                  ? null
                                  : Border.all(color: AppColors.dividerColor),
                            ),
                            child: Text(
                              cat,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: isActive
                                    ? Colors.white
                                    : AppColors.textLight,
                              ),
                            ),
                          ),
                        ),
                      );
                    })
                    .toList(),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 1.6,
                        ),
                    itemCount: _filteredSymptoms.length,
                    itemBuilder: (context, index) {
                      final s = _filteredSymptoms[index];
                      final selected = _selectedSymptoms.any(
                        (x) => x['name'] == s.name,
                      );
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (selected) {
                              _selectedSymptoms.removeWhere(
                                (x) => x['name'] == s.name,
                              );
                              _severities.remove(s.name);
                            } else {
                              _selectedSymptoms.add({
                                'name': s.name,
                                'category': s.category,
                                'severity': 3,
                              });
                              _severities[s.name] = 3;
                            }
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.roseBlush
                                : AppColors.cardSurface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: selected
                                  ? AppColors.crimsonHeart
                                  : AppColors.dividerColor,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                s.emoji,
                                style: const TextStyle(fontSize: 22),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                s.name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: selected
                                      ? Colors.white
                                      : AppColors.textDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  if (_selectedSymptoms.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.cardSurface,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Rate the severity",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ..._selectedSymptoms.map((s) {
                            final name = s['name'] as String;
                            return Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    name,
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12,
                                      color: AppColors.textDark,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                ...List.generate(5, (i) {
                                  final sev = _severities[name] ?? 3;
                                  return IconButton(
                                    icon: Icon(
                                      i < sev
                                          ? Icons.circle_rounded
                                          : Icons.circle_outlined,
                                      color: [
                                        AppColors.success,
                                        AppColors.goldenGlow,
                                        AppColors.peachSunset,
                                        AppColors.crimsonHeart,
                                        AppColors.deepBurgundy,
                                      ][i],
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      setState(() => _severities[name] = i + 1);
                                    },
                                    constraints: const BoxConstraints(
                                      minWidth: 28,
                                      minHeight: 28,
                                    ),
                                    padding: EdgeInsets.zero,
                                  );
                                }),
                              ],
                            );
                          }),
                          const SizedBox(height: 12),
                          PrimaryButton(
                            text: 'Log Symptoms',
                            onPressed: () async {
                              final data = {
                                'date': DateTime.now().toIso8601String(),
                                'symptoms': _selectedSymptoms
                                    .map(
                                      (s) => {
                                        ...s,
                                        'severity': _severities[s['name']] ?? 3,
                                      },
                                    )
                                    .toList(),
                              };
                              final provider = context.read<SymptomProvider>();
                              final success = await provider.logSymptoms(data);
                              if (success && mounted) Navigator.pop(context);
                            },
                          ),
                        ],
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

class _SymptomItem {
  final String name;
  final String emoji;
  final String category;
  _SymptomItem(this.name, this.emoji, this.category);
}
