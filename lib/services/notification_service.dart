import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  final _platformChannel = const MethodChannel('custom.notification.channel');

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Future<void> initNotification() async {
    if (_isInitialized) return;

    const initSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_notification');

    const initSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );

    await notificationsPlugin.initialize(initSettings);
    _isInitialized = true;
  }

  NotificationDetails notificationsDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_channel_id',
        'Daily Notifications',
        channelDescription: "Daily Notifications Channel",
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_notification', // white-only icon for small icon
        largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_notification'),
        color: Colors.red,
        colorized: true,
        ledColor: Colors.red,
        ledOnMs: 100,
        ledOffMs: 200,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  /// Standard notification
  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    return notificationsPlugin.show(
      id,
      title,
      body,
      notificationsDetails(),
    );
  }

  /// Native-style custom notification with colored icon (like Duolingo)
  Future<void> showNativeCustomNotification({
    required String title,
    required String body,
  }) async {
    try {
      await _platformChannel.invokeMethod('showNotification', {
        'title': title,
        'message': body,
      });
    } catch (e) {
      debugPrint('Error showing native custom notification: $e');
    }
  }
}
