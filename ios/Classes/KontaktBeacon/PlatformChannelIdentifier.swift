//
//  PlatformChannelIdentifier.swift
//  Runner
//
//  Created by Vaifat on 6/3/20.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import Foundation

class PlatformChannelIdentifier {
    var methodChannelName: String!
    var eventChannelName: String?
    
    init(methodChannelName: String, eventChannelName: String? = nil) {
        self.methodChannelName = methodChannelName
        self.eventChannelName = eventChannelName
    }
    
    func isEventChannelAvailable() -> Bool {
        guard eventChannelName != nil else { return false }
        return true
    }
}
