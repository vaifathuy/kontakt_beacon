import 'dart:async';

import 'package:flutter/services.dart';

class KontaktBeacon {
  static KontaktBeacon shared = KontaktBeacon();
  MethodChannel _channel = MethodChannel('vaifat.planb.kontakt_beacon');
  EventChannel _eventChannel = EventChannel('vaifat.planb.kontakt_beacon/beaconStatus');

  Future<void> runMethodTest() async {
    String methodName = 'methodTest';
    try {
      String result = await _channel.invokeMethod(methodName);
      print("$result");
    } on PlatformException catch (e) {
      print(e);
    } on MissingPluginException {
      print('$methodName throws MissingPluginException');
    }
  }

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
}
