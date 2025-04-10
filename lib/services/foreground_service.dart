import 'dart:async';

import 'package:childsafeapp/services/notification_service.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

late BluetoothDevice sensor;
late BluetoothCharacteristic characteristic;

Future<ServiceRequestResult> startService(BluetoothDevice sensorDevice, BluetoothCharacteristic sensorCharacteristic) async {
  sensor = sensorDevice;
  characteristic = sensorCharacteristic;
  print("startedServer wrapper");

  if (await FlutterForegroundTask.isRunningService) {
    return FlutterForegroundTask.restartService();
  } else {
    return FlutterForegroundTask.startService(
      serviceId: 256,
      notificationTitle: 'Foreground Service is running',
      notificationText: 'Tap to return to the app',
      notificationIcon: null,
      notificationButtons: [
        const NotificationButton(id: 'btn_hello', text: 'hello'),
      ],
      notificationInitialRoute: '/',
      callback: startCallback,
    );
  }
}

class ForegroundTaskService{
  static init(){
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'foreground_service',
        channelName: 'Foreground Service Notification',
        channelDescription: 'This notification appears when the foreground service is running.',
        channelImportance: NotificationChannelImportance.HIGH,
        priority: NotificationPriority.HIGH,
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
  FlutterForegroundTask.setTaskHandler(SensorListenerTaskHandler(sensor, characteristic));
}

class SensorListenerTaskHandler extends TaskHandler {
  int alarm = -1;
  late BluetoothDevice sensor;
  late BluetoothCharacteristic sensorCharacteristic;

  SensorListenerTaskHandler(BluetoothDevice sensor, BluetoothCharacteristic sensorCharacteristic) {
    this.sensor = sensor;
    this.sensorCharacteristic = sensorCharacteristic;
  }

  // Called when the task is started.
  @override
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    print("onStart called");

    // Setup disconnect listener
    var connectSubscription = sensor.connectionState.listen((BluetoothConnectionState state) async {
      if (state == BluetoothConnectionState.disconnected) {
        // If app disconnect while last value read was child in car, notify user
        if(alarm == 1) {
          print("disconnection method");
          sendPushNotification();
        }
        print("${sensor.disconnectReason?.code} ${sensor.disconnectReason?.description}");
      }
    });

    // Setup sensor data listener
    var sensorDataStream = sensorCharacteristic.onValueReceived.listen((signal) async {
      int childStatus = signal[0];
      alarm = childStatus;

      if (childStatus == 1) {
        // If child is still buckled for 60s after car is parked, send alarm
        print("First signal");
        await Future.delayed(Duration(seconds: 15));
        if (childStatus == 1) {
          sendPushNotification();
        }
      }
    });

    sensor.cancelWhenDisconnected(connectSubscription, delayed:true);
    sensor.cancelWhenDisconnected(sensorDataStream);
  }

  // Called every [interval] milliseconds in [ForegroundTaskOptions].
  @override
  void onRepeatEvent(DateTime timestamp) async {
    print("onRepeatEvent called");
    sendPushNotification();
  }

  // Called when the notification button on the Android platform is pressed.
  @override
  Future<void> onDestroy(DateTime timestamp) async {
    print("onDestroy called");
  }

  // Called when the notification button on the Android platform is pressed.
  @override
  void onNotificationButtonPressed(String id) {
    print("onNotificationButton called");
}

  // Called when the notification itself on the Android platform is pressed.
  // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
  // this function to be called.
  @override
  void onNotificationPressed() {
    print("onNotification called");
  }
}

void sendPushNotification() async {
  await showNotification("Child left in car");
}

Future<ServiceRequestResult> stopService() {
  return FlutterForegroundTask.stopService();
}