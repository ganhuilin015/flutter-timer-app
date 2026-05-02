import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer/providers/theme_provider.dart';
import 'package:timer/widgets/color_picker.dart';
import 'package:uuid/uuid.dart';
import '../models/stopwatch_entry.dart';
import '../providers/stopwatch_provider.dart';
import 'color_utils.dart';

class AddStopwatchSheet extends StatefulWidget {
  const AddStopwatchSheet({super.key});

  @override
  State<AddStopwatchSheet> createState() => _AddStopwatchSheetState();
}

class _AddStopwatchSheetState extends State<AddStopwatchSheet> {
  final _nameCtrl = TextEditingController();
  String _selectedColor = kPaletteColors[1];

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameCtrl.text.trim().isEmpty ? '' : _nameCtrl.text.trim();
    context.read<StopwatchProvider>().addStopwatch(StopwatchEntry(
      id: const Uuid().v4(),
      name: name,
      color: _selectedColor,
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final color = context.watch<ThemeProvider>();

    return Container(
      decoration: BoxDecoration(
        color: color.surface(context),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).viewInsets.bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(color: color.onSurface(context), borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 20),
          Text('New Stopwatch',
              style: TextStyle(color: color.primary(context), fontSize: 17, fontWeight: FontWeight.w700)),
          const SizedBox(height: 20),
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(labelText: 'Stopwatch name', prefixIcon: Icon(Icons.label_outline)),
            style: TextStyle(color: color.onSurface(context)),
            textCapitalization: TextCapitalization.words,
            autofocus: true,
          ),
          const SizedBox(height: 20),
          Text('Color', style: TextStyle(color: color.onSurface(context), fontSize: 13, letterSpacing: 0.5)),
          const SizedBox(height: 10),
          ColorPicker(
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
              child: const Text('Add Stopwatch'),
            ),
          ),
        ],
      ),
    );
  }
}
