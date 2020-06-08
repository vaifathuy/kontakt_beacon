import Flutter
import KontaktSDK
import UIKit

public class SwiftKontaktBeaconPlugin: NSObject, FlutterPlugin{
    fileprivate static var channelHandler: SwiftChannelHandler!
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        Kontakt.setAPIKey("hKGjUQlClBcJCYstpaJFeIbENeZSNmxF")
        setupFlutterCommunication(messenger: registrar.messenger())
        setupKontaktBeacon()
        setupNotificationObservers()
    }
    
    @objc private static func applicationStateInBackground(_ notification: Notification){
        KontaktBeacon.instance.restartMonitoringTargetedEddyStones()
        channelHandler.sendEventMessage(from: .applicationState, message: ApplicationStateFlutterResult(state: .background))
    }
    
    @objc private static func applicationStateInForeground(_ notification: Notification){
        channelHandler.sendEventMessage(from: .applicationState, message: ApplicationStateFlutterResult(state: .active))
    }
    
    fileprivate static func setupNotificationObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(applicationStateInBackground(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationStateInForeground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    fileprivate static func setupFlutterCommunication(messenger: FlutterBinaryMessenger){
        let methodChannelName = "vaifat.planb.kontakt_beacon/methodChannel"
        let eventChannelName = "vaifat.planb.kontakt_beacon/eventChannel"
        let channelIdentifier = PlatformChannelIdentifier(methodChannelName: methodChannelName, eventChannelName: eventChannelName)
        channelHandler = SwiftChannelHandler(identifier: channelIdentifier, messenger: messenger)
        channelHandler.setupOperation()
        
        channelHandler.didSetMethodCallHandler = { (methodChannel, methodCall, result) in
            switch methodCall.method {
            case FlutterMethodName.startMonitoringBeacon.name:
                // Return either a Dictionary<String, String?> or FlutterError
                guard let arguments = methodCall.arguments as? [String: String] else { return }
                let nameSpaceID = arguments["nameSpaceID"]!
                let instanceID = arguments["instanceID"]!
                let eddyStoneRegion = KTKEddystoneRegion(namespaceID: nameSpaceID, instanceID: instanceID)
                let bluetoothStatus = KontaktBeacon.instance.checkBluetoothStatus()
                if bluetoothStatus != .poweredOff || bluetoothStatus != .unauthorized {
                    KontaktBeacon.instance.startMonitoringEddyStone(for: eddyStoneRegion)
                    result(BeaconFlutterResult(values: ["nameSpaceID" : eddyStoneRegion.namespaceID!, "instanceID" : eddyStoneRegion.instanceID!]).result())
                }else {
                    result(SwiftFlutterError.BLUETOOTH(message: "Bluetooth is off. Please turn it off!", detail: nil).error)
                }
                break
            default: result(FlutterMethodNotImplemented)
            }
        }
    }
    
    fileprivate static func setupKontaktBeacon(){
        // EddyStone Callbacks
        KontaktBeacon.instance.eddyStoneDidDiscover = { (manager, eddyStones, region) in
            channelHandler.sendEventMessage(from: .beaconStatus, message: BeaconFlutterResult(beaconStatus: .didDiscover, values: ["info": "eddyStoneDidDiscover: \(eddyStones), \(region!)"]))
        }
        
        KontaktBeacon.instance.eddyStoneDidFailToStart = { (manager, error) in
            channelHandler.sendEventMessage(from: .beaconStatus, message: BeaconFlutterResult(beaconStatus: .didFail, values: ["info": "eddyStoneDidFailToStart: \(error!.localizedDescription)"]))
        }
        
        KontaktBeacon.instance.eddyStoneDidUpdate = { (manager, eddystones, frameTypes) in
            channelHandler.sendEventMessage(from: .beaconStatus, message: BeaconFlutterResult(beaconStatus: .didUpdate, values: ["info": "eddyStoneDidUpdate: \(eddystones), \(frameTypes)"]))
        }
    }
}
