//
//  HTTPURLResponse+Extension.swift
//  QuickPlayer
//
//  Created by Shvier on 2018/5/29.
//  Copyright © 2018 Shvier. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
    
    func contentLength() -> Int64 {
        let contentRange = self.allHeaderFields[HTTPContentRangeKey] as? String
        guard let wrappedRange = contentRange else {
            return self.expectedContentLength
        }
        let contentRanges = wrappedRange.components(separatedBy: "/")
        if contentRanges.count > 0 {
            let length = contentRanges.last!.replacingOccurrences(of: " ", with: "")
            return Int64(length)!
        }
        return 0
    }
    
    func supportRange() -> Bool {
        return self.allHeaderFields.keys.contains(HTTPContentRangeKey)
    }
    
}
