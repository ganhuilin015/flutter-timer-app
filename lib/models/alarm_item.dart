import 'package:hive/hive.dart';

part 'alarm_item.g.dart';

@HiveType(typeId: 3)
class AlarmItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int hour;

  @HiveField(3)
  int minute;

  @HiveField(4)
  List<bool> repeatDays;

  @HiveField(5)
  bool isEnabled;

  @HiveField(6)
  String sound;

  @HiveField(7)
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

  DateTime get nextTrigger {
    final now = DateTime.now();
    var candidate = DateTime(now.year, now.month, now.day, hour, minute);

    if (candidate.isBefore(now) || candidate.isAtSameMomentAs(now)) {
      candidate = candidate.add(const Duration(days: 1));
    }

    if (!repeats) return candidate;

    for (int i = 0; i < 7; i++) {
      final dayIndex = (candidate.weekday - 1) % 7;
      if (repeatDays[dayIndex]) return candidate;
      candidate = candidate.add(const Duration(days: 1));
    }

    return candidate;
  }
}