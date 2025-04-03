import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:childsafeapp/services/notification_service.dart';

class BleService {
  FlutterBluePlus flutterBlue = FlutterBluePlus();

  final Guid targetService = Guid("1a691c51-8c3c-4dd9-afcd-527e77c64be7");
  final Guid targetCharacteristic = Guid("f8a4bc7a-ca55-4fa5-92a6-228e0e47b749");

  final int scanTimeout = 10;
  late BluetoothDevice sensor;
  late BluetoothCharacteristic sensorCharacteristic;
  late Stream<List<int>> sensorDataStream;

  // Variables for testing
  int count = 0;
  int alarm = -1;

  /* Connection Methods */

  void requestPermissions() async {
    List<Permission> permissions = [
      Permission.location,
      Permission.storage,
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      ];
    await permissions.request();
  }

  void checkAndRequestPermissions() async {
    if (await Permission.bluetoothScan.isDenied ||
        await Permission.bluetoothConnect.isDenied) {
      print("permissions denied, requesting permissions");
            requestPermissions();
    } else {
      print("permissions granted");
    }
  }

  void connectToSensorStream() async {
    // TODO: Implement retries and error handling
    checkAndRequestPermissions();

    var subscription = FlutterBluePlus.scanResults.listen((results) {
            if (results.isNotEmpty) {
                ScanResult r = results.last; // the most recently found device
                print('${r.device.remoteId}: "${r.advertisementData.advName}" found!');
                sensor = r.device;
            }
        },
        onError: (e) => print(e),
    );

    // cleanup: cancel subscription when scanning stops
    FlutterBluePlus.cancelWhenScanComplete(subscription);

    // Wait for Bluetooth enabled & permission granted
    // In your real app you should use `FlutterBluePlus.adapterState.listen` to handle all states
    await FlutterBluePlus.adapterState.where((val) => val == BluetoothAdapterState.on).first;

    // Start scanning for sensor
    await FlutterBluePlus.startScan(
      timeout: Duration(seconds:scanTimeout),
      withServices: [targetService]);

    // wait for scanning to stop
    await FlutterBluePlus.isScanning.where((val) => val == false).first;

    // Connect to found sensor
    // listen for disconnection
    var connectSubscription = sensor.connectionState.listen((BluetoothConnectionState state) async {
        if (state == BluetoothConnectionState.disconnected) {
            // 1. typically, start a periodic timer that tries to 
            //    reconnect, or just call connect() again right now
            // 2. you must always re-discover services after disconnection!
            print("${sensor.disconnectReason?.code} ${sensor.disconnectReason?.description}");
        }
    });

    // cleanup: cancel subscription when disconnected
    //   - [delayed] This option is only meant for `connectionState` subscriptions.  
    //     When `true`, we cancel after a small delay. This ensures the `connectionState` 
    //     listener receives the `disconnected` event.
    //   - [next] if true, the the stream will be canceled only on the *next* disconnection,
    //     not the current disconnection. This is useful if you setup your subscriptions
    //     before you connect.
    sensor.cancelWhenDisconnected(connectSubscription, delayed:true, next:true);

    try {
      // Connect to the device with a timeout
      await sensor.connect(timeout: Duration(seconds: 60), autoConnect: false);

      // Skip MTU request as the device defaults to 23 bytes
      print("Connected successfully with default MTU size (23 bytes).");
    } catch (e) {
      print("Error during connection: $e");
      // return; // Assuming that the failed case will not impact the running
    }

    await Future.delayed(Duration(seconds: 90)); // wait for 70 seconds before discovering services

    setUpListener();
    

    // // Disconnect from device
    // await sensor.disconnect();

    // connectSubscription.cancel();
    // subscription.cancel();
  }

  // Subscribes to stream and setup event error handling
  void setUpListener() async {
    int retries = 3;
    // Note: You must call discoverServices after every re-connection!
    sensor.connectionState.listen((state) {
      if (state == BluetoothConnectionState.disconnected) {
        print("Device disconnected during service discovery.");
      }
    });
    List<BluetoothService> services;
    services = await sensor.discoverServices();

    for (int i = 0; i < retries; i++) {
      if (services.isNotEmpty) {
        print("Services discovered successfully.");
        break;
      } else {
        print("Retrying service discovery... ($i)");
        await Future.delayed(Duration(seconds: 5));
        services = await sensor.discoverServices();
      }
    }
    if (services.isEmpty) {
      print("No services discovered. Ensure the device is ready.");
    } else {
      services.forEach((service) {
        if (service.uuid == targetService) {
          service.characteristics.forEach((characteristic) async {
            if (characteristic.uuid == targetCharacteristic) {
              sensorCharacteristic = characteristic;
              print("Found target characteristic: $sensorCharacteristic");
              await sensorCharacteristic.setNotifyValue(true);
            }
          });
        }
      });
    }

    var sensorDataStream = sensorCharacteristic.onValueReceived.listen((signal) {
      // TODO: Document characteristic value format
      int childStatus = signal[0];
      count++;
      alarm = childStatus; // For testing only

      if (childStatus == 1) sendPushNotification();
      if (childStatus != 1) {
        print(alarm);
      }
    });
  }

  void sendPushNotification() async {
    await showNotification("Child left in car");
  }

  List<int> testOutput() {
    return [count, alarm];
  }

}