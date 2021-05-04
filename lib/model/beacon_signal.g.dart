// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'beacon_signal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BeaconResponse _$BeaconResponseFromJson(Map<String, dynamic> json) {
  return BeaconResponse(
    (json['beaconResponse'] as List)
        ?.map((e) => e == null
            ? null
            : KontaktBeaconEvent.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$BeaconResponseToJson(BeaconResponse instance) =>
    <String, dynamic>{
      'beaconResponse': instance.beaconResponse,
    };

KontaktBeaconEvent _$KontaktBeaconEventFromJson(Map<String, dynamic> json) {
  return KontaktBeaconEvent(
    json['beacon'] == null
        ? null
        : KontaktBeaconResponse.fromJson(
            json['beacon'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$KontaktBeaconEventToJson(KontaktBeaconEvent instance) =>
    <String, dynamic>{
      'beacon': instance.beacon,
    };

KontaktBeaconResponse _$KontaktBeaconResponseFromJson(
    Map<String, dynamic> json) {
  return KontaktBeaconResponse(
    json['device_info'] == null
        ? null
        : KontaktDeviceInformation.fromJson(
            json['device_info'] as Map<String, dynamic>),
    json['instance_id'] as String,
    json['namespace_id'] as String,
    json['status'] as String,
    json['unique_id'] as String,
  );
}

Map<String, dynamic> _$KontaktBeaconResponseToJson(
        KontaktBeaconResponse instance) =>
    <String, dynamic>{
      'device_info': instance.deviceInformation,
      'instance_id': instance.instanceId,
      'namespace_id': instance.namespaceId,
      'status': instance.status,
      'unique_id': instance.uniqueId,
    };

KontaktDeviceInformation _$KontaktDeviceInformationFromJson(
    Map<String, dynamic> json) {
  return KontaktDeviceInformation(
    (json['battery_power'] as num)?.toDouble(),
    (json['distance'] as num)?.toDouble(),
    json['proximity'] as String,
    json['rssi'] as int,
    json['timestamp'] as num,
    json['txPower'] as int,
  );
}

Map<String, dynamic> _$KontaktDeviceInformationToJson(
        KontaktDeviceInformation instance) =>
    <String, dynamic>{
      'battery_power': instance.batteryPower,
      'distance': instance.distance,
      'proximity': instance.proximity,
      'rssi': instance.rssi,
      'timestamp': instance.timestamp,
      'txPower': instance.txPower,
    };
