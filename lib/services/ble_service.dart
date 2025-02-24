import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleService {
  FlutterBluePlus flutterBlue = FlutterBluePlus();

  final Guid targetService = Guid("1a691c51-8c3c-4dd9-afcd-527e77c64be7");
  final Guid targetCharacteristic = Guid("f8a4bc7a-ca55-4fa5-92a6-228e0e47b749");

  final scanTimeout = Duration(seconds: 30);
  late BluetoothDevice sensor;

  Future<void> _scanForSensor() {
    return FlutterBluePlus.startScan(withServices: [targetService], timeout: scanTimeout);
  }

  void getDevice() async {
    await _scanForSensor();
    await for (var results in FlutterBluePlus.scanResults) {
      for (ScanResult result in results) {
        sensor = result.device; // Loops should be unneccesary. Maybe find a way to unpack easier
      }
    }
  }
  
  String getAdvName() {
    return sensor.advName;
  }

}