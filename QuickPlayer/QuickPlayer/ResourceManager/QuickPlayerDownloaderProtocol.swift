//
//  QuickPlayerDownloaderProtocol.swift
//  QuickPlayer
//
//  Created by Shvier on 14/04/2017.
//  Copyright © 2017 Shvier. All rights reserved.
//

import Foundation

@objc public protocol QuickPlayerDownloaderDelegate {
    
    @objc optional func downloaderDidUpdateCache()
    @objc optional func downloaderDidReceivedResponse(fileLength: Int64)
    @objc optional func downloaderDidFinishedLoading()
    @objc optional func downloaderDidFailed(error: Error)
    
}
