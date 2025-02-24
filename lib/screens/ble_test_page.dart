import 'dart:math';

import 'package:flutter/material.dart';

class BluetoothTestPage extends StatefulWidget {
  const BluetoothTestPage({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() => _BluetoothState();
}

class _BluetoothState extends State<BluetoothTestPage> {
    
  final myController = TextEditingController();

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
                ElevatedButton(onPressed: () {debugPrint(myController.text); }, child: const Text('Send')),
                SizedBox(width: 10),
                ElevatedButton(onPressed: () {debugPrint('right'); }, child: const Text('Receive'))
              ],
            )
          ]
        )
      ),
    );
  }
}