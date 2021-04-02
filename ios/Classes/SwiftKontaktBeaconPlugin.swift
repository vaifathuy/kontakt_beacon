import Flutter
import KontaktSDK
import UIKit

public class SwiftKontaktBeaconPlugin: NSObject, FlutterPlugin{
    fileprivate static var channelHandler: SwiftChannelHandler!
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        Kontakt.setAPIKey("hKGjUQlClBcJCYstpaJFeIbENeZSNmxF")
        setupFlutterCommunication(messenger: registrar.messenger())
        setupKontaktBeacon()
    }
    
    fileprivate static func setupFlutterCommunication(messenger: FlutterBinaryMessenger){
        let methodChannelName = "vaifat.planb.kontakt_beacon/methodChannel"
        let eventChannelName = "vaifat.planb.kontakt_beacon/eventChannel"
        let channelIdentifier = PlatformChannelIdentifier(methodChannelName: methodChannelName, eventChannelName: eventChannelName)
        channelHandler = SwiftChannelHandler(identifier: channelIdentifier, messenger: messenger)
        channelHandler.setupOperation()
        
        channelHandler.didSetMethodCallHandler = { (methodChannel, methodCall, result) in
            let methodName = FlutterMethodName(rawValue: methodCall.method) ?? .unknown
            switch methodName {
            case .startMonitoringBeacon:
                guard let arguments = methodCall.arguments as? [String: String] else { return }
                let uniqueID = arguments["uniqueID"]!
                let nameSpaceID = arguments["nameSpaceID"]!
                let instanceID = arguments["instanceID"]!
                let eddyStoneRegion = KontaktEddystoneRegion(uniqueID: uniqueID, namespaceID: nameSpaceID, instanceID: instanceID)
                KontaktBeacon.instance.startMonitoringEddyStone(for: eddyStoneRegion)
                break
            case .stopMonitoringBeacon:
                guard let arguments = methodCall.arguments as? [String: String] else { return }
                let uniqueID = arguments["uniqueID"]!
                let nameSpaceID = arguments["nameSpaceID"]!
                let instanceID = arguments["instanceID"]!
                let eddyStoneRegion = KontaktEddystoneRegion(uniqueID: uniqueID, namespaceID: nameSpaceID, instanceID: instanceID)
                KontaktBeacon.instance.stopMonitoringEddyStone(for: eddyStoneRegion)
            case .stopMonitoringAllEddyStone:
                KontaktBeacon.instance.stopMonitoringAllEddyStone()
            case .restartMonitoringTargetedEddyStones:
                let status = KontaktBeacon.instance.restartMonitoringTargetedEddyStones()
                result(status)
            case .clearAllTargetedEddyStones:
                let status = KontaktBeacon.instance.clearAllTargetedEddyStones()
                result(status)
            case .startScanningBeacon:
                KontaktBeacon.instance.startScanningBeaconDevices()
            case .stopScanningBeacon:
                KontaktBeacon.instance.stopScanningBeaconDevices()
            default: result(FlutterMethodNotImplemented)
            }
        }
    }
    
    fileprivate static func setupKontaktBeacon(){
        // EddyStone Callbacks
        KontaktBeacon.instance.eddyStoneDidDiscover = { (manager, eddyStones, region) in
            if let region = region {
                eddyStones.forEach({
                    let deviceInfo = DeviceInfo()
                    let flutterBeacon = FlutterBeacon(deviceInfo: deviceInfo)
                    if $0.eddystoneUID?.instanceID == region.instanceID {
                        let proximity = FlutterBeaconProximity(rawValue: $0.proximity.rawValue) ?? .unknown
                        deviceInfo.set(distance: $0.accuracy, rssi: $0.rssi.intValue, proximity: proximity.description, timestamp: $0.updatedAt)
                        
                        if let TLM = $0.eddystoneTLM { deviceInfo.set(batteryPower: TLM.batteryVoltage) }
                    }
                    flutterBeacon.set(namespaceID: region.namespaceID, instanceID: region.instanceID, status: BeaconStatus.didDiscover.rawValue, deviceInfo: deviceInfo)
                    let beaconResponse = FlutterBeaconResponse(beacon: flutterBeacon)
                    KontaktBeacon.instance.setCurrentBeaconsStatus(namespaceID: region.namespaceID!, response: beaconResponse)
                })
            }
            channelHandler.sendEventMessage(from: .beaconStatus, message: BeaconFlutterResult(values: KontaktBeacon.instance.getCurrentBeaconsStatus()))
        }
        
        KontaktBeacon.instance.eddyStoneDidUpdate = { (manager, eddystone, frameTypes) in
            let deviceInfo = DeviceInfo()
            let flutterBeacon = FlutterBeacon(deviceInfo: deviceInfo)
            if let eddystoneTLM = eddystone.eddystoneTLM {
                deviceInfo.set(batteryPower: eddystoneTLM.batteryVoltage)
            }
            let proximity = FlutterBeaconProximity(rawValue: eddystone.proximity.rawValue) ?? .unknown
            deviceInfo.set(distance: eddystone.accuracy, rssi: eddystone.rssi.intValue, proximity: proximity.description, timestamp: eddystone.updatedAt)
            flutterBeacon.set(namespaceID: eddystone.eddystoneUID?.namespaceID, instanceID: eddystone.eddystoneUID?.instanceID, status: BeaconStatus.didUpdate.rawValue, deviceInfo: deviceInfo)
            let beaconResponse = FlutterBeaconResponse(beacon: flutterBeacon)
            KontaktBeacon.instance.setCurrentBeaconsStatus(namespaceID: eddystone.eddystoneUID!.namespaceID, response: beaconResponse)
            channelHandler.sendEventMessage(from: .beaconStatus, message: BeaconFlutterResult(values: KontaktBeacon.instance.getCurrentBeaconsStatus()))
        }
        
        KontaktBeacon.instance.eddyStoneDidLost = { (lostDevices) in
            let deviceInfo = DeviceInfo()
            let flutterBeacon = FlutterBeacon(deviceInfo: deviceInfo)
            lostDevices.forEach { (lostEddystone) in
                deviceInfo.set(timestamp: Date().timeIntervalSince1970)
                flutterBeacon.set(namespaceID: lostEddystone.namespaceID, instanceID: lostEddystone.instanceID, uniqueID: lostEddystone.uniqueID, status: BeaconStatus.didExit.rawValue, deviceInfo: deviceInfo)
                let beaconResponse = FlutterBeaconResponse(beacon: flutterBeacon)
                KontaktBeacon.instance.currentBeaconsStatus[lostEddystone.namespaceID!] = beaconResponse
            }
            let response: FlutterBeaconResponseList = KontaktBeacon.instance.currentBeaconsStatus.compactMap({ $0.value })
            channelHandler.sendEventMessage(from: .beaconStatus, message: BeaconFlutterResult(values: response))
        }
        
        KontaktBeacon.instance.deviceManagerDidFailToDiscover = { (manager, error) in }
    }
}
