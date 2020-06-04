//
//  KotaktBeacon.swift
//  Runner
//
//  Created by Vaifat on 6/3/20.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import Foundation
import Flutter

class KontaktBeacon{
    fileprivate var channelIdentifer: PlatformChannelIdentifier!
    fileprivate var methodChannel: FlutterMethodChannel!
    fileprivate var eventChannel: FlutterEventChannel?
    
    fileprivate var swiftStreamHandler = SwiftStreamHandler()
    fileprivate var swiftChannelHandler: SwiftChannelHandler!
    
    // Constructor
    init(identifier: PlatformChannelIdentifier, messenger: FlutterBinaryMessenger) {
        self.channelIdentifer = identifier
        
        
        setupCommunicationChannels(messenger: messenger)
    }
    
    fileprivate func setupCommunicationChannels(messenger: FlutterBinaryMessenger){
        
        methodChannel = FlutterMethodChannel(name: channelIdentifer.methodChannelName, binaryMessenger: messenger)
        setupMethodHandler()
        
        if channelIdentifer.isEventChannelAvailable() {
            eventChannel = FlutterEventChannel(name: channelIdentifer.eventChannelName!, binaryMessenger: messenger)
            eventChannel?.setStreamHandler(swiftStreamHandler)
        }
        
        self.scheduleNotification()
    }
    
    fileprivate func setupMethodHandler(){
        let methodName = "methodTest"
        // MARK: Methods Handler
        methodChannel.setMethodCallHandler { (call, result) in
            switch call.method {
            case methodName:
                result("From iOS")
            default: result(FlutterMethodNotImplemented)
            }
        }
    }
    
    // Helper
    func sendEventMessage(message: Any) {
        swiftStreamHandler.addStream(stream: message)
    }
    
    fileprivate var count = 0
    
    fileprivate func scheduleNotification(){
        if #available(iOS 10.0, *) {
            Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
                self.count = self.count + 1
                self.sendEventMessage(message: self.count)
            }
        } else {
            swiftStreamHandler.addStream(stream: "Failed to start scheduleNotification")
        }
    }
}
