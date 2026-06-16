import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/stopwatch_entry.dart';

class StopwatchProvider extends ChangeNotifier {
  static const String boxName = 'stopwatches';

  final Box<StopwatchEntry> _box = Hive.box<StopwatchEntry>(boxName);

  Timer? _ticker;

  StopwatchProvider() {
    _startTicker();
  }

  List<StopwatchEntry> get stopwatches => _box.values.toList();

  void _startTicker() {
    _ticker = Timer.periodic(
      const Duration(milliseconds: 50),
      (_) => _tick(),
    );
  }

  void _tick() {
    bool changed = false;
    final now = DateTime.now();

    for (final sw in _box.values) {
      if (sw.isRunning && sw.startedAt != null) {
        sw.elapsedMilliseconds =
            sw.accumulatedMs +
            now.difference(sw.startedAt!).inMilliseconds;

        sw.save(); // 💾 persist
        changed = true;
      }
    }

    if (changed) notifyListeners();
  }

  List<StopwatchEntry> get sortedStopwatches {
    final list = _box.values.toList();

    final anyRunning = list.any((s) => s.isRunning);

    if (anyRunning) {
      int priority(StopwatchEntry s) {
        if (s.isRunning) return 0;
        if (s.elapsedMilliseconds > 0) return 1;
        return 2;
      }

      list.sort((a, b) {
        final p = priority(a).compareTo(priority(b));
        if (p != 0) return p;

        if (a.isRunning && b.isRunning) {
          return (b.startedAt ?? DateTime(0))
              .compareTo(a.startedAt ?? DateTime(0));
        }

        return a.elapsedMilliseconds.compareTo(b.elapsedMilliseconds);
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

      return a.elapsedMilliseconds.compareTo(b.elapsedMilliseconds);
    });

    return list;
  }

  Future<void> addStopwatch(StopwatchEntry entry) async {
    await _box.put(entry.id, entry);
    notifyListeners();
  }

  Future<void> removeStopwatch(String id) async {
    await _box.delete(id);
    notifyListeners();
  }

  Future<void> start(String id) async {
    final sw = _box.get(id);
    if (sw == null || !sw.isEnabled) return;

    sw.isRunning = true;
    sw.startedAt = DateTime.now();

    await sw.save();
    notifyListeners();
  }

  Future<void> pause(String id) async {
    final sw = _box.get(id);
    if (sw == null) return;

    if (sw.isRunning) {
      sw.accumulatedMs = sw.elapsedMilliseconds;
      sw.isRunning = false;
      sw.startedAt = null;

      await sw.save();
      notifyListeners();
    }
  }

  Future<void> reset(String id) async {
    final sw = _box.get(id);
    if (sw == null) return;

    sw.isRunning = false;
    sw.startedAt = null;
    sw.elapsedMilliseconds = 0;
    sw.accumulatedMs = 0;
    sw.laps.clear();

    await sw.save();
    notifyListeners();
  }

  Future<void> addLap(String id) async {
    final sw = _box.get(id);
    if (sw == null || !sw.isRunning) return;

    final lastTotal =
        sw.laps.isEmpty ? 0 : sw.laps.last.totalMilliseconds;

    sw.laps.add(
      LapEntry(
        lapNumber: sw.laps.length + 1,
        lapMilliseconds: sw.elapsedMilliseconds - lastTotal,
        totalMilliseconds: sw.elapsedMilliseconds,
      ),
    );

    await sw.save();
    notifyListeners();
  }

  bool get anyRunning => _box.values.any((s) => s.isRunning);

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}