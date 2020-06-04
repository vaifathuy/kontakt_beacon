import Flutter
import KontaktSDK
import UIKit

public class SwiftKontaktBeaconPlugin: NSObject, FlutterPlugin{
    fileprivate static var kontaktBeacon: KontaktBeacon!
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        Kontakt.setAPIKey("hKGjUQlClBcJCYstpaJFeIbENeZSNmxF")
        setupFlutterCommunication(messenger: registrar.messenger())
    }
    
    fileprivate static func setupFlutterCommunication(messenger: FlutterBinaryMessenger){
        let methodChannelName = "vaifat.planb.kontakt_beacon"
        let eventChannelName = "vaifat.planb.kontakt_beacon/beaconStatus"
        let channelIdentifier = PlatformChannelIdentifier(methodChannelName: methodChannelName, eventChannelName: eventChannelName)
        let channelHandler = SwiftChannelHandler(identifier: channelIdentifier, messenger: messenger)
        channelHandler.setupOperation()
    }
    
    fileprivate static func setupKontaktBeacon(){
        kontaktBeacon = KontaktBeacon()
    }
}
