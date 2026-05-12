import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  static Future<void> init() async {
    final service = NotificationService();
    if (service._initialized) return;

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const macSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await service._plugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
        macOS: macSettings,
      ),
    );

    service._initialized = true;
  }

  Future<void> showServerDown() async {
    await _plugin.show(
      1,
      'Hermes Server Offline',
      'Cannot reach the dashboard. Check Tailscale and server status.',
      const NotificationDetails(
        macOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  Future<void> showServerBack() async {
    await _plugin.show(
      2,
      'Hermes Server Online',
      'Dashboard connection restored.',
      const NotificationDetails(
        macOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: false,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: false,
        ),
      ),
    );
  }
}
