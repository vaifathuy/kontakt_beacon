import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kontakt_beacon/Helper/beacon.dart';
import 'package:kontakt_beacon/kontakt_beacon.dart';
import 'package:kontakt_beacon/model/beacon_signal.dart';
import 'package:kontakt_beacon_example/beacon_signal.dart';
import 'package:kontakt_beacon_example/second_screen.dart';
import 'package:location/location.dart';
import 'package:rxdart/rxdart.dart';

final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject = BehaviorSubject<ReceivedNotification>();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
final BehaviorSubject<String> selectNotificationSubject = BehaviorSubject<String>();
NotificationAppLaunchDetails notificationAppLaunchDetails;

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');

  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {
        didReceiveLocalNotificationSubject.add(ReceivedNotification(
            id: id, title: title, body: body, payload: payload));
      });
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
        if (payload != null) {
          debugPrint('notification payload: ' + payload);
        }
        selectNotificationSubject.add(payload);
      });
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  String info = '';
  String version = "";

  List<KontaktBeaconEvent> beaconList = List();
  StreamController<String> streamController = StreamController.broadcast();


  @override
  void initState() {
    super.initState();
    _setupLocation();
    setupEventListener();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _requestIOSPermissions();
      _configureDidReceiveLocalNotificationSubject();
      _configureSelectNotificationSubject(context);
    });
  }

  void _requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body)
              : null,
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Ok'),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SecondScreen(receivedNotification.payload),
                  ),
                );
              },
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject(BuildContext context) {
    selectNotificationSubject.stream.listen((String payload) async {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SecondScreen(payload)),
      );
    });
  }

  Future<void> _showNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        0, 'Beacon Detected', '${DateTime.now()}', platformChannelSpecifics,
        payload: 'item x');
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: <Widget>[
            Text("data"),
            StreamBuilder<String>(
              stream: streamController.stream,
              builder: (context, snapshot) {
                return Center(
                  child: Text(snapshot.data != null ? snapshot.data : ''),
                );
              }
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    streamController.close();
  }

  // Helper functions
  void _setupLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      } else {
        KontaktBeacon.shared.setupEventListener();
        setupBeacon();
      }
    } else {
      KontaktBeacon.shared.setupEventListener();
      setupBeacon();
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.DENIED) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.GRANTED) {
        return;
      } else {
        KontaktBeacon.shared.setupEventListener();
        setupBeacon();
      }
    }
  }

  void setupEventListener(){

    KontaktBeacon.shared.testEvent.stream.listen((event) {
      beaconList.clear();
      List<dynamic> json = jsonDecode(event.toString()) ;
      json.forEach((element) {
        KontaktBeaconEvent beacon = KontaktBeaconEvent.fromJson(element);
        beaconList.add(beacon);
      });
      if(beaconList.where((element) =>( element.beacon.status == "didEnter" ||  element.beacon.status == "didMonitor")).length > 0) {
        streamController.add("Detecting signal.....");
      } else {
        streamController.add("Losing signal.....");
      }
    });
  }

  void startBeaconMonitoring(Beacon beacon) async {
    try {
      await KontaktBeacon.shared.startEddystoneMonitoring(beacon);
    } catch (e) {
      print('StartEddystoneMonitoring exception: ${e.toString()}');
    }
  }

  void setupBeacon() async{
    if(Platform.isAndroid) {
      await KontaktBeacon.shared.scanning();
    }
    Beacon beaconI = Beacon('fdu1', 'f7826da6bc5b71e0893e', '6b4761767466');
    Beacon beaconII = Beacon('JpWD', 'f7826da6bc5b71e0893e', '566761644865');
    Beacon beaconIII = Beacon('hFHH', 'f7826da6bc5b71e0893e', '586f47707a77');

    // startBeaconMonitoring(beaconI);
    startBeaconMonitoring(beaconIII);
  }
}