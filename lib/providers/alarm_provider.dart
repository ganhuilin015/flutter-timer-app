import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:timer/providers/sound_provider.dart';
import 'package:timer/services/notification_service.dart';
import '../models/alarm_item.dart';

class AlarmProvider extends ChangeNotifier {
  static const String boxName = 'alarms';

  final Box<AlarmItem> _box = Hive.box<AlarmItem>(boxName);

  Timer? _ticker;

  AlarmItem? _firingAlarm;
  final Set<String> _firedKeys = {};

  List<AlarmItem> get alarms => _box.values.toList();

  AlarmItem? get firingAlarm => _firingAlarm;

  AlarmProvider() {
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _checkAlarms());
  }

  String _alarmKey(AlarmItem alarm) {
    final now = DateTime.now();
    return '${alarm.id}_${now.year}_${now.month}_${now.day}_${alarm.hour}_${alarm.minute}';
  }

  void _checkAlarms() {
    cleanupOldFired();

    final now = DateTime.now();

    for (final alarm in _box.values) {
      if (!alarm.isEnabled) continue;

      if (alarm.hour == now.hour &&
          alarm.minute == now.minute &&
          now.second < 10) {
        final key = _alarmKey(alarm);

        if (!_firedKeys.contains(key)) {
          _firedKeys.add(key);
          _firingAlarm = alarm;
          notifyListeners();
        }
      }
    }
  }

  void cleanupOldFired() {
    final now = DateTime.now();

    _firedKeys.removeWhere((key) {
      final parts = key.split('_');
      if (parts.length < 6) return true;

      final hour = int.parse(parts[4]);
      final minute = int.parse(parts[5]);

      return now.hour != hour || now.minute != minute;
    });
  }

  void dismissFiring() {
    _firingAlarm = null;
    notifyListeners();
  }

  Future<void> addAlarm(AlarmItem alarm) async {
    await _box.put(alarm.id, alarm);

    final list = _box.values.toList()
      ..sort(
        (a, b) => (a.hour * 60 + a.minute).compareTo(b.hour * 60 + b.minute),
      );

    await _resaveSorted(list);

    if (alarm.isEnabled) await _scheduleNative(alarm);

    notifyListeners();
  }

  Future<void> removeAlarm(String id) async {
    final alarm = _box.get(id);
    if (alarm == null) return;

    await cancelNative(alarm);
    await _box.delete(id);

    notifyListeners();
  }

  Future<void> toggleEnabled(String id) async {
    final alarm = _box.get(id);
    if (alarm == null) return;

    alarm.isEnabled = !alarm.isEnabled;
    await alarm.save();

    if (alarm.isEnabled) {
      await _scheduleNative(alarm);
    } else {
      await cancelNative(alarm);
    }

    notifyListeners();
  }

  Future<void> updateAlarm(AlarmItem updated) async {
    final existing = _box.get(updated.id);
    if (existing == null) return;

    await cancelNative(existing);

    await _box.put(updated.id, updated);

    final list = _box.values.toList()
      ..sort(
        (a, b) => (a.hour * 60 + a.minute).compareTo(b.hour * 60 + b.minute),
      );

    await _resaveSorted(list);

    if (updated.isEnabled) {
      await _scheduleNative(updated);
    }

    notifyListeners();
  }

  Future<void> _resaveSorted(List<AlarmItem> list) async {
    await _box.clear();
    for (final item in list) {
      await _box.put(item.id, item);
    }
  }

  int _nativeId(String uuid) => uuid.hashCode.abs() % 100000;

  Future<void> _scheduleNative(AlarmItem alarm) async {
    await NotificationService.schedule(
      id: _nativeId(alarm.id),
      title: alarm.name.isEmpty ? 'Alarm' : alarm.name,
      body: 'Tap to stop alarm – ${alarm.formattedTime}',
      trigger: alarm.nextTrigger,
    );

    final sound = SoundProvider().alarmSound.file;

    const platform = MethodChannel('com.example.timer/alarm');

    await platform.invokeMethod('scheduleAlarm', {
      'id': _nativeId(alarm.id),
      'trigger': alarm.nextTrigger.millisecondsSinceEpoch,
      'title': alarm.name.isEmpty ? 'Alarm' : alarm.name,
      'body': 'Tap to stop alarm',
      'sound': sound,
    });
  }

  Future<void> cancelNative(AlarmItem alarm) async {
    await NotificationService.cancel(_nativeId(alarm.id));

    const platform = MethodChannel('com.example.timer/alarm');
    platform.invokeMethod('stopAlarm', {'id': _nativeId(alarm.id)});
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
