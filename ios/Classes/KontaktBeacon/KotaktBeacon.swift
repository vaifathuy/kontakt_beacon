//
//  KotaktBeacon.swift
//  Runner
//
//  Created by Vaifat on 6/3/20.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import Foundation
import Flutter

/// For KontaktBeacon
class KontaktBeacon{
    fileprivate var swiftChannelHandler: SwiftChannelHandler!
    
    init(channelHandler: SwiftChannelHandler) {
        swiftChannelHandler = channelHandler
    }
}
