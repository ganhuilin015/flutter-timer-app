import 'dart:async';

import 'package:flutter/material.dart';
import 'package:timer/models/timer_item.dart';
import 'package:timer/providers/alarm_provider.dart';
import 'package:timer/providers/timer_provider.dart';
import 'package:timer/services/global_alert_service.dart';
import 'package:timer/screens/full_screen_alert.dart';
import 'package:timer/utils/global_key.dart';

class GlobalAlertListener extends StatefulWidget {
  final Widget child;
  final TimerProvider timerProvider;
  final AlarmProvider alarmProvider;

  const GlobalAlertListener({
    super.key,
    required this.child,
    required this.timerProvider,
    required this.alarmProvider
  });

  @override
  State<GlobalAlertListener> createState() => _GlobalAlertListenerState();
}

class _GlobalAlertListenerState extends State<GlobalAlertListener> {
  bool _isShowing = false;

  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();

    _sub = GlobalAlertService.instance.stream.listen((data) {
      if (_isShowing) return;
      if (!mounted) return;

      _isShowing = true;

      AlertData alertData;

      if (data is TimerItem) {
        alertData = AlertData(
          title: data.name.isNotEmpty ? data.name : 'Timer',
          subtitle: data.formattedTime,
          icon: Icons.timer,
        );
      } else {
        alertData = AlertData(
          title: data.name.isNotEmpty ? data.name : 'Alarm',
          subtitle: data.formattedTime,
          icon: Icons.alarm,
        );
      }

      

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final ctx = navigatorKey.currentState?.overlay?.context;
        if (ctx == null) {
          _isShowing = false;
          return;
        }

        showGeneralDialog(
          context: ctx,
          barrierDismissible: false,
          pageBuilder: (_, __, ___) => FullScreenAlert(
            data: alertData,
            onDismiss: () {
              if (data is TimerItem) {
                widget.timerProvider.dismissFiring();
                widget.timerProvider.cancelNative(data);
              } else {
                widget.alarmProvider.dismissFiring();
                widget.alarmProvider.cancelNative(data);
              }
              if (ctx.mounted) {
                Navigator.pop(ctx);
              }
              _isShowing = false;
            },
          ),
        ).then((_) {
          _isShowing = false;
        });
      });
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
