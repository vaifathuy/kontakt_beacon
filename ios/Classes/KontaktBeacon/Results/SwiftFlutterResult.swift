//
//  SwiftFlutterResult.swift
//  kontakt_beacon
//
//  Created by Vaifat on 6/8/20.
//

import Foundation

typealias SwiftFlutterJSON = String?

protocol SwiftFlutterResult {
    var values: FlutterBeaconResponseList { get set }
    func result() -> SwiftFlutterJSON
}

extension SwiftFlutterResult {
    func result() -> SwiftFlutterJSON {
        return ""
    }
    
}
