//
//  ApplicationStateResult.swift
//  kontakt_beacon
//
//  Created by Vaifat on 6/8/20.
//

import Foundation

class ApplicationStateFlutterResult: SwiftFlutterResult {
    fileprivate var applicationState: UIApplication.State
    
    init(state: UIApplication.State) {
        self.applicationState = state
    }
    
    func result() -> Any {
        switch applicationState {
        case .active:
            return "active"
        case .background:
            return "background"
        case .inactive:
            return "inactive"
        @unknown default:
            return "unknown"
        }
    }
}
