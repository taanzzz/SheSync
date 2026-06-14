import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../providers/medicine_provider.dart';

class AddMedicineScreen extends StatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _purposeController = TextEditingController();
  final _notesController = TextEditingController();

  String _type = 'tablet';
  String _unit = 'mg';
  String _frequency = 'once';
  String _color = '#FF6B9D';
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;
  int _durationValue = 30;
  String _durationUnit = 'days';
  final List<Map<String, String>> _scheduleSlots = [
    {'time': '08:00 AM', 'label': 'Morning'}
  ];
  bool _isSaving = false;

  static const _types = ['tablet', 'capsule', 'syrup', 'injection', 'other'];
  static const _typeIcons = ['💊', '💊', '🧴', '💉', '📦'];
  static const _units = ['mg', 'ml', 'mcg', 'IU', 'g'];
  static const _frequencies = ['once', 'twice', 'thrice', 'custom'];
  static const _freqLabels = ['Once Daily', 'Twice Daily', 'Thrice Daily', 'Custom'];
  static const _slotLabels = ['Morning', 'Noon', 'Evening', 'Night', 'Custom'];
  static const _slotTimes = ['08:00 AM', '12:00 PM', '06:00 PM', '10:00 PM', '08:00 AM'];
  static const _colors = ['#FF6B9D', '#6BAF8A', '#8B7EC8', '#E8A87C', '#5B9BD5', '#D4A843'];

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _purposeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _updateSlotsForFrequency(String freq) {
    setState(() {
      _frequency = freq;
      switch (freq) {
        case 'once':
          _scheduleSlots.clear();
          _scheduleSlots.add({'time': '08:00 AM', 'label': 'Morning'});
          break;
        case 'twice':
          _scheduleSlots.clear();
          _scheduleSlots.addAll([
            {'time': '08:00 AM', 'label': 'Morning'},
            {'time': '10:00 PM', 'label': 'Night'},
          ]);
          break;
        case 'thrice':
          _scheduleSlots.clear();
          _scheduleSlots.addAll([
            {'time': '08:00 AM', 'label': 'Morning'},
            {'time': '12:00 PM', 'label': 'Noon'},
            {'time': '10:00 PM', 'label': 'Night'},
          ]);
          break;
        default:
          break;
      }
    });
  }

  Future<void> _selectDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : (_endDate ?? DateTime.now().add(const Duration(days: 30))),
      firstDate: DateTime.now().subtract(const Duration(days: 7)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isStart) _startDate = picked;
        else _endDate = picked;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    HapticFeedback.mediumImpact();

    final data = {
      'name': _nameController.text.trim(),
      'type': _type,
      'dosage': _dosageController.text.trim(),
      'unit': _unit,
      'frequency': _frequency,
      'reminderTimes': _scheduleSlots.map((s) => s['time']).toList(),
      'startDate': _startDate.toIso8601String(),
      if (_endDate != null) 'endDate': _endDate!.toIso8601String(),
      'purpose': _purposeController.text.trim(),
      'notes': _notesController.text.trim(),
      'color': _color,
      'schedule': {
        'slots': _scheduleSlots.map((s) => {'time': s['time'], 'label': s['label']}).toList(),
      },
      'duration': {'value': _durationValue, 'unit': _durationUnit},
    };

    final success = await context.read<MedicineProvider>().createMedicine(data);
    setState(() => _isSaving = false);

    if (mounted) {
      if (success) {
        HapticFeedback.heavyImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Medicine added successfully! 💊', style: TextStyle(fontFamily: 'Poppins')),
            backgroundColor: const Color(0xFF6BAF8A),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to add medicine', style: TextStyle(fontFamily: 'Poppins')),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Color(0xFF2D2D3A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Add Medicine', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, color: Color(0xFF2D2D3A), fontSize: 20)),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          children: [
            _buildSectionCard('Medicine Details', Icons.medication_rounded, const Color(0xFFFF6B9D), [
              _buildTextField(_nameController, 'Medicine Name', 'e.g. Paracetamol', Icons.medication_outlined, true),
              const SizedBox(height: 16),
              _buildLabel('Type'),
              const SizedBox(height: 8),
              _buildChipRow(_types, _type, _typeIcons, (v) => setState(() => _type = v)),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(child: _buildTextField(_dosageController, 'Dosage', 'e.g. 500', Icons.scale_outlined, true, isNumber: true)),
                const SizedBox(width: 12),
                SizedBox(width: 80, child: _buildDropdown(_unit, _units, (v) => setState(() => _unit = v!))),
              ]),
            ]),
            const SizedBox(height: 16),
            _buildSectionCard('Schedule', Icons.schedule_rounded, const Color(0xFF8B7EC8), [
              _buildLabel('Frequency'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8, runSpacing: 8,
                children: List.generate(_frequencies.length, (i) => _buildSelectableChip(
                  _freqLabels[i], _frequency == _frequencies[i],
                  () => _updateSlotsForFrequency(_frequencies[i]),
                )),
              ),
              const SizedBox(height: 16),
              _buildLabel('Schedule Slots'),
              const SizedBox(height: 8),
              ...List.generate(_scheduleSlots.length, (i) => _buildSlotRow(i)),
              if (_frequency == 'custom') ...[
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () => setState(() => _scheduleSlots.add({'time': '08:00 AM', 'label': 'Morning'})),
                  icon: const Icon(Icons.add_circle_outline, size: 18, color: Color(0xFF8B7EC8)),
                  label: const Text('Add Time Slot', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF8B7EC8))),
                ),
              ],
            ]),
            const SizedBox(height: 16),
            _buildSectionCard('Duration', Icons.date_range_rounded, const Color(0xFF6BAF8A), [
              Row(children: [
                for (final d in [7, 15, 30, 60]) ...[
                  Expanded(child: _buildSelectableChip('$d days', _durationValue == d && _durationUnit == 'days', () => setState(() { _durationValue = d; _durationUnit = 'days'; _endDate = _startDate.add(Duration(days: d)); }))),
                  if (d != 60) const SizedBox(width: 8),
                ],
              ]),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(child: _buildDateCard('Start Date', _startDate, () => _selectDate(true))),
                const SizedBox(width: 12),
                Expanded(child: _buildDateCard('End Date', _endDate ?? _startDate.add(Duration(days: _durationValue)), () => _selectDate(false))),
              ]),
            ]),
            const SizedBox(height: 16),
            _buildSectionCard('Additional Info', Icons.notes_rounded, const Color(0xFFE8A87C), [
              _buildTextField(_purposeController, 'Purpose', 'e.g. Pain relief', Icons.medical_information_outlined, false),
              const SizedBox(height: 16),
              _buildTextField(_notesController, 'Notes', 'Any additional notes...', Icons.sticky_note_2_outlined, false, maxLines: 3),
              const SizedBox(height: 16),
              _buildLabel('Card Color'),
              const SizedBox(height: 8),
              Row(children: _colors.map((c) => Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () => setState(() => _color = c),
                  child: Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                      color: Color(int.parse(c.replaceFirst('#', '0xFF'))),
                      shape: BoxShape.circle,
                      border: Border.all(color: _color == c ? Colors.white : Colors.transparent, width: 3),
                      boxShadow: [if (_color == c) BoxShadow(color: Color(int.parse(c.replaceFirst('#', '0xFF'))).withOpacity(0.4), blurRadius: 8)],
                    ),
                  ),
                ),
              )).toList()),
            ]),
            const SizedBox(height: 24),
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B9D),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 4,
                  shadowColor: const Color(0xFFFF6B9D).withOpacity(0.3),
                ),
                child: _isSaving
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                  : const Text('Save Medicine', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, IconData icon, Color color, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: color.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 4))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Text(title, style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFF2D2D3A))),
        ]),
        const SizedBox(height: 20),
        ...children,
      ]),
    );
  }

  Widget _buildLabel(String text) => Text(text, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF6E6E7A)));

  Widget _buildTextField(TextEditingController ctrl, String label, String hint, IconData icon, bool required, {bool isNumber = false, int maxLines = 1}) {
    return TextFormField(
      controller: ctrl,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      validator: required ? (v) => (v == null || v.trim().isEmpty) ? '$label is required' : null : null,
      style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
      decoration: InputDecoration(
        labelText: label, hintText: hint,
        labelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF9E9EA8)),
        hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFFCCCCD4)),
        prefixIcon: Icon(icon, size: 20, color: const Color(0xFF9E9EA8)),
        filled: true, fillColor: const Color(0xFFF8F8FC),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFFF6B9D), width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildChipRow(List<String> items, String selected, List<String> icons, Function(String) onSelect) {
    return Wrap(spacing: 8, runSpacing: 8, children: List.generate(items.length, (i) => _buildSelectableChip('${icons[i]} ${items[i]}', selected == items[i], () => onSelect(items[i]))));
  }

  Widget _buildSelectableChip(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: () { HapticFeedback.selectionClick(); onTap(); },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFF6B9D).withOpacity(0.12) : const Color(0xFFF8F8FC),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? const Color(0xFFFF6B9D) : Colors.transparent, width: 1.5),
        ),
        child: Text(label, style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: selected ? FontWeight.w700 : FontWeight.w500, color: selected ? const Color(0xFFFF6B9D) : const Color(0xFF6E6E7A))),
      ),
    );
  }

  Widget _buildDropdown(String value, List<String> items, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: const Color(0xFFF8F8FC), borderRadius: BorderRadius.circular(16)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value, isExpanded: true,
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Color(0xFF2D2D3A)),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildSlotRow(int index) {
    final slot = _scheduleSlots[index];
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(color: const Color(0xFFF8F8FC), borderRadius: BorderRadius.circular(14)),
            child: Row(children: [
              const Icon(Icons.access_time_rounded, size: 18, color: Color(0xFF8B7EC8)),
              const SizedBox(width: 8),
              Text(slot['time']!, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600)),
            ]),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(color: const Color(0xFFF0EDFA), borderRadius: BorderRadius.circular(14)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _slotLabels.contains(slot['label']) ? slot['label'] : 'Morning',
              style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF8B7EC8)),
              items: _slotLabels.map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
              onChanged: (v) {
                final idx = _slotLabels.indexOf(v!);
                setState(() {
                  _scheduleSlots[index] = {'time': _slotTimes[idx], 'label': v};
                });
              },
            ),
          ),
        ),
        if (_frequency == 'custom' && _scheduleSlots.length > 1)
          IconButton(icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent, size: 20), onPressed: () => setState(() => _scheduleSlots.removeAt(index))),
      ]),
    );
  }

  Widget _buildDateCard(String label, DateTime date, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: const Color(0xFFF8F8FC), borderRadius: BorderRadius.circular(14)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF9E9EA8))),
          const SizedBox(height: 4),
          Text('${date.day}/${date.month}/${date.year}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2D2D3A))),
        ]),
      ),
    );
  }
}
