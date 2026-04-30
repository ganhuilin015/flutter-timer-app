import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:timer/services/notification_service.dart';
import '../models/alarm_item.dart';

class AlarmProvider extends ChangeNotifier {
  final List<AlarmItem> _alarms = [];
  Timer? _ticker;
  AlarmItem? _firingAlarm;

  List<AlarmItem> get alarms => List.unmodifiable(_alarms);
  AlarmItem? get firingAlarm => _firingAlarm;

  AlarmProvider() {
    _ticker = Timer.periodic(const Duration(seconds: 10), (_) => _checkAlarms());
  }

  void _checkAlarms() {
    final now = DateTime.now();
    for (final alarm in _alarms) {
      if (!alarm.isEnabled) continue;
      if (alarm.hour == now.hour && alarm.minute == now.minute && now.second < 15) {
        _firingAlarm = alarm;
        notifyListeners();
      }
    }
  }

  void dismissFiring() {
    _firingAlarm = null;
    notifyListeners();
  }

 Future<void> addAlarm(AlarmItem alarm) async {
    _alarms.add(alarm);
    _alarms.sort((a, b) => (a.hour * 60 + a.minute).compareTo(b.hour * 60 + b.minute));
    if (alarm.isEnabled) await _scheduleNative(alarm);
    notifyListeners();
  }

  Future<void> removeAlarm(String id) async {
    final alarm = _alarms.firstWhere((a) => a.id == id, orElse: () => throw Exception('Not found'));
    await _cancelNative(alarm);
    _alarms.removeWhere((a) => a.id == id);
    notifyListeners();
  }

  Future<void> toggleEnabled(String id) async {
    final alarm = _alarms.firstWhere((a) => a.id == id);
    alarm.isEnabled = !alarm.isEnabled;
    if (alarm.isEnabled) {
      await _scheduleNative(alarm);
    } else {
      await _cancelNative(alarm);
    }
    notifyListeners();
  }

  Future<void> updateAlarm(AlarmItem updated) async {
    final idx = _alarms.indexWhere((a) => a.id == updated.id);
    if (idx == -1) return;
    await _cancelNative(_alarms[idx]);
    _alarms[idx] = updated;
    _alarms.sort((a, b) => (a.hour * 60 + a.minute).compareTo(b.hour * 60 + b.minute));
    if (updated.isEnabled) await _scheduleNative(updated);
    notifyListeners();
  }

  int _nativeId(String uuid) => uuid.hashCode.abs() % 100000;

  Future<void> _scheduleNative(AlarmItem alarm) async {
    await NotificationService.schedule(
      id: _nativeId(alarm.id),
      title: alarm.name.isEmpty ? 'Alarm' : alarm.name,
      body: 'Alarm is ringing – ${alarm.formattedTime}',
      trigger: alarm.nextTrigger,
    );
  }

  Future<void> _cancelNative(AlarmItem alarm) async {
    await NotificationService.cancel(_nativeId(alarm.id));
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
