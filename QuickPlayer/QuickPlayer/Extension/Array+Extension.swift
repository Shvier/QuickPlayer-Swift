//
//  Array+Extension.swift
//  QuickPlayer
//
//  Created by Shvier on 2018/5/29.
//  Copyright © 2018 Shvier. All rights reserved.
//

import Foundation

extension Array where Element : Equatable {
    
    mutating func removeObject(_ object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
    
}
