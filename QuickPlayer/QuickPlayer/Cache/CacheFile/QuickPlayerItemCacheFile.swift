//
//  QuickPlayerItemCacheFile.swift
//  QuickPlayer
//
//  Created by Shvier on 2018/5/28.
//  Copyright © 2018 Shvier. All rights reserved.
//

import UIKit

class QuickPlayerItemCacheFile: NSObject {
    
    var cacheFilePath: String!
    var serializationFilePath: String!
    var fileLength: UInt!
    var readOffset: UInt!
    var responseHeader: [String: String]!
    var isFinished: Bool!
    var isEOF: Bool!
    var isFileLengthValid: Bool!
    var cachedDataBound: UInt!
    
    var ranges: [NSRange]!
    var readFileHandle: FileHandle!
    var writeFileHandle: FileHandle!
    
    // MARK: Constructor
    init(cacheFileName: String, fileExtension: String? = "mp4") {
        let cacheFileInfo = QuickCacheManager.getOrCreateCacheFile(fileName: cacheFileName, fileExtension: fileExtension)
        let serializationFileInfo = QuickCacheManager.getOrCreateCacheFile(fileName: cacheFileName, fileExtension: SerializationFileExtension)
        if !cacheFileInfo.1 && serializationFileInfo.1 {
            return
        }
        self.cacheFilePath = cacheFileInfo.0
        self.serializationFilePath = serializationFileInfo.0
        self.ranges = [NSRange]()
        self.readFileHandle = FileHandle.init(forReadingAtPath: self.cacheFilePath)!
        self.writeFileHandle = FileHandle.init(forWritingAtPath: self.cacheFilePath)!
    }
    
    // MARK: Life Cycle
    deinit {
        self.writeFileHandle.closeFile()
        self.readFileHandle.closeFile()
    }
    
}
