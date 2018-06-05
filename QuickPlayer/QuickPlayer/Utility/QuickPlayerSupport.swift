//
//  QuickPlayerSupport.swift
//  QuickPlayer
//
//  Created by Shvier on 2018/5/29.
//  Copyright © 2018 Shvier. All rights reserved.
//

import UIKit

let BundleIdentifier = "\(Bundle.main.bundleIdentifier!)"
let QuickPlayerAssetReesourceLoaderOperationQueueName = BundleIdentifier
let InvalidRange = NSRange(location: NSNotFound, length: 0)
let SerializationFileExtension = ".cache"
let DefaultCacheFileExtension = ".mp4"
let HTTPContentRangeKey = "Content-Range"
let HTTPContentLengthKey = "Content-Length"
let HTTPResponseVersion = "HTTP/1.1"

enum HTTPStatusCode: UInt {
    case Successed = 200
    case SupportRange = 206
}

class QuickPlayerSupport: NSObject {

    static func validByteRange(_ range: NSRange) -> Bool {
        return ((range.location != NSNotFound) || (range.length > 0))
    }
    
    static func validFileRange(_ range: NSRange) -> Bool {
        return ((range.location != NSNotFound) && (range.length > 0) && range.length != Int.max)
    }
    
    static func convertNSRangeToHTTPContentRange(_ range: NSRange, _ length: UInt) -> String? {
        if validByteRange(range) {
            var start = range.location
            var end = NSMaxRange(range) - 1
            if range.location == NSNotFound {
                start = range.location
            } else if range.length == Int.max {
                start = Int(length) - range.length
                end = start + range.length - 1
            }
            return "bytes \(start)-\(end)/\(length)"
        }
        return nil
    }
    
}
