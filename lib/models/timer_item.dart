import 'package:hive/hive.dart';

part 'timer_item.g.dart';

@HiveType(typeId: 1)
enum TimerStatus {
  @HiveField(0)
  idle,

  @HiveField(1)
  running,

  @HiveField(2)
  paused,

  @HiveField(3)
  finished,
}

@HiveType(typeId: 2)
class TimerItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int totalSeconds;

  @HiveField(3)
  int remainingSeconds;

  @HiveField(4)
  TimerStatus status;

  @HiveField(5)
  String color;

  @HiveField(6)
  String soundFile;

  TimerItem({
    required this.id,
    required this.name,
    required this.totalSeconds,
    int? remainingSeconds,
    this.status = TimerStatus.idle,
    this.color = '#00E5CC',
    this.soundFile = 'alarmbuzzer.mp3',
  }) : remainingSeconds = remainingSeconds ?? totalSeconds;

  double get progress {
    if (totalSeconds == 0) return 0;
    return 1 - (remainingSeconds / totalSeconds);
  }

  bool get isRunning => status == TimerStatus.running;
  bool get isPaused => status == TimerStatus.paused;
  bool get isFinished => status == TimerStatus.finished;
  bool get isIdle => status == TimerStatus.idle;

  String get formattedTime {
    final h = remainingSeconds ~/ 3600;
    final m = (remainingSeconds % 3600) ~/ 60;
    final s = remainingSeconds % 60;

    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }

    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  String get formattedTotal {
    final h = totalSeconds ~/ 3600;
    final m = (totalSeconds % 3600) ~/ 60;
    final s = totalSeconds % 60;

    if (h > 0) return '${h}h ${m}m ${s}s';
    if (m > 0) return '${m}m ${s}s';
    return '${s}s';
  }

  TimerItem copyWith({
    String? id,
    String? name,
    int? totalSeconds,
    int? remainingSeconds,
    TimerStatus? status,
    String? color,
    String? soundFile,
  }) {
    return TimerItem(
      id: id ?? this.id,
      name: name ?? this.name,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      status: status ?? this.status,
      color: color ?? this.color,
      soundFile: soundFile ?? this.soundFile,
    );
  }
}