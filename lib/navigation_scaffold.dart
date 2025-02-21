import 'package:childsafeapp/screens/ble_test_page.dart';
import 'package:childsafeapp/screens/home_page.dart';
import 'package:flutter/material.dart';

class NavigationScaffold extends StatefulWidget{
  const NavigationScaffold({super.key});

  @override
  State<StatefulWidget> createState() => NavigationState();
}

class NavigationState extends State<NavigationScaffold> {

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.bluetooth),
            label: 'Bluetooth',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.notifications),
            icon: Badge(child: Icon(Icons.notifications_outlined)),
            label: 'Notifications',
          ),
        ],
      ),
      body:
          <Widget>[
            /// Home page
            MyHomePage(title: 'Test'),
            BluetoothTestPage(title: 'Bluetooth'),
            MyHomePage(title: 'Placeholder'),
          ][currentPageIndex],
    );
  }
}