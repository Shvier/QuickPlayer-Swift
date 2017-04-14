//
//  Array+Extension.swift
//  QuickPlayer
//
//  Created by Shvier on 14/04/2017.
//  Copyright © 2017 Shvier. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    mutating func remove(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}
