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
        let methodChannelName = "vaifat.planb.kontakt_beacon"
        let eventChannelName = "vaifat.planb.kontakt_beacon/beaconStatus"
        let channelIdentifier = PlatformChannelIdentifier(methodChannelName: methodChannelName, eventChannelName: eventChannelName)
        channelHandler = SwiftChannelHandler(identifier: channelIdentifier, messenger: messenger)
        channelHandler.setupOperation()
        
        channelHandler.didSetMethodCallHandler = { (methodChannel, methodCall, result) in
            switch methodCall.method {
            case FlutterMethodName.startMonitoringBeacon.name:
                // Return either a Dictionary<String, String?> or FlutterError
                guard let arguments = methodCall.arguments as? [String: String] else { return }
                let nameSpaceID = arguments["nameSpaceID"] ?? "f7826da6bc5b71e0893e"
                let instanceID = arguments["instanceID"] ?? "586f47707a77"
                let eddyStoneRegion = KTKEddystoneRegion(namespaceID: nameSpaceID, instanceID: instanceID)
                let bluetoothStatus = KontaktBeacon.instance.checkBluetoothStatus()
                if bluetoothStatus != .poweredOff || bluetoothStatus != .unauthorized {
                    KontaktBeacon.instance.startMonitoringEddyStone(for: eddyStoneRegion)
                    result(["nameSpaceID" : eddyStoneRegion.namespaceID, "instanceID" : eddyStoneRegion.instanceID])
                }else {
                    result(FlutterError(code: "KTKERROR-BLE", message: "Bluetooth is off. Please turn it off!", details: nil))
                }
                break
            default: result(FlutterMethodNotImplemented)
            }
        }
    }
    
    fileprivate static func setupKontaktBeacon(){
//        let eddyStoneRegion = KTKEddystoneRegion(namespaceID: "f7826da6bc5b71e0893e", instanceID: "586f47707a77")
//        KontaktBeacon.instance.startMonitoringEddyStone(for: eddyStoneRegion)
        
        // EddyStone Callbacks
        KontaktBeacon.instance.eddyStoneDidDiscover = { (manager, eddyStones, region) in
            channelHandler.sendEventMessage(message: "eddyStoneDidDiscover: \(eddyStones), \(region!)")
        }
        
        KontaktBeacon.instance.eddyStoneDidFailToStart = { (manager, error) in
            channelHandler.sendEventMessage(message: "eddyStoneDidFailToStart: \(error!.localizedDescription)")
        }
        
        KontaktBeacon.instance.eddyStoneDidUpdate = { (manager, eddystones, frameTypes) in
            channelHandler.sendEventMessage(message: "eddyStoneDidUpdate: \(eddystones), \(frameTypes)")
        }
    }
}
