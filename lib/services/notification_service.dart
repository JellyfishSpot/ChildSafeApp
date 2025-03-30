import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  AndroidInitializationSettings androidInit = AndroidInitializationSettings('app_icon');
  DarwinInitializationSettings iosInit = DarwinInitializationSettings();
  final InitializationSettings setInit = InitializationSettings(android: androidInit, iOS: iosInit);
  //await flutterLocalNotificationsPlugin.initialize(setInit); // no onDidReceiveNotifications. Might be necessary?
}

Future<void> showNotification(String message) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'channel_id',
    'General Notifications',
    importance: Importance.high,
    priority: Priority.high,
  );

  const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBanner: true,
    presentSound: true
  );

  const NotificationDetails details = NotificationDetails(android: androidDetails, iOS: iosDetails);

  await flutterLocalNotificationsPlugin.show(
    0, // Notification ID
    "ChildSafe", // Title
    message, // Body
    details,
  );
}