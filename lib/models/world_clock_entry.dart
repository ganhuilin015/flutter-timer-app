import 'package:timezone/timezone.dart' as tz;

class WorldClock {
  final String id;
  String cityName;
  String countryName;
  String timeZoneName; // IANA like "Europe/London"
  bool isEnabled;
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

  DateTime get currentTime {
    return tz.TZDateTime.now(location);
  }

  String get formattedTime {
    final t = currentTime;
    final hour = t.hour;
    final minute = t.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final h = hour % 12 == 0 ? 12 : hour % 12;
    return '$h:$minute $period';
  }

  String get formattedDate {
    final t = currentTime;
    const months = [
      'Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'
    ];
    const days = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];

    return '${days[t.weekday - 1]}, ${months[t.month - 1]} ${t.day}';
  }

  DateTime get utcTime {
    return currentTime.toUtc();
  }
}