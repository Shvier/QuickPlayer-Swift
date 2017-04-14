//
//  QuickSessionTaskProtocol.swift
//  QuickPlayer
//
//  Created by Shvier on 14/04/2017.
//  Copyright © 2017 Shvier. All rights reserved.
//

import Foundation

@objc public protocol QuickSessionTaskDelegate {
    
    @objc func requestTaskDidUpdateCache()
    
    @objc optional func requestTaskDidReceivedResponse()
    @objc optional func requestTaskDidFinishedLoading()
    @objc optional func requestTaskDidFailed(error: Error)
    
}
