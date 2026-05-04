import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class SoundItem {
  final String name;
  final String file;

  SoundItem({
    required this.name,
    required this.file,
  });
}

class SoundProvider extends ChangeNotifier {
  static const _boxName = 'settings';

  late Box _box;

  SoundProvider() {
    _box = Hive.box(_boxName);
  }

  final List<SoundItem> sounds = [
    SoundItem(name: 'Alert', file: 'alert.mp3'),
    SoundItem(name: 'Buzzer', file: 'alarmbuzzer.mp3'),
    SoundItem(name: 'Classic', file: 'classic.mp3'),
    SoundItem(name: 'Retro', file: 'retro.mp3'),
    SoundItem(name: 'Rooster', file: 'rooster.mp3'),
    SoundItem(name: 'Soft Beep', file: 'beep.mp3'),
    
  ];

  SoundItem get alarmSound {
    final file = _box.get('alarm_sound');

    return sounds.firstWhere(
      (s) => s.file == file,
      orElse: () => sounds.first,
    );
  }

  SoundItem get timerSound {
    final file = _box.get('timer_sound');

    return sounds.firstWhere(
      (s) => s.file == file,
      orElse: () => sounds.first,
    );
  }

  void setAlarmSound(SoundItem sound) {
    _box.put('alarm_sound', sound.file);
    notifyListeners();
  }

  void setTimerSound(SoundItem sound) {
    _box.put('timer_sound', sound.file);
    notifyListeners();
  }
}