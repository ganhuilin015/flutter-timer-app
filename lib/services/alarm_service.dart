import 'package:flutter/services.dart';

class NativeAlarmService {
  static const _channel = MethodChannel('com.example.timer_app/alarm');

  static Future<void> scheduleAlarm({
    required int id,
    required DateTime triggerTime,
    required String title,
    required String body,
    String sound = 'alarm_sound',
  }) async {
    await _channel.invokeMethod('scheduleAlarm', {
      'id': id,
      'triggerMs': triggerTime.millisecondsSinceEpoch,
      'title': title,
      'body': body,
      'sound': sound,
    });
  }

  static Future<void> cancelAlarm(int id) async {
    await _channel.invokeMethod('cancelAlarm', {'id': id});
  }

  static Future<void> scheduleTimer({
    required int id,
    required DateTime triggerTime,
    required String title,
    required String body,
  }) async {
    await _channel.invokeMethod('scheduleTimer', {
      'id': id,
      'triggerMs': triggerTime.millisecondsSinceEpoch,
      'title': title,
      'body': body,
    });
  }

  /// Cancel a previously scheduled timer by [id].
  static Future<void> cancelTimer(int id) async {
    await _channel.invokeMethod('cancelTimer', {'id': id});
  }
}
