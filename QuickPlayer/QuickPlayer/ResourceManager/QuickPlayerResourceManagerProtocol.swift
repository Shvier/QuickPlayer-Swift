//
//  QuickPlayerResourceManagerProtocol.swift
//  QuickPlayer
//
//  Created by Shvier on 27/05/2017.
//  Copyright © 2017 Shvier. All rights reserved.
//

import Foundation

@objc public protocol QuickPlayerResourceManagerDelegate {
    
    @objc optional func resourceManagerRequestResponsed(manager: QuickPlayerResourceManager, videoLength: Int64)
    @objc optional func resourceManagerReceiving(manager: QuickPlayerResourceManager, progress: Float)
    @objc optional func resourceManagerFinshLoading(manager: QuickPlayerResourceManager, cachePath: String)
    @objc optional func resourceManagerFailedLoading(manager: QuickPlayerResourceManager, error: Error)
}
