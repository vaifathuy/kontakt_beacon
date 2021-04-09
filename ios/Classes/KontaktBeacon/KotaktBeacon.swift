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

private let kDeviceFactoryName = "Kontakt"

class KontaktBeacon: NSObject{
    static var instance: KontaktBeacon = KontaktBeacon()
    fileprivate var eddyStoneManager: KTKEddystoneManager!
    fileprivate var deviceManager: KTKDevicesManager!
    fileprivate var beacons = [KontaktEddystoneRegion]()
    fileprivate var lostEddystones: [KontaktEddystoneRegion] = []
    
    // MARK: Properties:
    var targetBeacons: [KontaktEddystoneRegion] {
        return beacons
    }
    var currentBeaconsStatus: [String: FlutterBeaconResponse] = [:]
    
    // MARK: Closures:
    var eddyStoneDidFailToStart: ((_ manager: KTKEddystoneManager, _ error: Error?) -> Void)!
    var eddyStoneDidDiscover: ((_ manager: KTKEddystoneManager, _ eddystones: Set<KTKEddystone>, _ region: KTKEddystoneRegion?) -> Void)!
    var eddyStoneDidUpdate: ((_ manager: KTKEddystoneManager, _ eddystone: KTKEddystone, _ frameType: KTKEddystoneFrameType) -> Void)!
    var eddyStoneDidLost: ((_ eddystones: [KontaktEddystoneRegion]) -> Void)!
    var deviceManagerDidFailToDiscover: ((_ manager: KTKDevicesManager, _ error: Error) -> Void)!
    
    // Constructor
    override init() {
        super.init()
        setupBeaconManager()
    }
    
    fileprivate func setupBeaconManager(){
        deviceManager = KTKDevicesManager(delegate: self)
        eddyStoneManager = KTKEddystoneManager(delegate: self)
        startScanningBeaconDevices()
    }
}

// Helper functions
extension KontaktBeacon {
    /// - Parameter beaconRegion: region to start monitoring
    func startMonitoringEddyStone(for beaconRegion: KontaktEddystoneRegion? = nil){
        eddyStoneManager.startEddystoneDiscovery(in: beaconRegion)
        guard beaconRegion != nil else { return }
        if beacons.first(where: { $0 == beaconRegion! }) == nil {
            beacons.append(beaconRegion!)
            guard let namespaceID = beaconRegion?.namespaceID else { return }
            currentBeaconsStatus[namespaceID] = FlutterBeaconResponse(beacon: .init())
        }
    }
    
    /// - Parameter beaconRegion: region to be removed from beacon monitoring
    func stopMonitoringEddyStone(for beaconRegion: KTKEddystoneRegion) {
        eddyStoneManager.stopEddystoneDiscovery(in: beaconRegion)
    }
    
    func stopMonitoringAllEddyStone() {
        eddyStoneManager.stopEddystoneDiscoveryInAllRegions()
    }
    
    /// - Parameter timeInterval: interval in second to discovery eddystone devices; default value is 3 seconds
    func startScanningBeaconDevices(timeInterval: Double = 3.0){
        deviceManager.discoveryMode = .interval
        deviceManager.startDevicesDiscovery(withInterval: timeInterval)
    }
    
    func stopScanningBeaconDevices(){
        deviceManager.stopDevicesDiscovery()
    }
    
    @discardableResult
    func setCurrentBeaconsStatus(namespaceID: String, response: FlutterBeaconResponse) -> FlutterBeaconResponseList{
        currentBeaconsStatus[namespaceID] = response
        return getCurrentBeaconsStatus()
    }
    
    func getCurrentBeaconsStatus() -> FlutterBeaconResponseList{
        let response: FlutterBeaconResponseList = KontaktBeacon.instance.currentBeaconsStatus.compactMap({ $0.value })
        return response
    }
    
    @discardableResult
    func restartMonitoringTargetedEddyStones() -> Bool {
        if beacons.count > 0 {
            beacons.forEach({ KontaktBeacon.instance.startMonitoringEddyStone(for: $0) })
            return true
        }
        return false
    }
    
    @discardableResult
    func clearAllTargetedEddyStones() -> Bool{
        if beacons.count > 0 {
            beacons.removeAll()
            return true
        }
        return false
    }
}

extension KontaktBeacon: KTKEddystoneManagerDelegate {
    func eddystoneManager(_ manager: KTKEddystoneManager, didDiscover eddystones: Set<KTKEddystone>, in region: KTKEddystoneRegion?) {
        eddyStoneDidDiscover(manager, eddystones, region)
    }
    
    func eddystoneManagerDidFail(toStartDiscovery manager: KTKEddystoneManager, withError error: Error?) {
        eddyStoneDidFailToStart(manager, error)
    }
    
    func eddystoneManager(_ manager: KTKEddystoneManager, didUpdate eddystone: KTKEddystone, with frameType: KTKEddystoneFrameType) {
        eddyStoneDidUpdate(manager, eddystone, frameType)
    }
}

extension KontaktBeacon: KTKDevicesManagerDelegate {
    func devicesManager(_ manager: KTKDevicesManager, didDiscover devices: [KTKNearbyDevice]) {
        
        devices.filter({ $0.name == kDeviceFactoryName }).forEach({
            print("Nearby devices: \($0.uniqueID!)")
        })
        
        targetBeacons.forEach { (eddystone) in
            if devices.filter({ $0.name == kDeviceFactoryName }).contains(where: { $0.uniqueID == eddystone.uniqueID }) {
                if let index = lostEddystones.firstIndex(where: { $0.uniqueID == eddystone.uniqueID }){
                    lostEddystones.remove(at: index)
                }
            }else {
                // lost; currently can't be detected
                if !lostEddystones.contains(eddystone) {
                    lostEddystones.append(eddystone)
                }
            }
        }
        
        guard lostEddystones.count > 0 else { return }
        eddyStoneDidLost(lostEddystones)
    }
    
    func devicesManagerDidFail(toStartDiscovery manager: KTKDevicesManager, withError error: Error) {
        deviceManagerDidFailToDiscover(manager, error)
    }
}
