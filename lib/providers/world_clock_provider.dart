import 'package:flutter/foundation.dart';
import 'package:timer/models/world_clock_entry.dart';

class WorldClockProvider extends ChangeNotifier {
  final List<WorldClock> _clocks = [];

  List<WorldClock> get clocks => List.unmodifiable(_clocks);

  void addClock(WorldClock clock) {
    _clocks.add(clock);
    notifyListeners();
  }

  void removeClock(String id) {
    _clocks.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  void toggleClock(String id) {
    final clock = _clocks.firstWhere((c) => c.id == id);
    clock.isEnabled = !clock.isEnabled;
    notifyListeners();
  }

  void updateClock(String id, WorldClock clock) {
    final index = _clocks.indexWhere((c) => c.id == id);
    if (index == -1) return;

    _clocks[index] = clock;
    notifyListeners();
  }

  void reorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;
    final item = _clocks.removeAt(oldIndex);
    _clocks.insert(newIndex, item);
    notifyListeners();
  }

}