
//
//  QuickPlayerManager.swift
//  QuickPlayer
//
//  Created by Shvier on 24/04/2017.
//  Copyright © 2017 Shvier. All rights reserved.
//

import UIKit

open class QuickPlayerManager: NSObject {
    
    static let sharedInstance = QuickPlayerManager()
    
    var httpsMode: Bool {
        get {
            return false
        }
        set {
            self.httpsMode = newValue
        }
    }
    
    var cachePath: String {
        get {
            return NSHomeDirectory().appending("/Library/Caches/\(Bundle.main.bundleIdentifier!)")
        }
        set {
            self.cachePath = newValue
        }
    }

}
