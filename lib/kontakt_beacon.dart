import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:kontakt_beacon/Helper/beacon.dart';
import 'package:kontakt_beacon/Helper/platform_method_name.dart';

class KontaktBeacon {
  static KontaktBeacon shared = KontaktBeacon();
  MethodChannel _channel = MethodChannel('vaifat.planb.kontakt_beacon/methodChannel');
  EventChannel _eventChannel = EventChannel('vaifat.planb.kontakt_beacon/eventChannel');
  StreamController<String> testEvent = StreamController();

  // MARK: Setup StreamListener from native platform's event
  void setupEventListener() {
    try {
      _eventChannel.receiveBroadcastStream(
          ['beaconStatus', 'applicationState']
      ).listen((dynamic event) {
        testEvent.add(event.toString());
      }, onError: (dynamic error) {
        testEvent.add(error.message);
      }, onDone: () {
        testEvent.add('onDone');
      });
    } on PlatformException catch (e) {
      throw FlutterError(e.message);
    }
  }

  Future<void> startScanning() async {
    var methodName = "startScanningBeacon";
    try {
      await _channel.invokeMethod(methodName);
    } on PlatformException catch (e) {
      throw FlutterError(e.message);
    } on MissingPluginException {
      throw FlutterError('$methodName throws MissingPluginException');
    }
  }
  Future<void> stopScaning() async{
    var methodName = "stopScanningBeacon";
    try {
      await _channel.invokeMethod(methodName);
    } on PlatformException catch (e) {
      throw FlutterError(e.message);
    } on MissingPluginException {
      throw FlutterError('$methodName throws MissingPluginException');
    }
  }

  Future<void> startEddystone() async {
    String methodName = describeEnum((PlatformMethodName.startMonitoringBeacon));
    try {
      Map beaconRegion = await _channel.invokeMethod(methodName);
      return beaconRegion;
    } on PlatformException catch (e) {
      throw FlutterError(e.message);
    } on MissingPluginException {
      throw FlutterError('$methodName throws MissingPluginException');
    }
  }

  Future<Map> startEddystoneMonitoring(Beacon beacon) async {
    String methodName = describeEnum((PlatformMethodName.startMonitoringBeacon));
    try {
      Map beaconRegion = await _channel.invokeMethod(
          methodName, <String, String>{
        'nameSpaceID': beacon.nameSpaceID,
        'instanceID': beacon.instanceID
      });
      return beaconRegion;
    } on PlatformException catch (e) {
      throw FlutterError(e.message);
    } on MissingPluginException {
      throw FlutterError('$methodName throws MissingPluginException');
    }
  }

}