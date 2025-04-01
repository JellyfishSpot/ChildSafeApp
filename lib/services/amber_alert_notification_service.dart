import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

final FlutterLocalNotificationsPlugin amberNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> initAmberAlertNotifications() async {
  const AndroidInitializationSettings androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  const DarwinInitializationSettings iosInit = DarwinInitializationSettings();

  final InitializationSettings initSettings = InitializationSettings(
    android: androidInit,
    iOS: iosInit,
  );

  await amberNotificationsPlugin.initialize(initSettings);
}

Future<void> showAmberAlertNotification(String message) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'amber_channel',
    'Amber Alerts',
    channelDescription: 'High-priority urgent alerts',
    importance: Importance.max,
    priority: Priority.high,
    fullScreenIntent: true,
    playSound: true,
    enableVibration: true,
    enableLights: true,
    sound: RawResourceAndroidNotificationSound('alert_sound'),
    color: Color(0xFFFF0000), // Red
  );

  const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentSound: true,
  );

  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidDetails,
    iOS: iosDetails,
  );

  await amberNotificationsPlugin.show(
    1, // unique ID
    'AMBER ALERT',
    message,
    notificationDetails,
  );
}
