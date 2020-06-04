//
//  BeaconDevices.swift
//  kontakt_beacon
//
//  Created by Vaifat on 6/4/20.
//

import Foundation

enum BeaconDevices: CaseIterable {
    case leftFrontDoor
    case rightFrontDoor
    case centerFrontDoor
    
    var UUID: String {
        switch self {
        case .leftFrontDoor:
            return "f7826da6-4fa2-4e98-8024-bc5b71e0893e"
        case .rightFrontDoor:
            return "f7826da6-4fa2-4e98-8024-bc5b71e0893e"
        case .centerFrontDoor:
            return "f7826da6-4fa2-4e98-8024-bc5b71e0893e"
        }
    }
    
    var location: String {
        switch self {
        case .leftFrontDoor:
            return "Left Front Door"
        case .rightFrontDoor:
            return "Right Front Door"
        case .centerFrontDoor:
            return "Center Front Door"
        }
    }
}
