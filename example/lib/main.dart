import 'package:flutter/material.dart';
import 'dart:async';

import 'package:kontakt_beacon/kontakt_beacon.dart';
import 'package:location/location.dart';
import 'package:kontakt_beacon/Helper/beacon.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  @override
  void initState() {
    super.initState();
    _setupLocation();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Beacon beaconI = Beacon('f7826da6bc5b71e0893e', '586f47707a77');
            startBeaconMonitoring(beaconI);
          },
          tooltip: 'Start',
          child: Icon(Icons.add_to_home_screen),
        ),
      ),
    );
  }

  // Helper functions
  void _setupLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }else {
        KontaktBeacon.shared.setupEventListener();
      }
    }else {
      KontaktBeacon.shared.setupEventListener();
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }else {
        KontaktBeacon.shared.setupEventListener();
      }
    }
  }
  
  void startBeaconMonitoring(Beacon beacon) async {
    try {
      dynamic result = await KontaktBeacon.shared.startEddystoneMonitoring(beacon);
      print(result);
    } catch (e){
      print('StartEddystoneMonitoring exception: ${e.toString()}');
    }
  }
}
