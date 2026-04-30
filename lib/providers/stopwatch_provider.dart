import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/stopwatch_entry.dart';

class StopwatchProvider extends ChangeNotifier {
  final List<StopwatchEntry> _stopwatches = [];
  Timer? _ticker;

  List<StopwatchEntry> get stopwatches => List.unmodifiable(_stopwatches);

  StopwatchProvider() {
    _startTicker();
  }

  void _startTicker() {
    _ticker = Timer.periodic(const Duration(milliseconds: 50), (_) {
      _tick();
    });
  }

  void _tick() {
    bool changed = false;
    final now = DateTime.now();
    for (final sw in _stopwatches) {
      if (sw.isRunning && sw.startedAt != null) {
        sw.elapsedMilliseconds =
            sw.accumulatedMs + now.difference(sw.startedAt!).inMilliseconds;
        changed = true;
      }
    }
    if (changed) notifyListeners();
  }

  void addStopwatch(StopwatchEntry entry) {
    _stopwatches.add(entry);
    notifyListeners();
  }

  void removeStopwatch(String id) {
    _stopwatches.removeWhere((s) => s.id == id);
    notifyListeners();
  }

  void toggleEnabled(String id) {
    final sw = _stopwatches.firstWhere((s) => s.id == id);
    sw.isEnabled = !sw.isEnabled;
    if (!sw.isEnabled && sw.isRunning) {
      _pause(sw);
    }
    notifyListeners();
  }

  void start(String id) {
    final sw = _stopwatches.firstWhere((s) => s.id == id);
    if (!sw.isEnabled) return;
    sw.isRunning = true;
    sw.startedAt = DateTime.now();
    notifyListeners();
  }

  void pause(String id) {
    final sw = _stopwatches.firstWhere((s) => s.id == id);
    _pause(sw);
    notifyListeners();
  }

  void _pause(StopwatchEntry sw) {
    if (sw.isRunning) {
      sw.accumulatedMs = sw.elapsedMilliseconds;
      sw.isRunning = false;
      sw.startedAt = null;
    }
  }

  void reset(String id) {
    final sw = _stopwatches.firstWhere((s) => s.id == id);
    _pause(sw);
    sw.elapsedMilliseconds = 0;
    sw.accumulatedMs = 0;
    sw.laps.clear();
    notifyListeners();
  }

  void addLap(String id) {
    final sw = _stopwatches.firstWhere((s) => s.id == id);
    if (!sw.isRunning) return;
    final lastTotal = sw.laps.isEmpty ? 0 : sw.laps.last.totalMilliseconds;
    sw.laps.add(
      LapEntry(
        lapNumber: sw.laps.length + 1,
        lapMilliseconds: sw.elapsedMilliseconds - lastTotal,
        totalMilliseconds: sw.elapsedMilliseconds,
      ),
    );
    notifyListeners();
  }

  bool get anyRunning => _stopwatches.any((s) => s.isRunning);

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
