import 'package:flutter/material.dart';
import 'package:childsafeapp/navigation_scaffold.dart';

import 'package:childsafeapp/services/notification_service.dart';

Future<void> main() async {
  await initNotifications();

  runApp(const MyApp());
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



