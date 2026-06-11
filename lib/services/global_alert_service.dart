import 'dart:async';

class GlobalAlertService {
  static final instance = GlobalAlertService._internal();
  GlobalAlertService._internal();

  final _controller = StreamController<dynamic>.broadcast();

  Stream<dynamic> get stream => _controller.stream;

  void showAlarm(dynamic alarm) {
    _controller.add(alarm);
  }
}