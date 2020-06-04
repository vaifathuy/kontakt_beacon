//
//  KotaktBeacon.swift
//  Runner
//
//  Created by Vaifat on 6/3/20.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import Foundation
import Flutter
import KontaktSDK

class KontaktBeacon: NSObject{
    fileprivate var beaconManager: KTKBeaconManager!
    
    // MARK: Closures:
    var didChangeLocationAuthorizationStatus: ((_ manager: KTKBeaconManager, _ status: CLAuthorizationStatus) -> Void)!
    var didStartMonitoringFor: ((_ manager: KTKBeaconManager, _ region: KTKBeaconRegion) -> Void)!
    var didEnter: ((_ manager: KTKBeaconManager, _ region: KTKBeaconRegion) -> Void)!
    var didExitRegion: ((_ manager: KTKBeaconManager, _ region: KTKBeaconRegion) -> Void)!
    var didDetermineState: ((_ manager: KTKBeaconManager, _ state: CLRegionState, _ region: KTKBeaconRegion) -> Void)!
    var monitoringDidFailFor: ((_ region: KTKBeaconRegion, _ manager: KTKBeaconManager, _ error: Error?) -> Void)!
    var didRangeBeacons: ((_ manager: KTKBeaconManager, _ beacons: [CLBeacon], _ region: KTKBeaconRegion) -> Void)!
    var rangingBeaconsDidFailFor: ((_ region: KTKBeaconRegion, _ manager: KTKBeaconManager, _ error: Error?) -> Void)!
    
    // Constructor
    override init() {
        super.init()
        setupBeaconManager()
    }
    
    fileprivate func setupBeaconManager(){
        beaconManager = KTKBeaconManager(delegate: self)
    }
}

extension KontaktBeacon: KTKBeaconManagerDelegate{
    public func beaconManager(_ manager: KTKBeaconManager, didChangeLocationAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            let leftFrontDoorRegion = KTKBeaconRegion(proximityUUID: UUID(uuidString: BeaconDevices.leftFrontDoor.UUID)!, identifier: BeaconDevices.leftFrontDoor.location)
            startMonitoringBeacon(for: leftFrontDoorRegion)
        }
    }
    
    // MARK: Monitoring beacon ragions
    public func beaconManager(_ manager: KTKBeaconManager, didStartMonitoringFor region: KTKBeaconRegion) {
        print("didStartMonitoring: \(region.identifier)")
    }
    
    public func beaconManager(_ manager: KTKBeaconManager, didEnter region: KTKBeaconRegion) {
        print("didEnter region: \(region.identifier)")
        manager.startRangingBeacons(in: region)
    }
    
    public func beaconManager(_ manager: KTKBeaconManager, didExitRegion region: KTKBeaconRegion) {
        print("didExit region: \(region.identifier)")
        manager.stopRangingBeacons(in: region)
    }
    
    public func beaconManager(_ manager: KTKBeaconManager, didDetermineState state: CLRegionState, for region: KTKBeaconRegion) {
        print("didDetermineState: \(state)")
    }
    
    public func beaconManager(_ manager: KTKBeaconManager, monitoringDidFailFor region: KTKBeaconRegion?, withError error: Error?) {
        print("didMonitoringFail: \(String(describing: error?.localizedDescription))")
    }
    
    // MARK: Ranging
    public func beaconManager(_ manager: KTKBeaconManager, didRangeBeacons beacons: [CLBeacon], in region: KTKBeaconRegion) {
        for beacon in beacons {
            print("Ranged beacon with Proximity UUID: \(beacon.proximityUUID), Major: \(beacon.major) and Minor: \(beacon.minor) from \(region.identifier) in \(translateProximity(proximity: beacon.proximity)) proximity and state: \(beacon.accuracy)")
        }
    }
    
    public func beaconManager(_ manager: KTKBeaconManager, rangingBeaconsDidFailFor region: KTKBeaconRegion?, withError error: Error?) {
        print("rangingBeaconsDidFailFor with error: \(String(describing: error?.localizedDescription))")
    }
}

// Helper functions
extension KontaktBeacon {
    fileprivate func startMonitoringBeacon(for beaconRegion: KTKBeaconRegion){
        if KTKBeaconManager.isMonitoringAvailable() {
            beaconManager.startMonitoring(for: beaconRegion)
        }
    }
    
    fileprivate func translateProximity(proximity: CLProximity) -> String {
        switch proximity {
        case .unknown:
            return "Unknown"
        case .immediate:
            return "Very near"
        case .near:
            return "Near"
        case .far:
            return "Far"
        default:
            return "N/A"
        }
    }
}
