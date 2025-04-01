import 'package:flutter/material.dart';
import 'package:childsafeapp/services/notification_store.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = NotificationStore.notifications;

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: notifications.isEmpty
          ? const Center(child: Text('No notifications yet.'))
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notif = notifications[index];
                return ListTile(
                  title: Text(notif.body),
                  subtitle: Text(notif.timestamp.toLocal().toString()),
                );
              },
            ),
    );
  }
}
