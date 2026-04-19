import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:timer/providers/theme_provider.dart';
import 'package:timer/utils/responsive.dart';
import 'package:uuid/uuid.dart';
import '../models/timer_item.dart';
import '../providers/timer_provider.dart';
import 'color_utils.dart';

class AddTimerSheet extends StatefulWidget {
  final TimerItem? existing;
  const AddTimerSheet({super.key, this.existing});

  @override
  State<AddTimerSheet> createState() => _AddTimerSheetState();
}

class _AddTimerSheetState extends State<AddTimerSheet> {
  late TextEditingController _nameCtrl;
  late TextEditingController _hoursCtrl;
  late TextEditingController _minutesCtrl;
  late TextEditingController _secondsCtrl;
  late String _selectedColor;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _nameCtrl = TextEditingController(text: e?.name ?? '');
    _selectedColor = e?.color ?? kPaletteColors[0];
    final total = e?.totalSeconds ?? 0;
    _hoursCtrl = TextEditingController(
      text: e != null ? (total ~/ 3600).toString() : '',
    );
    _minutesCtrl = TextEditingController(
      text: e != null ? ((total % 3600) ~/ 60).toString() : '',
    );
    _secondsCtrl = TextEditingController(
      text: e != null ? (total % 60).toString() : '',
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _hoursCtrl.dispose();
    _minutesCtrl.dispose();
    _secondsCtrl.dispose();
    super.dispose();
  }

  int get _totalSeconds {
    final h = int.tryParse(_hoursCtrl.text) ?? 0;
    final m = int.tryParse(_minutesCtrl.text) ?? 0;
    final s = int.tryParse(_secondsCtrl.text) ?? 0;
    return h * 3600 + m * 60 + s;
  }

  void _save() {
    final name = _nameCtrl.text.trim().isEmpty
        ? 'Timer'
        : _nameCtrl.text.trim();
    final total = _totalSeconds;
    final color = context.read<ThemeProvider>();
    if (total <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please set a duration greater than 0'),
          backgroundColor: color.error(context),
        ),
      );
      return;
    }
    final provider = context.read<TimerProvider>();
    if (widget.existing != null) {
      provider.updateTimer(
        widget.existing!.id,
        name: name,
        totalSeconds: total,
        color: _selectedColor,
      );
    } else {
      provider.addTimer(
        TimerItem(
          id: const Uuid().v4(),
          name: name,
          totalSeconds: total,
          color: _selectedColor,
        ),
      );
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final color = context.watch<ThemeProvider>();
    final isEdit = widget.existing != null;
    return Container(
      decoration: BoxDecoration(
        color: color.surface(context),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: color.outline(context),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            isEdit ? 'Edit Timer' : 'New Timer',
            style: TextStyle(
              color: color.primary(context),
              fontSize: responsiveSize(context, 7),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          // Name field
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(
              labelText: 'Timer name',
              prefixIcon: Icon(Icons.label_outline),
            ),
            style: TextStyle(color: color.onSurface(context)),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 20),
          // Duration pickers
          Text(
            'Duration',
            style: TextStyle(
              color: color.onSurface(context),
              fontSize: responsiveSize(context, 5),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _DurationField(
                  controller: _hoursCtrl,
                  label: 'Hours',
                  max: 23,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DurationField(
                  controller: _minutesCtrl,
                  label: 'Minutes',
                  max: 59,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DurationField(
                  controller: _secondsCtrl,
                  label: 'Seconds',
                  max: 59,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Color picker
          Text(
            'Color',
            style: TextStyle(
              color: color.onSurface(context),
              fontSize: 13,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          _ColorPicker(
            selected: _selectedColor,
            onChanged: (c) => setState(() => _selectedColor = c),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: color.primary(context),
                foregroundColor: color.onPrimary(context)
              ),
              child: Text(isEdit ? 'Save Changes' : 'Add Timer'),
            ),
          ),
        ],
      ),
    );
  }
}

class _DurationField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final int max;

  const _DurationField({
    required this.controller,
    required this.label,
    required this.max,
  });

  @override
  Widget build(BuildContext context) {
    final color = context.watch<ThemeProvider>();

    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        _MaxValueFormatter(max),
      ],
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 11),
      ),
      style: TextStyle(
        color: color.primary(context),
        fontSize: 22,
        fontWeight: FontWeight.w300,
      ),
    );
  }
}

class _MaxValueFormatter extends TextInputFormatter {
  final int max;
  _MaxValueFormatter(this.max);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue old,
    TextEditingValue newVal,
  ) {
    if (newVal.text.isEmpty) return newVal;
    final val = int.tryParse(newVal.text) ?? 0;
    if (val > max) return old;
    return newVal;
  }
}

class _ColorPicker extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const _ColorPicker({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: kPaletteColors.map((hex) {
        final color = hexToColor(hex);
        final isSelected = hex == selected;
        return GestureDetector(
          onTap: () => onChanged(hex),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              border: isSelected
                  ? Border.all(color: Colors.white, width: 3)
                  : null,
              boxShadow: isSelected
                  ? [BoxShadow(color: color.withOpacity(0.6), blurRadius: 8)]
                  : null,
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : null,
          ),
        );
      }).toList(),
    );
  }
}
