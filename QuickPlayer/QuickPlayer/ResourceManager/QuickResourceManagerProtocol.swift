//
//  QuickResourceManagerProtocol.swift
//  QuickPlayer
//
//  Created by Shvier on 13/04/2017.
//  Copyright © 2017 Shvier. All rights reserved.
//

import Foundation

@objc public protocol QuickResourceManagerDelegate: class {
    
    @objc optional func resourceManagerCacheProgress(manager: QuickResourceManager, progress: CGFloat)
    @objc optional func resourceManagerFailLoading(manager: QuickResourceManager, error: Error)
    @objc optional func resourceManagerFinishLoading(manager: QuickResourceManager)
    
}
