//
//  QuickPlayerItemCacheFile.swift
//  QuickPlayer
//
//  Created by Shvier on 2018/5/28.
//  Copyright © 2018 Shvier. All rights reserved.
//

import UIKit

class QuickPlayerItemCacheFile: NSObject {
    
    var cacheFilePath: String
    var indexFilePath: String
    var fileLength: UInt
    var readOffset: UInt
    var responseHeader: [String: String]
    var isFinished: Bool
    var isEOF: Bool
    var isFileLengthValid: Bool
    var cachedDataBound: UInt
    
    // MARK: Constructor
    init(_ cacheFilePath: String) {
        
    }

}
