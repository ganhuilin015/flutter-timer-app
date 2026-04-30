import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer/providers/theme_provider.dart';
import 'package:uuid/uuid.dart';
import '../models/alarm_item.dart';
import '../providers/alarm_provider.dart';
import 'color_utils.dart';

class AddAlarmSheet extends StatefulWidget {
  final AlarmItem? existing;
  const AddAlarmSheet({super.key, this.existing});

  @override
  State<AddAlarmSheet> createState() => _AddAlarmSheetState();
}

class _AddAlarmSheetState extends State<AddAlarmSheet> {
  late TextEditingController _nameCtrl;
  late int _hour;
  late int _minute;
  late List<bool> _repeatDays;
  late String _selectedColor;
  bool _isEditingHour = false;
  bool _isEditingMinute = false;

  static const _dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  final FocusNode _hourFocusNode = FocusNode();
  final FocusNode _minuteFocusNode = FocusNode();
  final _hourInputCtrl = TextEditingController();
  final _minuteInputCtrl = TextEditingController();
  static const int _infiniteFactor = 10000;
  final FixedExtentScrollController _hourWheelController = FixedExtentScrollController();
  final FixedExtentScrollController _minuteWheelController = FixedExtentScrollController();


  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    final now = DateTime.now();

    _nameCtrl = TextEditingController(text: e?.name ?? '');
    _hour = e?.hour ?? now.hour;
    _minute = e?.minute ?? now.minute;
    _repeatDays = e?.repeatDays != null
        ? List.from(e!.repeatDays)
        : List.filled(7, false);
    _selectedColor = e?.color ?? kPaletteColors[2];

    _hourFocusNode.addListener(() {
      if (!_hourFocusNode.hasFocus && _isEditingHour) {
        _finishHourEditing();
      }
    });

    _minuteFocusNode.addListener(() {
      if (!_minuteFocusNode.hasFocus && _isEditingMinute) {
        _finishMinuteEditing();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _hourWheelController.jumpToItem(
        _centeredIndex(_hour, 24),
      );

      _minuteWheelController.jumpToItem(
        _centeredIndex(_minute, 60),
      );
    });
  }

  int _centeredIndex(int value, int range) {
    return value + (_infiniteFactor ~/ 2) - ((_infiniteFactor ~/ 2) % range);
  }

