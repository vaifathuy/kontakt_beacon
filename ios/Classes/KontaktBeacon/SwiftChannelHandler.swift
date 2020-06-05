//
//  SwiftChannelHandler.swift
//  Runner
//
//  Created by Vaifat on 6/3/20.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import Foundation
import Flutter

class SwiftChannelHandler {
    fileprivate var channelIdentifer: PlatformChannelIdentifier!
    fileprivate var methodChannel: FlutterMethodChannel!
    fileprivate var eventChannel: FlutterEventChannel?
    fileprivate var messenger: FlutterBinaryMessenger!
    
    fileprivate let swiftStreamHandler = SwiftStreamHandler()
    
    var didSetMethodCallHandler: ((_ methodChannel: FlutterMethodChannel, _ methodCall: FlutterMethodCall, _ result: FlutterResult) -> Void)!
    
    init(identifier: PlatformChannelIdentifier, messenger: FlutterBinaryMessenger) {
        self.channelIdentifer = identifier
        self.messenger = messenger
    }
    
    fileprivate func setupCommunicationChannels(){
        methodChannel = FlutterMethodChannel(name: channelIdentifer.methodChannelName, binaryMessenger: messenger)
        setupMethodHandler()
        
        if channelIdentifer.isEventChannelAvailable() {
            eventChannel = FlutterEventChannel(name: channelIdentifer.eventChannelName!, binaryMessenger: messenger)
            eventChannel?.setStreamHandler(swiftStreamHandler)
        }
    }
    
    fileprivate func setupMethodHandler(){
        // MARK: Methods Handler
        methodChannel.setMethodCallHandler { (call, result) in
            self.didSetMethodCallHandler(self.methodChannel, call, result)
        }
    }
}

// API Functions
extension SwiftChannelHandler {
    // Helper
    func sendEventMessage(message: Any) {
        swiftStreamHandler.addStream(stream: message)
    }
    
    /// In order to make connections to Flutter, this method is required to call after creating SwiftChannelHandler object
    func setupOperation(){
        setupCommunicationChannels()
    }
}
