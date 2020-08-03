//
//  SwiftStreamHandler.swift
//  Runner
//
//  Created by Vaifat on 6/3/20.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import Foundation
import Flutter

final class SwiftStreamHandler: NSObject, FlutterStreamHandler {
    fileprivate var beaconStatusEventSink: FlutterEventSink? = nil
    fileprivate var applicationStateEventSink: FlutterEventSink? = nil
    
    // Flutter StreamHandler methods
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        guard let arguments = arguments as? [String] else { return SwiftFlutterError.FAILED_ARGUMENTS_RETRIEVAL(message: "Failed to retrieve listener's arguments", detail: nil).error }
        var errorKeys: [String] = []
        arguments.forEach({
            let key = StreamName(rawValue: $0)
            switch key {
            case .beaconStatus:
                self.beaconStatusEventSink = events
            case .applicationState:
                self.applicationStateEventSink = events
            default:
                errorKeys.append($0)
            }
        })
        return errorKeys.isEmpty ? nil : SwiftFlutterError.EVENT_LISTEN(message: "Failed to handle event broadcasters of the following keys: \(errorKeys.joined(separator: ","))", detail: nil).error
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        guard let arguments = arguments as? [String] else { return SwiftFlutterError.FAILED_ARGUMENTS_RETRIEVAL(message: "Failed to retrieve listener's arguments", detail: nil).error }
        var errorKeys: [String] = []
        arguments.forEach({
            let key = StreamName(rawValue: $0)
            switch key {
            case .beaconStatus:
                self.beaconStatusEventSink = nil
            case .applicationState:
                self.applicationStateEventSink = nil
            default:
                errorKeys.append($0)
            }
        })
        return errorKeys.isEmpty ? nil : SwiftFlutterError.EVENT_LISTEN(message: "Failed to handle event broadcasters of the following keys: \(errorKeys.joined(separator: ","))", detail: nil).error
    }
    
    /// Broadcast event to Flutter
    func addStream(from streamName: StreamName, stream: SwiftFlutterResult){
        switch streamName {
        case .beaconStatus:
            beaconStatusEventSink!(stream.result())
        case .applicationState:
            applicationStateEventSink!(stream.result())
            break
        }
    }
}
