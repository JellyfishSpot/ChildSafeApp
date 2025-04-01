import 'package:childsafeapp/models/app_notification.dart';

class NotificationStore {
  static final List<AppNotification> _notifications = [];

  static List<AppNotification> get notifications => _notifications;

  static void addNotification(AppNotification notification) {
    _notifications.insert(0, notification); // latest first
  }
}
