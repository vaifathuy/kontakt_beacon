//
//  ApplicationStateResult.swift
//  kontakt_beacon
//
//  Created by Vaifat on 6/8/20.
//

import Foundation

class ApplicationStateFlutterResult: SwiftFlutterResult {
    var values: FlutterBeaconResponse
    fileprivate var applicationState: UIApplication.State

    init(state: UIApplication.State, values: FlutterBeaconResponse) {
        self.applicationState = state
        self.values = values
    }
}
