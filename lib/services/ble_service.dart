import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleService {
  FlutterBluePlus flutterBlue = FlutterBluePlus();

  final Guid targetService = Guid("1a691c51-8c3c-4dd9-afcd-527e77c64be7");
  final Guid targetCharacteristic = Guid("f8a4bc7a-ca55-4fa5-92a6-228e0e47b749");

  final Duration scanTimeout = Duration(seconds: 30);
  late BluetoothDevice sensor;
  late BluetoothCharacteristic sensorCharacteristic;
  late Stream<List<int>> sensorDataStream;

  /* Connection Methods */

  // Using service uuid, should return only our sensor device
  Future<void> _scanForSensor() {
    return FlutterBluePlus.startScan(withServices: [targetService], timeout: scanTimeout);
  }

  void connectToSensorStream() async {
    // TODO: Implement retries and error handling
    await _scanForSensor();
    await for (var results in FlutterBluePlus.scanResults) {
      for (ScanResult result in results) {
        sensor = result.device; // Loops should be unneccesary. Maybe find a way to unpack easier
        sensorCharacteristic = sensor.servicesList[0].characteristics[0];
        sensorCharacteristic.setNotifyValue(true);
      }
    }

    setUpListener();
  }

  // Subscribes to stream and setup event error handling
  void setUpListener() {
    var sensorDataStream = sensorCharacteristic.onValueReceived.listen( (signal) {
      // TODO: Determine signal input size and meaning
      int childStatus = signal[0]; 

      if (childStatus == 1) sendPushNotification();

    });
    
  }

  void sendPushNotification() {
    
  }

}