//
//  FlutterBeaconProximity.swift
//  kontakt_beacon
//
//  Created by Vaifat on 7/31/20.
//

import Foundation

enum FlutterBeaconProximity: Int {
    case unknown = 0
    case immediate = 1
    case near = 2
    case far = 3
    
    var description: String {
        switch self {
        case .immediate:
            return "IMMEDIATE"
        case .near:
            return "NEAR"
        case .far:
            return "FAR"
        default:
            return "UNKNOWN"
        }
    }
}
