import 'package:childsafeapp/services/ble_service.dart';
import 'package:flutter/material.dart';

class BluetoothTestPage extends StatefulWidget {
  const BluetoothTestPage({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() => _BluetoothState();
}

class _BluetoothState extends State<BluetoothTestPage> {
    
  final myController = TextEditingController();
  final bluetoothService = BleService();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(child:
        Column(
          children: [
            Row(
              children: [
                Expanded(child:
                  TextField(
                    controller: myController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Write Value',
                    ),
                  )
                ),
                SizedBox(width: 10),
                Expanded(child:
                  TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Read Value',
                    ),
                  )
                ),
                SizedBox(width: 10),
                Expanded(child:
                  TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Notify Value',
                    ),
                  )
                )
              ],
            ),
            Row(
              children: [
                ElevatedButton(onPressed: bluetoothService.connectToSensorStream, child: const Text('Connect')),
                SizedBox(width: 10),
                ElevatedButton(onPressed: () {
                    List<int> data = bluetoothService.testOutput();
                    debugPrint("Count: $data[0] => Value: $data[1]");
                  }, child: const Text('Print'))
              ],
            )
          ]
        )
      ),
    );
  }
}