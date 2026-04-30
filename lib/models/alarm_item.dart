class AlarmItem {
  final String id;
  String name;
  int hour;
  int minute;
  List<bool> repeatDays; // Mon=0 ... Sun=6
  bool isEnabled;
  String sound;
  String color;

  AlarmItem({
    required this.id,
    required this.name,
    required this.hour,
    required this.minute,
    List<bool>? repeatDays,
    this.isEnabled = true,
    this.sound = 'default',
    this.color = '#FF6B6B',
  }) : repeatDays = repeatDays ?? List.filled(7, false);

  bool get repeats => repeatDays.any((d) => d);

  String get formattedTime {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  /// Returns the next trigger DateTime from now
  DateTime get nextTrigger {
    final now = DateTime.now();
    var candidate = DateTime(now.year, now.month, now.day, hour, minute);
    if (candidate.isBefore(now) || candidate.isAtSameMomentAs(now)) {
      candidate = candidate.add(const Duration(days: 1));
    }

    if (!repeats) {
      return candidate;
    }

    for (int i = 0; i < 7; i++) {
      final dayIndex = (candidate.weekday - 1) % 7;
      if (repeatDays[dayIndex]) return candidate;
      candidate = candidate.add(const Duration(days: 1));
    }
    return candidate;
  }

  AlarmItem copyWith({
    String? id,
    String? name,
    int? hour,
    int? minute,
    List<bool>? repeatDays,
    bool? isEnabled,
    String? sound,
    String? color,
  }) {
    return AlarmItem(
      id: id ?? this.id,
      name: name ?? this.name,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      repeatDays: repeatDays ?? List.from(this.repeatDays),
      isEnabled: isEnabled ?? this.isEnabled,
      sound: sound ?? this.sound,
      color: color ?? this.color,
    );
  }
}
