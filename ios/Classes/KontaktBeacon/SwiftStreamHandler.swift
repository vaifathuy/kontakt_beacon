//
//  SwiftStreamHandler.swift
//  Runner
//
//  Created by Vaifat on 6/3/20.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import Foundation
import Flutter

class SwiftStreamHandler: NSObject, FlutterStreamHandler {
    var eventSink: FlutterEventSink? = nil
    
    // Flutter StreamHandler methods
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        //Start beacon operation
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
    
    /// Broadcast event to Flutter
    func addStream(stream: Any){
        guard eventSink != nil else { return }
        eventSink!(stream)
    }
}
