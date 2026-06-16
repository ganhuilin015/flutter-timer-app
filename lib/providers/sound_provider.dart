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

  final List<VoidCallback> _listeners = [];

  late Box _box;

  SoundProvider() {
    _box = Hive.box(_boxName);
  }

  final List<SoundItem> sounds = [
    SoundItem(name: 'Alert', file: 'alert.mp3'),
    SoundItem(name: 'Buzzer', file: 'alarmbuzzer.mp3'),
    SoundItem(name: 'Beautiful Dream', file: 'beautifuldream.mp3'),
    SoundItem(name: 'Classic', file: 'classic.mp3'),
    SoundItem(name: 'Retro', file: 'retro.mp3'),
    SoundItem(name: 'Rooster', file: 'rooster.mp3'),
    SoundItem(name: 'Soft Beep', file: 'beep.mp3'),
    SoundItem(name: 'Bird Singing', file: 'birdssinging.mp3'),
    SoundItem(name: 'Casino', file: 'casino.mp3'),
    SoundItem(name: 'Cat Walk', file: 'catwalk.mp3'),
    SoundItem(name: 'Cheers', file: 'cheers.mp3'),
    SoundItem(name: 'Complicated', file: 'complicated.mp3'),
    SoundItem(name: 'Crowd Laugh', file: 'crowdlaugh.mp3'),
    SoundItem(name: 'Driving Ambition', file: 'drivingambition.mp3'),
    SoundItem(name: 'Game Over', file: 'gameover.mp3'),
    SoundItem(name: 'Game Show', file: 'gameshow.mp3'),
    SoundItem(name: 'Keyboard Typing', file: 'keyboardtyping.mp3'),
    SoundItem(name: 'Latin Lovers', file: 'latinlovers.mp3'),
    SoundItem(name: 'Light Rain', file: 'lightrain.mp3'),
    SoundItem(name: 'Piano Horror', file: 'pianohorror.mp3'),
    SoundItem(name: 'Romantic', file: 'romantic.mp3'),
    SoundItem(name: 'Silent Descent', file: 'silentdescent.mp3'),
    SoundItem(name: 'Tech House', file: 'techhouse.mp3'),
    SoundItem(name: 'Tick Tock', file: 'ticktock.mp3'),
    SoundItem(name: 'Villa Penthouse', file: 'villapenthouse.mp3'),
    SoundItem(name: 'Vintage Phone', file: 'vintagephone.mp3'),
    SoundItem(name: 'Wood Spirits', file: 'woodspirits.mp3'),
  ];

  List<SoundItem> get sortedSounds {
    final list = List<SoundItem>.from(sounds);

    list.sort((a, b) =>
        a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    return list;
  }

  SoundItem get alarmSound {
    final file = _box.get('alarm_sound');

    return sortedSounds.firstWhere(
      (s) => s.file == file,
      orElse: () => sortedSounds.first,
    );
  }

  SoundItem get timerSound {
    final file = _box.get('timer_sound');

    return sortedSounds.firstWhere(
      (s) => s.file == file,
      orElse: () => sortedSounds.first,
    );
  }

  void setAlarmSound(SoundItem sound) {
    _box.put('alarm_sound', sound.file);
    notifyListeners();
  }

  void setTimerSound(SoundItem sound) {
    _box.put('timer_sound', sound.file);
    notifyListeners();
    _notifySoundChanged();
  }

  void addListenerCallback(VoidCallback cb) {
    _listeners.add(cb);
  }

  void _notifySoundChanged() {
    for (final cb in _listeners) {
      cb();
    }
  }

}