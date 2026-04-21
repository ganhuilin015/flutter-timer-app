class LapEntry {
  final int lapNumber;
  final int lapMilliseconds;   // time for this lap
  final int totalMilliseconds; // total elapsed

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
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${centiseconds.toString().padLeft(2, '0')}';
  }
}

class StopwatchEntry {
  final String id;
  String name;
  int elapsedMilliseconds;
  bool isRunning;
  bool isEnabled;
  List<LapEntry> laps;
  String color;
  DateTime? startedAt;
  int accumulatedMs; // ms before last start

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
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${centiseconds.toString().padLeft(2, '0')}';
  }
}
