//
//  FlutterMethodName.swift
//  kontakt_beacon
//
//  Created by Vaifat on 6/5/20.
//

import Foundation

enum FlutterMethodName {
    case startMonitoringBeacon
    
    var name: String {
        switch self {
        case .startMonitoringBeacon:
            return "startMonitoringBeacon"
        }
    }
    
    var arguments: String {
        return ""
    }
}
