import 'dart:async';
import 'dart:isolate';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

class ForegroundTaskService{
  static init(){
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'foreground_service',
        channelName: 'Foreground Service Notification',
        channelDescription: 'This notification appears when the foreground service is running.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.nothing(),
      ),
    );
  }
}

@pragma('vm:entry-point') // This decorator means that this function calls native code
void startCallback() {
FlutterForegroundTask.setTaskHandler(FirstTaskHandler());
}

class FirstTaskHandler extends TaskHandler {
  SendPort? _sendPort;
  
  // Called when the task is started.
  @override
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    // _sendPort = starter.sendPort; // This is used for communicating between our service and our app
    _sendPort?.send("startTask");
  }

  // Called every [interval] milliseconds in [ForegroundTaskOptions].
  @override
  void onRepeatEvent(DateTime timestamp) async {
    // Send data to the main isolate.

  }

  // Called when the notification button on the Android platform is pressed.
  @override
  Future<void> onDestroy(DateTime timestamp) async {
    // _timer?.cancel();
    FlutterForegroundTask.stopService();
  }

  // Called when the notification button on the Android platform is pressed.
  @override
  void onNotificationButtonPressed(String id) {
    // _sendPort?.send("killTask");  
}

  // Called when the notification itself on the Android platform is pressed.
  //
  // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
  // this function to be called.
  @override
  void onNotificationPressed() {
    // _timer?.cancel();
    _sendPort?.send('onNotificationPressed');
    FlutterForegroundTask.stopService();
  }
}