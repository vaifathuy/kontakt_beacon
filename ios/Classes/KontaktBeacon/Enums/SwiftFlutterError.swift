//
//  SwiftFlutterError.swift
//  kontakt_beacon
//
//  Created by Vaifat on 6/8/20.
//

import Foundation
import Flutter

enum SwiftFlutterError {
    case EVENT_LISTEN(message: String, detail: Any?)
    case METHOD_CHANNEL(message: String, detail: Any?)
    case FAILED_ARGUMENTS_RETRIEVAL(message: String, detail: Any?)
    case BLUETOOTH(message: String, detail: Any?)
    
    var code: String {
        let baseIdentifier = "FLUTTER"
        switch self {
        case .EVENT_LISTEN:
            return "\(baseIdentifier)-EVENT-LISTEN"
        case .METHOD_CHANNEL:
            return "\(baseIdentifier)-METHOD-CHANNEL"
        case .FAILED_ARGUMENTS_RETRIEVAL:
            return "\(baseIdentifier)-FAILED-ARGUMENTS-RETRIEVAL"
        case .BLUETOOTH:
            return "\(baseIdentifier)-BLUETOOTH"
        }
    }
    
    var error: FlutterError {
        switch self {
        case .EVENT_LISTEN(let message, let detail):
            return FlutterError(code: code, message: "\(code): \(message)", details: "\(code): \(detail ?? "No detail info")")
        case .METHOD_CHANNEL(let message, let detail):
            return FlutterError(code: code, message: "\(code): \(message)", details: "\(code): \(detail ?? "No detail info")")
        case .FAILED_ARGUMENTS_RETRIEVAL(let message, let detail):
            return FlutterError(code: code, message: "\(code): \(message)", details: "\(code): \(detail ?? "No detail info")")
        case .BLUETOOTH(let message, let detail):
            return FlutterError(code: code, message: "\(code): \(message)", details: "\(code): \(detail ?? "No detail info")")
        }
    }
    
}
