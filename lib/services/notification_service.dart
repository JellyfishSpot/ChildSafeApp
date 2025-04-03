import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:childsafeapp/models/app_notification.dart';
import 'package:childsafeapp/services/notification_store.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  AndroidInitializationSettings androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  DarwinInitializationSettings iosInit = DarwinInitializationSettings();
  final InitializationSettings setInit = InitializationSettings(android: androidInit, iOS: iosInit);
  bool? initialized = await flutterLocalNotificationsPlugin.initialize(setInit); // no onDidReceiveNotifications. Might be necessary?

  if (initialized == true) {
    print("Notifications initialized successfully.");
  } else {
    print("Failed to initialize notifications.");
  }
}

Future<void> requestNotificationPermissions() async {
  final bool? result = await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();
  if (result != null && result) {
    // Permission granted
    print('Notification permission granted.');
  } else {
    // Permission denied
    print('Notification permission denied.');
  }
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

  // Save to local store
  NotificationStore.addNotification(AppNotification(
    title: "ChildSafe",
    body: message,
    timestamp: DateTime.now(),
  ));

  await flutterLocalNotificationsPlugin.show(
    0,
    "ChildSafe",
    "Child Left in Car",
    details,
  );

  print("Notification sent: $message");

}