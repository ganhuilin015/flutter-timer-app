enum TimerStatus { idle, running, paused, finished }

class TimerItem {
  final String id;
  String name;
  int totalSeconds;
  int remainingSeconds;
  TimerStatus status;
  bool isEnabled;
  String color;

  TimerItem({
    required this.id,
    required this.name,
    required this.totalSeconds,
    int? remainingSeconds,
    this.status = TimerStatus.idle,
    this.isEnabled = true,
    this.color = '#00E5CC',
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
    if (h > 0) {
      return '${h}h ${m}m ${s}s';
    }
    if (m > 0) return '${m}m ${s}s';
    return '${s}s';
  }

  TimerItem copyWith({
    String? id,
    String? name,
    int? totalSeconds,
    int? remainingSeconds,
    TimerStatus? status,
    bool? isEnabled,
    String? color,
  }) {
    return TimerItem(
      id: id ?? this.id,
      name: name ?? this.name,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      status: status ?? this.status,
      isEnabled: isEnabled ?? this.isEnabled,
      color: color ?? this.color,
    );
  }
}
