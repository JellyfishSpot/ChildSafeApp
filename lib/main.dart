import 'package:flutter/material.dart';
import 'package:childsafeapp/navigation_scaffold.dart';
import 'package:childsafeapp/services/notification_service.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:childsafeapp/services/amber_alert_notification_service.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print("Starting app...");

  await AndroidAlarmManager.initialize();
  print("Alarm manager initialized");

  await initNotifications();
  print("Standard notifications initialized");

  await initAmberAlertNotifications();
  print("Amber alert notifications initialized");

  runApp(const MyApp());
  print("runApp() called");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NavigationScaffold()
    );
  }
}



