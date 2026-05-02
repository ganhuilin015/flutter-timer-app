import 'package:hive/hive.dart';
import 'package:timezone/timezone.dart' as tz;

part 'world_clock_entry.g.dart';

@HiveType(typeId: 0)
class WorldClock extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String cityName;

  @HiveField(2)
  String countryName;

  @HiveField(3)
  String timeZoneName;

  @HiveField(4)
  bool isEnabled;

  @HiveField(5)
  String color;

  WorldClock({
    required this.id,
    required this.cityName,
    required this.countryName,
    required this.timeZoneName,
    this.isEnabled = true,
    this.color = '#FFB347',
  });

  tz.Location get location => tz.getLocation(timeZoneName);

  DateTime get currentTime => tz.TZDateTime.now(location);

  String get formattedTime {
    final t = currentTime;
    final hour = t.hour;
    final minute = t.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final h = hour % 12 == 0 ? 12 : hour % 12;
    return '$h:$minute $period';
  }

  String get formattedDate {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    const days = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];

    final t = currentTime;
    return '${days[t.weekday - 1]}, ${months[t.month - 1]} ${t.day}';
  }
}