import 'package:json_annotation/json_annotation.dart';

part 'beacon_signal.g.dart';

@JsonSerializable()
class BeaconResponse {
  List<KontaktBeaconEvent> beaconResponse = List();

  BeaconResponse(this.beaconResponse);
  factory BeaconResponse.fromJson(Map<String, dynamic> json) => _$BeaconResponseFromJson(json);
  Map<String, dynamic> toJson() => _$BeaconResponseToJson(this);

}

@JsonSerializable()
class KontaktBeaconEvent {
  @JsonKey(name: "beacon")
  KontaktBeaconResponse beacon;

  KontaktBeaconEvent(this.beacon);
  factory KontaktBeaconEvent.fromJson(Map<String, dynamic> json) => _$KontaktBeaconEventFromJson(json);
  Map<String, dynamic> toJson() => _$KontaktBeaconEventToJson(this);

}

@JsonSerializable()
class KontaktBeaconResponse {
  @JsonKey(name: "device_info")
  KontaktDeviceInformation deviceInformation;
  @JsonKey(name: "instance_id")
  String instanceId;
  @JsonKey(name: "namespace_id")
  String namespaceId;
  String status;
  @JsonKey(name: "unique_id")
  String uniqueId;

  KontaktBeaconResponse(this.deviceInformation, this.instanceId, this.namespaceId, this.status, this.uniqueId);
  factory KontaktBeaconResponse.fromJson(Map<String, dynamic> json) => _$KontaktBeaconResponseFromJson(json);
  Map<String, dynamic> toJson() => _$KontaktBeaconResponseToJson(this);

}

@JsonSerializable()
class KontaktDeviceInformation {
  @JsonKey(name: "battery_power")
  double batteryPower;
  double distance;
  String proximity;
  int rssi;
  num timestamp;
  int txPower;

  KontaktDeviceInformation(this.batteryPower, this.distance, this.proximity, this.rssi, this.timestamp, this.txPower);
  factory KontaktDeviceInformation.fromJson(Map<String, dynamic> json) => _$KontaktDeviceInformationFromJson(json);
  Map<String, dynamic> toJson() => _$KontaktDeviceInformationToJson(this);
}



