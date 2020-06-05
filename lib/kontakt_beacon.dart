import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:kontakt_beacon/beacon.dart';
import 'package:kontakt_beacon/platform_method_name.dart';

class KontaktBeacon {
  static KontaktBeacon shared = KontaktBeacon();
  MethodChannel _channel = MethodChannel('vaifat.planb.kontakt_beacon');
  EventChannel _eventChannel = EventChannel('vaifat.planb.kontakt_beacon/beaconStatus');

  // MARK: Setup StreamListener from native platform's event
  void setupEventListener() {
     _eventChannel.receiveBroadcastStream().listen((dynamic event) {
      print('Received event: $event');
    }, onError: (dynamic error) {
      print('Received error: ${error.message}');
    }, onDone: () {
      print('onDone');
    });
  }

  Future<Map> startEddystoneMonitoring(Beacon beacon) async {
    String methodName = describeEnum((PlatformMethodName.startMonitoringBeacon));
    try {
      Map beaconRegion = await _channel.invokeMethod(methodName, <String, String> {
        'nameSpaceID': beacon.nameSpaceID,
        'instanceID' : beacon.instanceID
      });
      return beaconRegion;
    } on PlatformException catch (e) {
      throw FlutterError(e.message);
    } on MissingPluginException {
      throw FlutterError('$methodName throws MissingPluginException');
    }
  }
}
