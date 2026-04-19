import 'dart:async';
import 'package:flutter/foundation.dart';
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

  void removeTimer(String id) {
    _timers.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void startTimer(String id) {
    final timer = _timers.firstWhere((t) => t.id == id, orElse: () => throw Exception('Not found'));
    if (timer.isFinished) {
      timer.remainingSeconds = timer.totalSeconds;
    }
    timer.status = TimerStatus.running;
    notifyListeners();
  }

  void pauseTimer(String id) {
    final timer = _timers.firstWhere((t) => t.id == id, orElse: () => throw Exception('Not found'));
    if (timer.isRunning) {
      timer.status = TimerStatus.paused;
      notifyListeners();
    }
  }

  void resetTimer(String id) {
    final timer = _timers.firstWhere((t) => t.id == id, orElse: () => throw Exception('Not found'));
    timer.remainingSeconds = timer.totalSeconds;
    timer.status = TimerStatus.idle;
    notifyListeners();
  }

  void startAll() {
    for (final timer in _timers) {
      if (!timer.isRunning && !timer.isFinished) {
        timer.status = TimerStatus.running;
      }
    }
    notifyListeners();
  }

  void pauseAll() {
    for (final timer in _timers) {
      if (timer.isRunning) timer.status = TimerStatus.paused;
    }
    notifyListeners();
  }

  void resetAll() {
    for (final timer in _timers) {
      timer.remainingSeconds = timer.totalSeconds;
      timer.status = TimerStatus.idle;
    }
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

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
