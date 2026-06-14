import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../providers/water_provider.dart';

class BMICalculatorScreen extends StatefulWidget {
  const BMICalculatorScreen({super.key});

  @override
  State<BMICalculatorScreen> createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  double _height = 165;
  double _weight = 60;
  bool _isMetric = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final wp = context.read<WaterProvider>();
      final config = wp.config;
      if (config != null) {
        setState(() {
          _weight = (config['weight'] as num?)?.toDouble() ?? 60;
          _height = (config['height'] as num?)?.toDouble() ?? 165;
          
          if (!_isMetric) {
             _weight = _weight / 0.453592;
             _height = _height / 2.54;
          }
        });
      }
    });
  }

  double get _bmi {
    final h = _isMetric ? _height / 100 : _height * 0.3048 / 12;
    final w = _isMetric ? _weight : _weight * 0.453592;
    if (h == 0) return 0;
    return w / (h * h);
  }

  String get _category {
    final b = _bmi;
    if (b < 18.5) return 'Underweight';
    if (b < 25) return 'Healthy';
    if (b < 30) return 'Overweight';
    return 'Obese';
  }

  Color get _categoryColor {
    switch (_category) {
      case 'Underweight': return const Color(0xFF5B9BD5);
      case 'Healthy': return const Color(0xFF6BAF8A);
      case 'Overweight': return const Color(0xFFD4A843);
      case 'Obese': return const Color(0xFFE8647A);
      default: return const Color(0xFF6BAF8A);
    }
  }

  String get _message {
    switch (_category) {
      case 'Underweight': return 'You are underweight. Consider consulting a nutritionist for a healthy meal plan.';
      case 'Healthy': return 'Great job! You are at a healthy weight. Keep up your balanced lifestyle!';
      case 'Overweight': return 'Slightly overweight. Small changes in diet and activity can help.';
      case 'Obese': return 'Your BMI indicates obesity. Consider speaking with a healthcare provider.';
      default: return '';
    }
  }

  IconData get _categoryIcon {
    switch (_category) {
      case 'Underweight': return Icons.trending_down_rounded;
      case 'Healthy': return Icons.favorite_rounded;
      case 'Overweight': return Icons.trending_up_rounded;
      case 'Obese': return Icons.warning_amber_rounded;
      default: return Icons.favorite_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, color: Color(0xFF2D2D3A)), onPressed: () => Navigator.pop(context)),
        title: const Text('BMI Calculator', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, color: Color(0xFF2D2D3A), fontSize: 20)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 8),
          _buildResultCard(),
          const SizedBox(height: 24),
          _buildBMIScale(),
          const SizedBox(height: 24),
          _buildUnitToggle(),
          const SizedBox(height: 20),
          _buildSliderCard('Height', _height, _isMetric ? 100 : 48, _isMetric ? 220 : 84, _isMetric ? 'cm' : 'in', Icons.height_rounded, const Color(0xFF8B7EC8), (v) => setState(() => _height = v)),
          const SizedBox(height: 16),
          _buildSliderCard('Weight', _weight, _isMetric ? 30 : 66, _isMetric ? 200 : 440, _isMetric ? 'kg' : 'lbs', Icons.monitor_weight_outlined, const Color(0xFFFF6B9D), (v) => setState(() => _weight = v)),
          const SizedBox(height: 24),
          _buildInsightCard(),
          const SizedBox(height: 40),
          _buildConfirmButton(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8B7EC8), Color(0xFF6A5DAB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B7EC8).withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () async {
            HapticFeedback.mediumImpact();
            // Show loading or just save
            final wp = context.read<WaterProvider>();
            
            // Standardize to Metric (kg, cm) for backend
            final h = _isMetric ? _height : _height * 2.54;
            final w = _isMetric ? _weight : _weight * 0.453592;
            
            await wp.saveConfig({
              'weight': w,
              'height': h,
            });

            if (!mounted) return;
            
            // Show success msg
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text('Profile Updated', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 14)),
                          Text('Your target hydration is automatically adjusted!', style: TextStyle(fontFamily: 'Poppins', fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
                backgroundColor: const Color(0xFF6BAF8A),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                margin: const EdgeInsets.all(20),
                duration: const Duration(seconds: 4),
              ),
            );
            
            Navigator.pop(context);
          },
          child: const Center(
            child: Text(
              'Confirm as My Profile Data',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [_categoryColor.withOpacity(0.9), _categoryColor], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [BoxShadow(color: _categoryColor.withOpacity(0.3), blurRadius: 24, offset: const Offset(0, 10))],
      ),
      child: Column(children: [
        Container(
          width: 56, height: 56,
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
          child: Icon(_categoryIcon, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 16),
        Text(_bmi.toStringAsFixed(1), style: const TextStyle(fontFamily: 'Poppins', fontSize: 56, fontWeight: FontWeight.w800, color: Colors.white, height: 1)),
        const SizedBox(height: 4),
        Text('BMI Score', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Colors.white.withOpacity(0.7))),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
          child: Text(_category, style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
        ),
      ]),
    );
  }

  Widget _buildBMIScale() {
    final bmiPosition = ((_bmi - 15).clamp(0, 25) / 25);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('BMI Scale', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF2D2D3A))),
        const SizedBox(height: 16),
        Stack(children: [
          Container(
            height: 12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              gradient: const LinearGradient(colors: [Color(0xFF5B9BD5), Color(0xFF6BAF8A), Color(0xFFD4A843), Color(0xFFE8647A)]),
            ),
          ),
          Positioned(
            left: (MediaQuery.of(context).size.width - 80) * bmiPosition - 8,
            top: -4,
            child: Container(
              width: 20, height: 20,
              decoration: BoxDecoration(
                color: Colors.white, shape: BoxShape.circle,
                border: Border.all(color: _categoryColor, width: 3),
                boxShadow: [BoxShadow(color: _categoryColor.withOpacity(0.3), blurRadius: 8)],
              ),
            ),
          ),
        ]),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          for (final label in ['15', '18.5', '25', '30', '40'])
            Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Color(0xFF9E9EA8))),
        ]),
        const SizedBox(height: 4),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          for (final l in ['Under', 'Healthy', 'Over', 'Obese'])
            Text(l, style: const TextStyle(fontFamily: 'Poppins', fontSize: 9, color: Color(0xFFCCCCD4))),
        ]),
      ]),
    );
  }

  Widget _buildUnitToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(children: [
        _buildToggleOption('Metric (kg/cm)', _isMetric, () => setState(() {
          if (!_isMetric) {
            _isMetric = true;
            _height = (_height * 2.54).clamp(100, 220);
            _weight = (_weight * 0.453592).clamp(30, 200);
          }
        })),
        _buildToggleOption('Imperial (lbs/in)', !_isMetric, () => setState(() {
          if (_isMetric) {
            _isMetric = false;
            _height = (_height / 2.54).clamp(48, 84);
            _weight = (_weight / 0.453592).clamp(66, 440);
          }
        })),
      ]),
    );
  }

  Widget _buildToggleOption(String label, bool selected, VoidCallback onTap) {
    return Expanded(child: GestureDetector(
      onTap: () { HapticFeedback.selectionClick(); onTap(); },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF8B7EC8) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(label, textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600, color: selected ? Colors.white : const Color(0xFF9E9EA8))),
      ),
    ));
  }

  Widget _buildSliderCard(String label, double value, double min, double max, String unit, IconData icon, Color color, ValueChanged<double> onChanged) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: color.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF2D2D3A))),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Text('${value.round()} $unit', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w800, color: color)),
          ),
        ]),
        const SizedBox(height: 16),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: color, inactiveTrackColor: color.withOpacity(0.15),
            thumbColor: color, overlayColor: color.withOpacity(0.1),
            trackHeight: 6, thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
          ),
          child: Slider(value: value, min: min, max: max, onChanged: (v) { HapticFeedback.selectionClick(); onChanged(v); }),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('${min.round()} $unit', style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Color(0xFF9E9EA8))),
          Text('${max.round()} $unit', style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Color(0xFF9E9EA8))),
        ]),
      ]),
    );
  }

  Widget _buildInsightCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _categoryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _categoryColor.withOpacity(0.2)),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(_category == 'Healthy' ? '💚' : '💡', style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 12),
        Expanded(child: Text(_message, style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: _categoryColor.withOpacity(0.9), height: 1.5))),
      ]),
    );
  }
}
