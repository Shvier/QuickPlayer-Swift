//
//  QuickPlayerResourceLoaderProtocol.swift
//  QuickPlayer
//
//  Created by Shvier on 06/05/2017.
//  Copyright © 2017 Shvier. All rights reserved.
//

import Foundation

@objc public protocol QuickPlayerResourceLoaderDelegate {
    
    @objc optional func resourceLoaderCacheProgress(progress: Float)
    @objc optional func resourceLoaderFailLoading(error: Error)
    @objc optional func resourceLoaderFinishLoading()
    
}
