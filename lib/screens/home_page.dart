import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Hardcoded status variables – replace these with real device input later
  bool isCarParked = false;
  bool isChildPresent = true;
  // This logic should be replaced with real-time data from the BLE service
  late bool isAtRisk;
  @override
  void initState() {
    super.initState();
    isAtRisk = isCarParked && isChildPresent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 188, 117, 63),
        title: Text("ChildSafe"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Currently:",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              isAtRisk ? "RISK" : "NO RISK",
              style: TextStyle(
                color: isAtRisk ? Colors.red : Colors.green,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            Text(
              "Car Status:",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              isCarParked ? "Parked" : "Not Parked",
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Text(
              "Child Detection Status:",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              isChildPresent ? "Child Present" : "No Child Detected",
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
