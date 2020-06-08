//
//  BeaconFlutterResult.swift
//  kontakt_beacon
//
//  Created by Vaifat on 6/8/20.
//

import Foundation

class BeaconFlutterResult: SwiftFlutterResult {
    fileprivate var beaconStatus: BeaconStatus = .unknown
    fileprivate var values: [String : String]
    
    init(beaconStatus: BeaconStatus = .unknown, values: [String: String]) {
        self.beaconStatus = beaconStatus
        self.values = values
    }
    func result() -> Any { return [beaconStatus.rawValue: values] }
}
