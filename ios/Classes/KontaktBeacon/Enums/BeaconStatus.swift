//
//  BeaconStatus.swift
//  kontakt_beacon
//
//  Created by Vaifat on 6/8/20.
//

import Foundation

enum BeaconStatus: String{
    case didDiscover = "didMonitor"
    case didFail = "didFailMonitoring"
    case didUpdate = "didEnter"
    case unknown
    
    var description: String {
        switch self {
        case .didDiscover:
            return ""
        default: return "Unknown"
        }
    }
}
