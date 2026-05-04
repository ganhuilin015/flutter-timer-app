import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:timer/models/alarm_item.dart';
import 'package:timer/models/stopwatch_entry.dart';
import 'package:timer/models/timer_item.dart';
import 'package:timer/models/world_clock_entry.dart';
import 'package:timer/providers/sound_provider.dart';
import 'package:timer/providers/theme_provider.dart';
import 'package:timer/services/notification_service.dart';
import 'providers/timer_provider.dart';
import 'providers/stopwatch_provider.dart';
import 'providers/alarm_provider.dart';
import 'providers/world_clock_provider.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:hive_flutter/hive_flutter.dart';

Future<void> _requestAndroidPermissions() async {
  if (!Platform.isAndroid) return;

  await Permission.notification.request();
  final exactAlarmStatus = await Permission.scheduleExactAlarm.status;
  if (!exactAlarmStatus.isGranted) {
    await Permission.scheduleExactAlarm.request();
  }
  await Permission.ignoreBatteryOptimizations.request();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Kuala_Lumpur'));

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  await NotificationService.init();
  await _requestAndroidPermissions();

  await Hive.initFlutter();

  Hive.registerAdapter(TimerStatusAdapter());
  Hive.registerAdapter(TimerItemAdapter());
  await Hive.openBox<TimerItem>('timers');

  Hive.registerAdapter(StopwatchEntryAdapter());
  Hive.registerAdapter(LapEntryAdapter());
  await Hive.openBox<StopwatchEntry>('stopwatches');

  Hive.registerAdapter(WorldClockAdapter());
  await Hive.openBox<WorldClock>('worldClocks');

  Hive.registerAdapter(AlarmItemAdapter());
  await Hive.openBox<AlarmItem>('alarms');

  await Hive.openBox('settings');

  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => TimerProvider()),
        ChangeNotifierProvider(create: (_) => StopwatchProvider()),
        ChangeNotifierProvider(create: (_) => AlarmProvider()),
        ChangeNotifierProvider(create: (_) => WorldClockProvider()),
        ChangeNotifierProvider(create: (_) => SoundProvider()),
      ],

      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Chrono',
            debugShowCheckedModeBanner: false,
            navigatorKey: navigatorKey,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeProvider.themeMode,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
