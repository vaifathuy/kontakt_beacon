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
                let nameSpaceID = arguments["nameSpaceID"]!
                let instanceID = arguments["instanceID"]!
                let eddyStoneRegion = KTKEddystoneRegion(namespaceID: nameSpaceID, instanceID: instanceID)
                KontaktBeacon.instance.startMonitoringEddyStone(for: eddyStoneRegion)
                break
            case .stopMonitoringBeacon:
                guard let arguments = methodCall.arguments as? [String: String] else { return }
                let nameSpaceID = arguments["nameSpaceID"]!
                let instanceID = arguments["instanceID"]!
                let eddyStoneRegion = KTKEddystoneRegion(namespaceID: nameSpaceID, instanceID: instanceID)
                KontaktBeacon.instance.stopMonitoringEddyStone(for: eddyStoneRegion)
            case .stopMonitoringAllEddyStone:
                KontaktBeacon.instance.stopMonitoringAllEddyStone()
            case .restartMonitoringTargetedEddyStones:
                let status = KontaktBeacon.instance.restartMonitoringTargetedEddyStones()
                result(status)
            case .clearAllTargetedEddyStones:
                let status = KontaktBeacon.instance.clearAllTargetedEddyStones()
                result(status)
            default: result(FlutterMethodNotImplemented)
            }
        }
    }
    
    fileprivate static func setupKontaktBeacon(){
        let deviceInfo = DeviceInfo()
        let flutterBeacon = FlutterBeacon(deviceInfo: deviceInfo)
        
        // EddyStone Callbacks
        KontaktBeacon.instance.eddyStoneDidDiscover = { (manager, eddyStones, region) in
            deviceInfo.clear()
            flutterBeacon.clear()
            if let region = region {
                eddyStones.forEach({
                    if $0.eddystoneUID?.instanceID == region.instanceID {
                        let proximity = FlutterBeaconProximity(rawValue: $0.proximity.rawValue) ?? .unknown
                        deviceInfo.set(distance: $0.accuracy, rssi: $0.rssi.intValue, proximity: proximity.description, timestamp: $0.updatedAt)
                        
                        if let TLM = $0.eddystoneTLM { deviceInfo.set(batteryPower: TLM.batteryVoltage) }
                    }
                    flutterBeacon.set(namespaceID: region.namespaceID, instanceID: region.instanceID, status: BeaconStatus.didDiscover.rawValue, deviceInfo: deviceInfo)
                })
            }
            let beaconResponse = FlutterBeaconResponse(beacon: flutterBeacon)
            channelHandler.sendEventMessage(from: .beaconStatus, message: BeaconFlutterResult(values: beaconResponse))
        }
        
        KontaktBeacon.instance.eddyStoneDidFailToStart = { (manager, error) in
            deviceInfo.clear()
            flutterBeacon.clear()
            flutterBeacon.set(status: BeaconStatus.didFail.rawValue)
            let beaconResponse = FlutterBeaconResponse(beacon: flutterBeacon)
            channelHandler.sendEventMessage(from: .beaconStatus, message: BeaconFlutterResult(values: beaconResponse))
        }
        
        KontaktBeacon.instance.eddyStoneDidUpdate = { (manager, eddystone, frameTypes) in
            deviceInfo.clear()
            flutterBeacon.clear()
            if let eddystoneTLM = eddystone.eddystoneTLM {
                deviceInfo.set(batteryPower: eddystoneTLM.batteryVoltage)
            }
            let proximity = FlutterBeaconProximity(rawValue: eddystone.proximity.rawValue) ?? .unknown
            deviceInfo.set(distance: eddystone.accuracy, rssi: eddystone.rssi.intValue, proximity: proximity.description, timestamp: eddystone.updatedAt)
            flutterBeacon.set(namespaceID: eddystone.eddystoneUID?.namespaceID, instanceID: eddystone.eddystoneUID?.instanceID, status: BeaconStatus.didUpdate.rawValue, deviceInfo: deviceInfo)
            let beaconResponse = FlutterBeaconResponse(beacon: flutterBeacon)
            channelHandler.sendEventMessage(from: .beaconStatus, message: BeaconFlutterResult(values: beaconResponse))
        }
    }
}
