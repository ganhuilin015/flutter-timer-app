import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:timer/models/world_clock_entry.dart';

class WorldClockProvider extends ChangeNotifier {
  static const String boxName = 'worldClocks';

  Box<WorldClock> get _box => Hive.box<WorldClock>(boxName);

  List<WorldClock> get clocks => sortedClocks;

  Future<void> addClock(WorldClock clock) async {
    await _box.put(clock.id, clock);
    notifyListeners();
  }

  Future<void> removeClock(String id) async {
    await _box.delete(id);
    notifyListeners();
  }

  Future<void> toggleClock(String id) async {
    final clock = _box.get(id);
    if (clock == null) return;

    clock.isEnabled = !clock.isEnabled;
    await clock.save();
    notifyListeners();
  }

  Future<void> updateClock(String id, WorldClock updated) async {
    await _box.put(id, updated);
    notifyListeners();
  }

  List<WorldClock> get sortedClocks {
    final list = _box.values.toList();

    list.sort((a, b) {
      final aTime = a.currentTime;
      final bTime = b.currentTime;

      final aMinutes = aTime.hour * 60 + aTime.minute;
      final bMinutes = bTime.hour * 60 + bTime.minute;

      return aMinutes.compareTo(bMinutes);
    });

    return list;
  }
}