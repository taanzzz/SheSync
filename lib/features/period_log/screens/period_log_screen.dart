import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../providers/cycle_provider.dart';
import '../../../providers/water_provider.dart';

class PeriodLogScreen extends StatefulWidget {
  const PeriodLogScreen({super.key});

  @override
  State<PeriodLogScreen> createState() => _PeriodLogScreenState();
}

class _PeriodLogScreenState extends State<PeriodLogScreen> {
  DateTime _startDate = DateTime.now();
  bool _isActive = true;
  String? _activeCycleId;

  String _flowIntensity = 'medium';
  final List<String> _selectedSymptoms = [];
  String? _selectedMood;
  final TextEditingController _notesCtrl = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cp = context.read<CycleProvider>();
      
      String? activeId;
      DateTime initialDate = DateTime.now();
      
      if (cp.cycles.isNotEmpty) {
        final last = cp.cycles.first;
        if (last['endDate'] == null) {
          activeId = last['_id'];
          initialDate = DateTime.parse(last['startDate']);
        }
      }
      
      setState(() {
        _isActive = cp.config?['isActive'] ?? true;
        _activeCycleId = activeId;
        if (activeId != null) _startDate = initialDate;
      });
    });
  }

  static const _flowOptions = [
    {'key': 'spotting', 'label': 'Spotting', 'pads': '<1', 'color': 0xFFFFCF95},
    {'key': 'light', 'label': 'Light', 'pads': '1-3', 'color': 0xFFFF97D0},
    {'key': 'medium', 'label': 'Medium', 'pads': '3-6', 'color': 0xFFE8647A},
    {'key': 'heavy', 'label': 'Heavy', 'pads': '6+', 'color': 0xFF810B38},
  ];

  static const _symptomOptions = [
    'Cramps',
    'Headache',
    'Back Pain',
    'Bloating',
    'Fatigue',
    'Nausea',
    'Mood Swings',
    'Breast Tenderness',
    'Acne',
    'Dizziness',
  ];

  static const _moodOptions = [
    {'emoji': '😊', 'label': 'Happy'},
    {'emoji': '😌', 'label': 'Calm'},
    {'emoji': '💪', 'label': 'Energetic'},
    {'emoji': '😟', 'label': 'Anxious'},
    {'emoji': '😢', 'label': 'Sad'},
    {'emoji': '😤', 'label': 'Irritated'},
    {'emoji': '😴', 'label': 'Tired'},
  ];

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _savePeriodLog() async {
    setState(() => _isSaving = true);
    
    final cp = context.read<CycleProvider>();

    if (!_isActive) {
      await cp.saveConfig({'isActive': false});
      if (!mounted) return;
      setState(() => _isSaving = false);
      context.read<WaterProvider>().loadTodayProgress();
      _showSnackbar('Period tracking turned off.');
      Navigator.pop(context);
      return;
    }

    // Saving tracking ON + log the period
    final data = <String, dynamic>{
      'startDate': _startDate.toIso8601String(),
      'notes': _notesCtrl.text,
    };
    
    if (_flowIntensity.isNotEmpty) {
      data['flowIntensity'] = [
        {'date': _startDate.toIso8601String(), 'intensity': _flowIntensity},
      ];
    }
    if (_selectedSymptoms.isNotEmpty) data['symptoms'] = _selectedSymptoms;
    if (_selectedMood != null) data['mood'] = _selectedMood!;

    // Log new cycle or update existing
    bool success;
    if (_activeCycleId != null) {
      success = await cp.updateCycle(_activeCycleId!, data);
    } else {
      success = await cp.createCycle(data);
    }
    await cp.saveConfig({'isActive': true});

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (success) {
      // Hydration sync
      context.read<WaterProvider>().loadTodayProgress();
      
      _showSnackbar('Period logged successfully! 🌸');
      Navigator.pop(context);
    } else {
      _showSnackbar(
        'Could not save. Check connection and try again.',
        isError: true,
      );
    }
  }

  void _showSnackbar(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontFamily: 'Poppins')),
        backgroundColor: isError
            ? const Color(0xFFE53E3E)
            : const Color(0xFF48BB78),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9D2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1A0A10)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Log Period',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A0A10),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBenefitsCard(),
            const SizedBox(height: 20),
            _buildTrackingToggle(),
            if (_isActive) ...[
              const SizedBox(height: 20),
              _buildDateRange(),
              const SizedBox(height: 20),
              _buildFlowSection(),
              const SizedBox(height: 20),
              _buildSymptomsSection(),
              const SizedBox(height: 20),
              _buildMoodSection(),
              const SizedBox(height: 20),
              _buildNotesSection(),
            ],
            const SizedBox(height: 28),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE8647A), Color(0xFFD34F65)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8647A).withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Why log your period?',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Logging unlocks AI-powered predictions for your next period, ovulation day, fertile window, and gives you personalized daily health insights.',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: Colors.white,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF810B38).withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0F7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.track_changes_rounded,
              color: Color(0xFFE8647A),
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Period Tracking',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2D2D3A),
                  ),
                ),
                Text(
                  'Enable to track cycle and hydration',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: Color(0xFF9E9EA8),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _isActive,
            onChanged: (v) => setState(() => _isActive = v),
            activeColor: const Color(0xFFE8647A),
            activeTrackColor: const Color(0xFFFFE8EC),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRange() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF810B38).withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE8EC),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.calendar_month_rounded,
                  color: Color(0xFFE8647A),
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'First Day of Period',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2D2D3A),
                      ),
                    ),
                    Text(
                      'When did your bleeding start?',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        color: Color(0xFF9E9EA8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: _DateChip(
              label: 'Selected Date',
              date: _startDate,
              onTap: _pickStart,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickStart() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now().subtract(const Duration(days: 45)),
      lastDate: DateTime.now(),
      builder: (_, c) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFFE8647A),
            onPrimary: Colors.white,
          ),
        ),
        child: c!,
      ),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Widget _buildFlowSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF810B38).withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5EE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.water_drop_rounded,
                  color: Color(0xFF6BAF8A),
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Flow Intensity',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D2D3A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _flowOptions.map((f) {
              final selected = _flowIntensity == f['key'];
              return GestureDetector(
                onTap: () =>
                    setState(() => _flowIntensity = f['key'] as String),
                child: Container(
                  width: (MediaQuery.of(context).size.width - 76) / 4,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    gradient: selected
                        ? LinearGradient(
                            colors: [
                              Color(f['color'] as int),
                              Color(f['color'] as int).withOpacity(0.7),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: selected ? null : const Color(0xFFFFF0F7),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selected
                          ? Colors.transparent
                          : const Color(0xFFFFD6EC),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        f['label'] as String,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: selected
                              ? Colors.white
                              : Color(f['color'] as int),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${f['pads']} pads',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 9,
                          color: selected
                              ? Colors.white70
                              : const Color(0xFFB07090),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSymptomsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF810B38).withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F0FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.healing_rounded,
                  color: Color(0xFF8B7EC8),
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Symptoms (${_selectedSymptoms.length})',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2D2D3A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _symptomOptions.map((s) {
              final selected = _selectedSymptoms.contains(s);
              return GestureDetector(
                onTap: () => setState(() {
                  selected
                      ? _selectedSymptoms.remove(s)
                      : _selectedSymptoms.add(s);
                }),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFF810B38)
                        : const Color(0xFFFFF0F7),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selected
                          ? Colors.transparent
                          : const Color(0xFFFFD6EC),
                    ),
                  ),
                  child: Text(
                    s,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: selected ? Colors.white : const Color(0xFF1A0A10),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF810B38).withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.emoji_emotions_rounded,
                  color: Color(0xFFD4A843),
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Mood',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D2D3A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: _moodOptions.map((m) {
              final selected = _selectedMood == m['label'];
              return GestureDetector(
                onTap: () =>
                    setState(() => _selectedMood = m['label'] as String),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFF2D2D3A)
                        : const Color(0xFFFFF0F7),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selected
                          ? Colors.transparent
                          : const Color(0xFFFFD6EC),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        m['emoji'] as String,
                        style: TextStyle(fontSize: selected ? 20 : 18),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        m['label'] as String,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: selected
                              ? Colors.white
                              : const Color(0xFF6B6B7B),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF810B38).withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5EE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.edit_note_rounded,
                  color: Color(0xFF6BAF8A),
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Notes',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D2D3A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notesCtrl,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'How are you feeling today?',
              hintStyle: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                color: Color(0xFFB07090),
              ),
              filled: true,
              fillColor: const Color(0xFFFFF0F7),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: _isSaving ? null : _savePeriodLog,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF810B38),
          disabledBackgroundColor: const Color(0xFFB07090),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 4,
          shadowColor: const Color(0xFF810B38).withOpacity(0.3),
        ),
        child: _isSaving
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : const Text(
                'Save Period Log 🌸',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  final String label;
  final DateTime date;
  final VoidCallback onTap;

  const _DateChip({
    required this.label,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF0F7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFFFD6EC)),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10,
                color: Color(0xFFB07090),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('MMM d').format(date),
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A0A10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
