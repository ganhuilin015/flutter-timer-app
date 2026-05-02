import 'package:hive/hive.dart';

part 'stopwatch_entry.g.dart';

@HiveType(typeId: 10)
class LapEntry {
  @HiveField(0)
  final int lapNumber;

  @HiveField(1)
  final int lapMilliseconds;

  @HiveField(2)
  final int totalMilliseconds;

  const LapEntry({
    required this.lapNumber,
    required this.lapMilliseconds,
    required this.totalMilliseconds,
  });

  String get formattedLap => _format(lapMilliseconds);
  String get formattedTotal => _format(totalMilliseconds);

  static String _format(int ms) {
    final minutes = ms ~/ 60000;
    final seconds = (ms % 60000) ~/ 1000;
    final centiseconds = (ms % 1000) ~/ 10;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}.'
        '${centiseconds.toString().padLeft(2, '0')}';
  }
}

@HiveType(typeId: 11)
class StopwatchEntry extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int elapsedMilliseconds;

  @HiveField(3)
  bool isRunning;

  @HiveField(4)
  bool isEnabled;

  @HiveField(5)
  List<LapEntry> laps;

  @HiveField(6)
  String color;

  @HiveField(7)
  DateTime? startedAt;

  @HiveField(8)
  int accumulatedMs;

  StopwatchEntry({
    required this.id,
    required this.name,
    this.elapsedMilliseconds = 0,
    this.isRunning = false,
    this.isEnabled = true,
    List<LapEntry>? laps,
    this.color = '#7C5CFC',
    this.startedAt,
    this.accumulatedMs = 0,
  }) : laps = laps ?? [];

  String get formattedTime {
    final ms = elapsedMilliseconds;
    final minutes = ms ~/ 60000;
    final seconds = (ms % 60000) ~/ 1000;
    final centiseconds = (ms % 1000) ~/ 10;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}.'
        '${centiseconds.toString().padLeft(2, '0')}';
  }
}