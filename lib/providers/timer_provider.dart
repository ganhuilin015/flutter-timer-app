import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:timer/providers/sound_provider.dart';
import 'package:timer/services/global_alert_service.dart';
import 'package:timer/services/notification_service.dart';
import '../models/timer_item.dart';
import 'package:hive/hive.dart';

class TimerProvider extends ChangeNotifier {
  static const String boxName = 'timers';
  final SoundProvider soundProvider;

  final Box<TimerItem> _box = Hive.box<TimerItem>(boxName);
  List<TimerItem> get timers => _box.values.toList();

  Timer? _ticker;

  final List<TimerItem> _firingQueue = [];

  TimerItem? get firingTimer =>
      _firingQueue.isNotEmpty ? _firingQueue.first : null;

  TimerProvider(this.soundProvider) {
    soundProvider.addListener(_onSoundChanged);
    _startTicker();
  }

  List<TimerItem> get sortedTimers {
    final list = _box.values.toList();

    final anyRunning = list.any((t) => t.isRunning);

    if (anyRunning) {
      int priority(TimerItem t) {
        if (t.isRunning) return 0;
        if (t.status == TimerStatus.paused) return 1;
        return 2;
      }

      list.sort((a, b) {
        final p = priority(a).compareTo(priority(b));
        if (p != 0) return p;

        return a.remainingSeconds.compareTo(b.remainingSeconds);
      });

      return list;
    }

    list.sort((a, b) {
      final nameA = a.name.trim();
      final nameB = b.name.trim();

      final hasNameA = nameA.isNotEmpty;
      final hasNameB = nameB.isNotEmpty;

      if (hasNameA && hasNameB) {
        return nameA.toLowerCase().compareTo(nameB.toLowerCase());
      }

      if (hasNameA && !hasNameB) return -1;
      if (!hasNameA && hasNameB) return 1;

      return a.remainingSeconds.compareTo(b.remainingSeconds);
    });

    return list;
  }

  void attachSoundProvider(SoundProvider soundProvider) {
    soundProvider.addListenerCallback(_onSoundChanged);
  }

  Future<void> _onSoundChanged() async {
    for (final timer in _box.values) {
      if (!timer.isRunning) continue;
      await cancelNative(timer);
      await _scheduleNative(timer);
    }
  }

  void _startTicker() {
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      _tick();
    });
  }

  void _tick() {
    bool changed = false;

    final now = DateTime.now();

    for (final timer in _box.values) {
      if (!timer.isRunning || timer.endTime == null) {
        continue;
      }

      final remaining = timer.endTime!.difference(now).inSeconds;

      if (remaining > 0) {
        if (remaining != timer.remainingSeconds) {
          timer.remainingSeconds = remaining;
          timer.save();
          changed = true;
        }
      } else {
        timer.remainingSeconds = 0;
        timer.endTime = null;
        timer.status = TimerStatus.finished;

        timer.save();

        if (!_firingQueue.contains(timer)) {
          _firingQueue.add(timer);
          GlobalAlertService.instance.showAlarm(timer);
        }

        changed = true;
      }
    }

    if (changed) {
      notifyListeners();
    }
  }

  void dismissFiring() {
    if (_firingQueue.isNotEmpty) {
      _firingQueue.removeAt(0);
    }
    notifyListeners();
  }

  Future<void> addTimer(TimerItem timer) async {
    await _box.put(timer.id, timer);
    notifyListeners();
  }

  Future<void> removeTimer(String id) async {
    final timer = _box.get(id);
    if (timer != null) {
      await cancelNative(timer);
      await _box.delete(id);
    }
    notifyListeners();
  }

  Future<void> startTimer(String id) async {
    final timer = _box.get(id);
    if (timer == null) return;

    if (timer.isFinished) {
      timer.remainingSeconds = timer.totalSeconds;
    }

    timer.endTime = DateTime.now().add(
      Duration(seconds: timer.remainingSeconds),
    );

    timer.status = TimerStatus.running;

    await timer.save();

    await _scheduleNative(timer);

    notifyListeners();
  }

  Future<void> pauseTimer(String id) async {
    final timer = _box.get(id);
    if (timer == null) return;

    if (timer.isRunning && timer.endTime != null) {
      timer.remainingSeconds = timer.endTime!
          .difference(DateTime.now())
          .inSeconds
          .clamp(0, timer.totalSeconds);

      timer.endTime = null;
      timer.status = TimerStatus.paused;

      await timer.save();

      await cancelNative(timer);

      notifyListeners();
    }
  }

  Future<void> resetTimer(String id) async {
    final timer = _box.get(id);
    if (timer == null) return;

    timer.remainingSeconds = timer.totalSeconds;
    timer.endTime = null;
    timer.status = TimerStatus.idle;

    await timer.save();

    await cancelNative(timer);

    notifyListeners();
  }

  Future<void> updateTimer(
    String id, {
    String? name,
    int? totalSeconds,
    String? color,
  }) async {
    final timer = _box.get(id);
    if (timer == null) return;

    if (name != null) timer.name = name;
    if (color != null) timer.color = color;

    if (totalSeconds != null) {
      timer.totalSeconds = totalSeconds;
      timer.remainingSeconds = totalSeconds;
      timer.endTime = null;
      timer.status = TimerStatus.idle;
    }

    await timer.save();
    notifyListeners();
  }

  bool get anyRunning => _box.values.any((t) => t.isRunning);

  int _nativeId(String uuid) => uuid.hashCode.abs() % 100000;

  Future<void> _scheduleNative(TimerItem timer) async {
    final trigger = DateTime.now().add(
      Duration(seconds: timer.remainingSeconds),
    );

    final sound = soundProvider.timerSound.file;

    await NotificationService.schedule(
      id: _nativeId(timer.id),
      title: timer.name.isEmpty ? 'Timer' : timer.name,
      body: 'Tap to stop timer – ${timer.formattedTime}',
      trigger: trigger,
    );

    const platform = MethodChannel('com.gangangan.chrono/alarm');

    await platform.invokeMethod('scheduleAlarm', {
      'id': _nativeId(timer.id),
      'trigger': trigger.millisecondsSinceEpoch,
      'title': timer.name.isEmpty ? 'Timer' : timer.name,
      'body': 'Tap to stop timer',
      'sound': sound,
    });
  }

  Future<void> cancelNative(TimerItem timer) async {
    await NotificationService.cancel(_nativeId(timer.id));

    const platform = MethodChannel('com.gangangan.chrono/alarm');
    platform.invokeMethod('stopAlarm', {'id': _nativeId(timer.id)});
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
