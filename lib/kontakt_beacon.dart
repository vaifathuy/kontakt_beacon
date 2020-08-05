import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:kontakt_beacon/Helper/beacon.dart';
import 'package:kontakt_beacon/Helper/platform_method_name.dart';

class KontaktBeacon {
  static KontaktBeacon shared = KontaktBeacon();
  MethodChannel _channel = MethodChannel('vaifat.planb.kontakt_beacon/methodChannel');
  EventChannel _eventChannel = EventChannel('vaifat.planb.kontakt_beacon/eventChannel');
  StreamController<String> testEvent = StreamController.broadcast();

  // MARK: Setup StreamListener from native platform's event
  void setupEventListener() {
    try {
      _eventChannel
          .receiveBroadcastStream(['beaconStatus', 'applicationState']).listen((dynamic event) {
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

  Future<void> scanning() async{
    await invokeMethod(PlatformMethodName.startScanningBeacon);
  }
  Future<void> clearAllTargetedEddyStones() async {
    invokeMethod(PlatformMethodName.clearAllTargetedEddyStones);
  }

  Future<void> restartMonitoringTargetedEddyStones() async {
    await invokeMethod(PlatformMethodName.restartMonitoringTargetedEddyStones);
  }

  Future<void> stopMonitoringAllEddyStone() async {
    invokeMethod(PlatformMethodName.stopMonitoringAllEddyStone);
  }

  Future<void> stopEddystoneMonitoring(Beacon beacon) async {
    await invokeMethod(PlatformMethodName.stopMonitoringBeacon, <String, String>{
      'nameSpaceID': beacon.nameSpaceID,
      'instanceID': beacon.instanceID
    });
  }

  Future<Map> startEddystoneMonitoring(Beacon beacon) async {
    return await invokeMethod(PlatformMethodName.startMonitoringBeacon, <String, String>{
      'nameSpaceID': beacon.nameSpaceID,
      'instanceID': beacon.instanceID
    });
  }

  Future<dynamic> invokeMethod(PlatformMethodName method, [dynamic arguments]) async {
    String methodName = describeEnum((method));
    try {
      return await _channel.invokeMethod(methodName, arguments);
    } on PlatformException catch (e) {
      throw FlutterError(e.message);
    } on MissingPluginException {
      throw FlutterError('$methodName throws MissingPluginException');
    }
  }

  Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
