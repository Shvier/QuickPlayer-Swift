//
//  QuickPlayerRequestTask.swift
//  QuickPlayer
//
//  Created by Shvier on 05/05/2017.
//  Copyright © 2017 Shvier. All rights reserved.
//

import UIKit

class QuickPlayerRequestTask: NSObject {
    
    let RequestTimeOut: TimeInterval = 10
    
    public weak var delegate: QuickSessionTaskDelegate?
    
    var requestURL: URL?
    var requestOffset: Int64 = 0
    var fileLength: Int64 = 0
    var cacheLength: Int = 0
    var allowCache: Bool = true
    var cancel: Bool {
        get {
            return self.cancel
        }
        set {
            self.cancel = newValue
            if newValue {
                
            }
        }
    }
    var filename: String!
    
    var connection: NSURLConnection?
    
    public init(filename: String) {
        super.init()
        self.filename = filename
        let _ = QuickCacheHandle.createTempFile(filename: filename)
    }
    
}

extension QuickPlayerRequestTask: NSURLConnectionDataDelegate {
    
}
