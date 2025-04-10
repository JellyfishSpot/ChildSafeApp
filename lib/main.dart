import 'package:flutter/material.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

import 'package:childsafeapp/navigation_scaffold.dart';
import 'package:childsafeapp/services/foreground_service.dart';
import 'package:childsafeapp/services/notification_service.dart';
import 'package:childsafeapp/services/amber_alert_notification_service.dart';




Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AndroidAlarmManager.initialize();
  await initNotifications();
  await initAmberAlertNotifications();

  ForegroundTaskService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const WithForegroundTask(child: NavigationScaffold())
    );
  }
}



