import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:timer/models/world_clock_entry.dart';

class WorldClockProvider extends ChangeNotifier {
  static const String boxName = 'worldClocks';

  Box<WorldClock> get _box => Hive.box<WorldClock>(boxName);

  List<WorldClock> get clocks => _box.values.toList();

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

  Future<void> reorder(int oldIndex, int newIndex) async {
    final list = _box.values.toList();

    if (newIndex > oldIndex) newIndex--;

    final item = list.removeAt(oldIndex);
    list.insert(newIndex, item);

    await _box.clear();

    for (final clock in list) {
      await _box.put(clock.id, clock);
    }

    notifyListeners();
  }
}