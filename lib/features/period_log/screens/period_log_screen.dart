import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/cycle_provider.dart';
import '../../../shared/widgets/cycle_sync_button.dart';

class PeriodLogScreen extends StatefulWidget {
  const PeriodLogScreen({super.key});

  @override
  State<PeriodLogScreen> createState() => _PeriodLogScreenState();
}

class _PeriodLogScreenState extends State<PeriodLogScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  DateTime _startDate = DateTime.now();
  bool _isPeriodStarted = true;
  String _flowIntensity = 'medium';

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.35,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.deepBurgundy, AppColors.crimsonHeart],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _pulseCtrl,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 1.0 + _pulseCtrl.value * 0.1,
                          child: const Icon(
                            Icons.water_drop_rounded,
                            color: Colors.white,
                            size: 48,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Log Your Period',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '🔴 Period Active',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: AppColors.cardSurface,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Period Status',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _isPeriodStarted = true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                gradient: _isPeriodStarted
                                    ? const LinearGradient(
                                        colors: [
                                          AppColors.deepBurgundy,
                                          AppColors.crimsonHeart,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      )
                                    : null,
                                color: _isPeriodStarted
                                    ? null
                                    : AppColors.cardSoft,
                                borderRadius: BorderRadius.circular(16),
                                border: _isPeriodStarted
                                    ? null
                                    : Border.all(color: AppColors.dividerColor),
                              ),
                              child: Center(
                                child: Text(
                                  'Period Started 🟢',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: _isPeriodStarted ? Colors.white : AppColors.textDark,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _isPeriodStarted = false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                gradient: !_isPeriodStarted
                                    ? const LinearGradient(
                                        colors: [
                                          AppColors.deepBurgundy,
                                          AppColors.crimsonHeart,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      )
                                    : null,
                                color: !_isPeriodStarted
                                    ? null
                                    : AppColors.cardSoft,
                                borderRadius: BorderRadius.circular(16),
                                border: !_isPeriodStarted
                                    ? null
                                    : Border.all(color: AppColors.dividerColor),
                              ),
                              child: Center(
                                child: Text(
                                  'Period Ended 🔴',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: !_isPeriodStarted ? Colors.white : AppColors.textDark,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Flow Intensity',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _FlowChip('Spotting', 'spotting', '·'),
                        const SizedBox(width: 8),
                        _FlowChip('Light', 'light', '··'),
                        const SizedBox(width: 8),
                        _FlowChip('Medium', 'medium', '···'),
                        const SizedBox(width: 8),
                        _FlowChip('Heavy', 'heavy', '····'),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Notes',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'How are you feeling today?',
                        hintStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          color: AppColors.textLight,
                        ),
                        filled: true,
                        fillColor: AppColors.inputFill,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    PrimaryButton(
                      text: 'Save Period Log 🌸',
                      onPressed: () async {
                        final success = await context
                            .read<CycleProvider>()
                            .createCycle({
                              'startDate': _startDate.toIso8601String(),
                              'flowIntensity': [
                                {
                                  'date': _startDate.toIso8601String(),
                                  'intensity': _flowIntensity,
                                },
                              ],
                            });
                        if (success && mounted) Navigator.pop(context);
                      },
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

  Widget _FlowChip(String label, String value, String dots) {
    final selected = _flowIntensity == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _flowIntensity = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? AppColors.deepBurgundy : AppColors.cardSoft,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              Text(
                dots,
                style: TextStyle(
                  fontSize: 16,
                  color: selected ? Colors.white : AppColors.textDark,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: selected ? Colors.white : AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
