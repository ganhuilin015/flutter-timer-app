import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<bool> isNotificationGranted() async {
    return await Permission.notification.isGranted;
  }

  static Future<bool> isLocationGranted() async {
    return await Permission.locationWhenInUse.isGranted;
  }

  static Future<void> requestNotification() async {
    await Permission.notification.request();
  }

  static Future<void> requestLocation() async {
    await Permission.locationWhenInUse.request();
  }

  static Future<void> openSettings() async {
    await openAppSettings();
  }
}