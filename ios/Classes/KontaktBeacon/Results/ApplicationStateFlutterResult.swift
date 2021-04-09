//
//  ApplicationStateResult.swift
//  kontakt_beacon
//
//  Created by Vaifat on 6/8/20.
//

import Foundation

class ApplicationStateFlutterResult: SwiftFlutterResult {
    var values: FlutterBeaconResponseList
    fileprivate var applicationState: UIApplication.State

    init(state: UIApplication.State, values: FlutterBeaconResponseList) {
        self.applicationState = state
        self.values = values
    }
}