  void _finishHourEditing() {
    final parsed = int.tryParse(_hourInputCtrl.text);

    if (parsed != null) {
      _hour = parsed % 24;
    }

    setState(() => _isEditingHour = false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _hourWheelController.jumpToItem(
        _centeredIndex(_hour, 24),
      );
    });
  }

  void _finishMinuteEditing() {
    final parsed = int.tryParse(_minuteInputCtrl.text);

    if (parsed != null) {
      _minute = parsed % 60;
    }

    setState(() => _isEditingMinute = false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _minuteWheelController.jumpToItem(
        _centeredIndex(_minute, 60),
      );
    });
  }

  @override
  void dispose() {
    _hourFocusNode.dispose();
    _minuteFocusNode.dispose();
    _hourInputCtrl.dispose();
    _minuteInputCtrl.dispose();
    _nameCtrl.dispose();
    _hourWheelController.dispose();
    _minuteWheelController.dispose();
    super.dispose();
  }

  void _save() {
    if (_isEditingHour) {
      _finishHourEditing();
    }
    if (_isEditingMinute) {
      _finishMinuteEditing();
    }

    final name = _nameCtrl.text.trim().isEmpty ? '' : _nameCtrl.text.trim();
    final provider = context.read<AlarmProvider>();
    final alarm = AlarmItem(
      id: widget.existing?.id ?? const Uuid().v4(),
      name: name,
      hour: _hour,
      minute: _minute,
      repeatDays: _repeatDays,
      isEnabled: widget.existing?.isEnabled ?? true,
      color: _selectedColor,
    );
    if (widget.existing != null) {
      provider.updateAlarm(alarm);
    } else {
      provider.addAlarm(alarm);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    final themeColor = context.read<ThemeProvider>();

    return Container(
      decoration: BoxDecoration(
        color: themeColor.surface(context),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: themeColor.onSurface(context),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isEdit ? 'Edit Alarm' : 'New Alarm',
              style: TextStyle(
                color: themeColor.primary(context),
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: themeColor.surface(context),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _isEditingHour
                        ? _buildInputField(
                            controller: _hourInputCtrl,
                            focusNode: _hourFocusNode,
                            max: 23,
                            onSubmitted: (_) => _finishHourEditing(),
                          )
                        : GestureDetector(
                            onTap: () {
                              _hourInputCtrl.text = _hour.toString().padLeft(2, '0');
                              setState(() => _isEditingHour = true);
                            },
                            child: _buildWheel(
                              itemCount: 24,
                              controller: _hourWheelController,
                              onChanged: (val) => setState(() => _hour = val),
                              textColor: themeColor.onSurface(context),
                            ),
                          ),

                      const SizedBox(width: 12),

                      Text(
                        ":",
                        style: TextStyle(
                          fontSize: 30,
                          color: themeColor.primary(context),
                        ),
                      ),

                      const SizedBox(width: 12),

                      _isEditingMinute
                        ? _buildInputField(
                            controller: _minuteInputCtrl,
                            focusNode: _minuteFocusNode,
                            max: 59,
                            onSubmitted: (_) => _finishMinuteEditing(),
                          )
                        : GestureDetector(
                            onTap: () {
                              _minuteInputCtrl.text = _minute.toString().padLeft(2, '0');
                              setState(() => _isEditingMinute = true);
                            },
                            child: _buildWheel(
                              itemCount: 60,
                              controller: _minuteWheelController,
                              onChanged: (val) => setState(() => _minute = val),
                              textColor: themeColor.onSurface(context),
                            ),
                          ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Name
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Alarm name',
                prefixIcon: Icon(Icons.label_outline),
              ),
              style: TextStyle(color: themeColor.onSurface(context)),
              textCapitalization: TextCapitalization.words,
              autofocus: true,
            ),
            const SizedBox(height: 20),
            // Repeat days
            Text(
              'Repeat',
              style: TextStyle(
                color: themeColor.onSurface(context),
                fontSize: 13,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              spacing: 20,
              children: List.generate(7, (i) {
                final active = _repeatDays[i];
                return GestureDetector(
                  onTap: () => setState(() => _repeatDays[i] = !_repeatDays[i]),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: active
                          ? hexToColor(_selectedColor)
                          : themeColor.secondary(context),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _dayLabels[i],
                          style: TextStyle(
                            color: active
                                ? themeColor.onPrimary(context)
                                : themeColor.onSecondary(context),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            // Color
            Text(
              'Color',
              style: TextStyle(
                color: themeColor.onSurface(context),
                fontSize: 13,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: kPaletteColors.map((hex) {
                final color = hexToColor(hex);
                final isSelected = hex == _selectedColor;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = hex),
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
                          ? [
                              BoxShadow(
                                color: color.withAlpha(150),
                                blurRadius: 8,
                              ),
                            ]
                          : null,
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor.primary(context),
                  foregroundColor: themeColor.onPrimary(context),
                ),
                child: Text(isEdit ? 'Save Changes' : 'Add Alarm'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildWheel({
  required int itemCount,
  required FixedExtentScrollController controller,
  required Function(int) onChanged,
  required Color textColor,
}) {
  return SizedBox(
    height: 120,
    width: 80,
    child: ListWheelScrollView.useDelegate(
      controller: controller,
      itemExtent: 50,
      perspective: 0.003,
      diameterRatio: 1.2,
      physics: const FixedExtentScrollPhysics(),
      onSelectedItemChanged: (index) {
        final realValue = index % itemCount;
        onChanged(realValue);
      },
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: null, 
        builder: (context, index) {
          final realIndex = index % itemCount;

          return Center(
            child: Text(
              realIndex.toString().padLeft(2, '0'),
              style: TextStyle(fontSize: 24, color: textColor),
            ),
          );
        },
      ),
    ),
  );
}

Widget _buildInputField({
  required TextEditingController controller,
  required FocusNode focusNode,
  required int max,
  required Function(int) onSubmitted,
}) {
  return SizedBox(
    width: 80,
    height: 120,
    child: Center(
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 24),
        maxLength: 2,
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
        onSubmitted: (value) {
          final parsed = int.tryParse(value);
          if (parsed != null && parsed >= 0 && parsed <= max) {
            onSubmitted(parsed);
          }
        },
        autofocus: true,
      ),
    ),
  );
}