import Flutter
import UIKit

public class SwiftKontaktBeaconPlugin: NSObject, FlutterPlugin{
    fileprivate static var kontaktBeacon: KontaktBeacon!
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        initBeacon(messenger: registrar.messenger())
    }
    
    fileprivate static func initBeacon(messenger: FlutterBinaryMessenger){
        let methodChannelName = "vaifat.planb.kontakt_beacon"
        let eventChannelName = "vaifat.planb.kontakt_beacon/beaconStatus"
        let channelIdentifier = PlatformChannelIdentifier(methodChannelName: methodChannelName, eventChannelName: eventChannelName)
        kontaktBeacon = KontaktBeacon(identifier: channelIdentifier, messenger:  messenger)
    }
}
