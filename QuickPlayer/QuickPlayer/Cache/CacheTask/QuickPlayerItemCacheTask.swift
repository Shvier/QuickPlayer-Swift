//
//  QuickPlayerItemCacheTask.swift
//  QuickPlayer
//
//  Created by Shvier on 2018/5/28.
//  Copyright © 2018 Shvier. All rights reserved.
//

import UIKit
import AVFoundation

class QuickPlayerItemCacheTask: Operation {
    
    var cacheFile: QuickPlayerItemCacheFile
    var loadingRequest: AVAssetResourceLoadingRequest
    var range: NSRange
    
    override func main() {
        
    }

    // MARK: Constructor
    init(_ cacheFile: QuickPlayerItemCacheFile, _ loadingRequest: AVAssetResourceLoadingRequest, _ range: NSRange) {
        self.cacheFile = cacheFile
        self.loadingRequest = loadingRequest
        self.range = range
    }
    
}
