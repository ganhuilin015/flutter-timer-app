import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:timer/services/notification_service.dart';
import '../models/timer_item.dart';

class TimerProvider extends ChangeNotifier {
  final List<TimerItem> _timers = [];
  Timer? _ticker;

  List<TimerItem> get timers => List.unmodifiable(_timers);

  TimerProvider() {
    _startTicker();
  }

  void _startTicker() {
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      _tick();
    });
  }

  void _tick() {
    bool changed = false;
    for (final timer in _timers) {
      if (timer.isRunning) {
        if (timer.remainingSeconds > 0) {
          timer.remainingSeconds--;
          changed = true;
        } else {
          timer.status = TimerStatus.finished;
          changed = true;
        }
      }
    }
    if (changed) notifyListeners();
  }

  void addTimer(TimerItem timer) {
    _timers.add(timer);
    notifyListeners();
  }

  void removeTimer(String id) async {
    final timer = _timers.firstWhere((t) => t.id == id);
    await _cancelNative(timer);

    _timers.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void startTimer(String id) async {
    final timer = _timers.firstWhere((t) => t.id == id, orElse: () => throw Exception('Not found'));
    if (timer.isFinished) {
      timer.remainingSeconds = timer.totalSeconds;
    }
    timer.status = TimerStatus.running;
    await _scheduleNative(timer);
    notifyListeners();
  }

  void pauseTimer(String id) async {
    final timer = _timers.firstWhere((t) => t.id == id, orElse: () => throw Exception('Not found'));
    if (timer.isRunning) {
      timer.status = TimerStatus.paused;
      await _cancelNative(timer);
      notifyListeners();
    }
  }

  void resetTimer(String id) async {
    final timer = _timers.firstWhere((t) => t.id == id, orElse: () => throw Exception('Not found'));
    timer.remainingSeconds = timer.totalSeconds;
    timer.status = TimerStatus.idle;
    await _cancelNative(timer);
    notifyListeners();
  }

  void updateTimer(String id, {String? name, int? totalSeconds, String? color}) {
    final timer = _timers.firstWhere((t) => t.id == id);
    if (name != null) timer.name = name;
    if (color != null) timer.color = color;
    if (totalSeconds != null) {
      timer.totalSeconds = totalSeconds;
      timer.remainingSeconds = totalSeconds;
      timer.status = TimerStatus.idle;
    }
    notifyListeners();
  }

  bool get anyRunning => _timers.any((t) => t.isRunning);

  int _nativeId(String uuid) => uuid.hashCode.abs() % 100000;

  Future<void> _scheduleNative(TimerItem timer) async {
    final trigger = DateTime.now().add(
      Duration(seconds: timer.remainingSeconds),
    );

    await NotificationService.schedule(
      id: _nativeId(timer.id),
      title: timer.name.isEmpty ? 'Timer' : timer.name,
      body: 'Timer is ringing – ${timer.formattedTime}',
      trigger: trigger,
    );
  }

  Future<void> _cancelNative(TimerItem timer) async {
    await NotificationService.cancel(_nativeId(timer.id));
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
