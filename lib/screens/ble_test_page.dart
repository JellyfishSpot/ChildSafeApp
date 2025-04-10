import 'package:childsafeapp/services/ble_service.dart';
import 'package:flutter/material.dart';
import 'dart:async';  // Import for Timer


class BluetoothTestPage extends StatefulWidget {
  const BluetoothTestPage({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() => _BluetoothState();
}

class _BluetoothState extends State<BluetoothTestPage> {
    
  final myController = TextEditingController();
  final bluetoothService = BleService();
   bool isActive = false;
   Timer? _timer;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    _timer?.cancel();
    super.dispose();
  }


// Start/stop sending notifications every 10 seconds
  void toggleNotifications() {
    setState(() {
      isActive = !isActive;
    });

    if (isActive) {
      // Start sending notifications every 10 seconds
      _timer = Timer.periodic(Duration(seconds: 10), (timer) {
        print("hi");
      });
    } else {
      // Stop the timer when the button is pressed again
      _timer?.cancel();
    }
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
                      hintText: 'Retry Discovery',
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
                    bluetoothService.startForegroundService();
                  }, child: const Text('Retry Services')),
                ElevatedButton(onPressed: toggleNotifications,  // Toggle the notifications
                  child: Text(isActive ? 'Stop Notifications' : 'Notify'),),
                SizedBox(width: 10),
               
  ],
)
      
          ]
        )
      ),
    );
  }
}
