//
//  QuickPlayerResourceManagerProtocol.swift
//  QuickPlayer
//
//  Created by Shvier on 27/05/2017.
//  Copyright © 2017 Shvier. All rights reserved.
//

import Foundation

@objc public protocol QuickPlayerResourceManagerDelegate {
    
    @objc func resourceManagerRequestResponsed(manager: QuickPlayerResourceManager, videoLength: Int64)
    @objc func resourceManagerReceiving(manager: QuickPlayerResourceManager, progress: Float)
    @objc func resourceManagerFinshLoading(manager: QuickPlayerResourceManager, cachePath: String)
    @objc func resourceManagerFailedLoading(manager: QuickPlayerResourceManager, error: Error)
}
