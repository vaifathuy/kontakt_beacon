import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:kontakt_beacon/Helper/beacon.dart';
import 'package:kontakt_beacon/Helper/platform_method_name.dart';

class KontaktBeacon {

  Timer shouldRefreshKontaktTimer;
  static KontaktBeacon shared = KontaktBeacon();
  MethodChannel _channel = MethodChannel('vaifat.planb.kontakt_beacon/methodChannel');
  EventChannel _eventChannel = EventChannel('vaifat.planb.kontakt_beacon/eventChannel');
  StreamController<String> testEvent = StreamController.broadcast();

  void setupEventListener() {

    try {
      _eventChannel.receiveBroadcastStream(['beaconStatus', 'applicationState']).listen((dynamic event) {
        testEvent.add(event.toString());
      }, onError: (dynamic error) {
        // testEvent.add(error.message);
        print("error $error");
      }, onDone: () {
        // testEvent.add('onDone');
        print("on done");
      });
    } on PlatformException catch (e) {
      throw FlutterError(e.message);
    } catch(e) {

    }
  }

  Future<void> scanning() async{
    await invokeMethod(PlatformMethodName.startScanningBeacon);
  }

  Future<void> stopScanning() async{
    await invokeMethod(PlatformMethodName.stopScanningBeacon);
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
      'uniqueID': beacon.uniqueID,
      'nameSpaceID': beacon.nameSpaceID,
      'instanceID': beacon.instanceID
    });
  }

  Future<dynamic> startEddystoneMonitoring(Beacon beacon) async {
    return await invokeMethod(PlatformMethodName.startMonitoringBeacon, <String, String>{
      'uniqueID': beacon.uniqueID,
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

  List<BeaconResponse> beaconResponseFromJson(String str) => List<BeaconResponse>.from(json.decode(str).map((x) => BeaconResponse.fromJson(x)));
  String beaconResponseToJson(List<BeaconResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

}

class BeaconResponse {
  BeaconEvent beaconEvent;
  BeaconResponse({
    this.beaconEvent
  });

  factory BeaconResponse.fromJson(Map<String, dynamic> json) => BeaconResponse(
    beaconEvent: BeaconEvent.fromJson(json["beacon"]),
  );

  Map<String, dynamic> toJson() => {
    "beacon": beaconEvent.toJson(),
  };
}

class BeaconEvent {
  BeaconEvent({
    this.deviceInfo,
    this.instanceId,
    this.namespaceId,
    this.status,
    this.uniqueId,
  });

  DeviceInfo deviceInfo;
  String instanceId;
  String namespaceId;
  String status;
  String uniqueId;

  factory BeaconEvent.fromJson(Map<String, dynamic> json) => BeaconEvent(
    deviceInfo: DeviceInfo.fromJson(json["device_info"]),
    instanceId: json["instance_id"],
    namespaceId: json["namespace_id"],
    status: json["status"],
    uniqueId: json["unique_id"],
  );

  Map<String, dynamic> toJson() => {
    "device_info": deviceInfo.toJson(),
    "instance_id": instanceId,
    "namespace_id": namespaceId,
    "status": status,
    "unique_id": uniqueId,
  };
}

class DeviceInfo {
  DeviceInfo({
    // this.batteryPower,
    this.distance,
    this.proximity,
    this.rssi,
    this.timestamp,
    this.txPower,
  });

  // dynamic batteryPower;
  dynamic distance;
  dynamic proximity;
  dynamic rssi;
  dynamic timestamp;
  dynamic txPower;

  factory DeviceInfo.fromJson(Map<String, dynamic> json) => DeviceInfo(
    // batteryPower: json["battery_power"],
    distance: json["distance"].toDouble(),
    proximity: json["proximity"],
    rssi: json["rssi"],
    timestamp: json["timestamp"],
    txPower: json["txPower"],
  );

  Map<String, dynamic> toJson() => {
    // "battery_power": batteryPower,
    "distance": distance,
    "proximity": proximity,
    "rssi": rssi,
    "timestamp": timestamp,
    "txPower": txPower,
  };
}
