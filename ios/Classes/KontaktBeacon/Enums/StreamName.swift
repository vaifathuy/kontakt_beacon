//
//  StreamName.swift
//  kontakt_beacon
//
//  Created by Vaifat on 6/8/20.
//

import Foundation

enum StreamName: String{
    case beaconStatus
    case applicationState
    
    var key: String {
        switch self {
        case .beaconStatus:
            return "beaconStatus"
        case .applicationState:
            return "applicationState"
        }
    }
}
