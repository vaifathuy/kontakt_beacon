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
    
    init(identifier: PlatformChannelIdentifier) {
        
    }
    
    fileprivate func setupCommunicationChannels(messenger: FlutterBinaryMessenger){
        
//        methodChannel = FlutterMethodChannel(name: channelIdentifer.methodChannelName, binaryMessenger: messenger)
//        setupMethodHandler()
//        
//        if channelIdentifer.isEventChannelAvailable() {
//            eventChannel = FlutterEventChannel(name: channelIdentifer.eventChannelName!, binaryMessenger: messenger)
//            eventChannel?.setStreamHandler(swiftStreamHandler)
//        }
    }
}
