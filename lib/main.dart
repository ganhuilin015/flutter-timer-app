import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:timer/providers/theme_provider.dart';
import 'providers/timer_provider.dart';
import 'providers/stopwatch_provider.dart';
import 'providers/alarm_provider.dart';
// import 'providers/world_clock_provider.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> _requestAndroidPermissions() async {
  if (!Platform.isAndroid) return;

  await Permission.notification.request();
  final exactAlarmStatus = await Permission.scheduleExactAlarm.status;
  if (!exactAlarmStatus.isGranted) {
    await Permission.scheduleExactAlarm.request();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

  await _requestAndroidPermissions();

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
        // ChangeNotifierProvider(create: (_) => WorldClockProvider()),
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