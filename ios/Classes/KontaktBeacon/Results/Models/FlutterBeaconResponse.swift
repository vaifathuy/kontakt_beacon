//
//  FlutterBeacon.swift
//  kontakt_beacon
//
//  Created by Vaifat on 7/31/20.
//

import Foundation

// MARK: - FlutterBeacon
class FlutterBeaconResponse: Codable {
    var beacon: FlutterBeacon

    init(beacon: FlutterBeacon) {
        self.beacon = beacon
    }
}

// MARK: - Beacon
class FlutterBeacon: Codable {
    var namespaceID, instanceID, uniqueID, status: String?
    var deviceInfo: DeviceInfo?

    enum CodingKeys: String, CodingKey {
        case namespaceID = "namespace_id"
        case instanceID = "instance_id"
        case uniqueID = "unique_id"
        case status
        case deviceInfo = "device_info"
    }

    init(namespaceID: String? = "", instanceID: String? = "", uniqueID: String? = "", status: String? = "", deviceInfo: DeviceInfo? = nil) {
        self.namespaceID = namespaceID
        self.instanceID = instanceID
        self.uniqueID = uniqueID
        self.status = status
        self.deviceInfo = deviceInfo
    }
    
    func set(namespaceID: String? = nil, instanceID: String? = nil, uniqueID: String? = nil, status: String? = nil, deviceInfo: DeviceInfo? = nil) {
        self.namespaceID = namespaceID != nil ? namespaceID : self.namespaceID
        self.instanceID = instanceID != nil ? instanceID : self.instanceID
        self.uniqueID = uniqueID != nil ? uniqueID : self.uniqueID
        self.status = status != nil ? status : self.status
        self.deviceInfo = deviceInfo != nil ? deviceInfo : self.deviceInfo
    }
    
    func clear(){
        namespaceID = ""
        instanceID = ""
        uniqueID = ""
        status = ""
        deviceInfo = nil
    }
}

// MARK: - DeviceInfo
class DeviceInfo: Codable {
    var rssi, txPower: Int?
    var distance, batteryPower: Double?
    var proximity: String?
    var timestamp: Double?

    enum CodingKeys: String, CodingKey {
        case distance
        case batteryPower = "battery_power"
        case rssi, txPower, proximity, timestamp
    }

    init(distance: Double? = 0.0, batteryPower: Double? = 0, rssi: Int? = 0, txPower: Int? = 0, proximity: String? = "", timestamp: Double? = 0) {
        self.distance = distance
        self.batteryPower = batteryPower
        self.rssi = rssi
        self.txPower = txPower
        self.proximity = proximity
        self.timestamp = timestamp
    }
    
    func set(distance: Double? = nil, batteryPower: Double? = nil, rssi: Int? = nil, txPower: Int? = nil, proximity: String? = nil, timestamp: Double? = nil) {
        self.distance = distance != nil ? distance : self.distance
        self.batteryPower = batteryPower != nil ? batteryPower : self.batteryPower
        self.rssi = rssi != nil ? rssi : self.rssi
        self.txPower = txPower != nil ? txPower : self.txPower
        self.proximity = proximity != nil ? proximity : self.proximity
        self.timestamp = timestamp != nil ? timestamp : self.timestamp
    }
    
    func clear(){
        self.distance = 0.0
        self.batteryPower = 0.0
        self.rssi = 0
        self.txPower = 0
        self.proximity = ""
        self.timestamp = 0
    }
}
