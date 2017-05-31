
//
//  QuickPlayerManager.swift
//  QuickPlayer
//
//  Created by Shvier on 24/04/2017.
//  Copyright © 2017 Shvier. All rights reserved.
//

import UIKit

public class QuickPlayerManager: NSObject {
    
    static let sharedInstance = QuickPlayerManager()
    
//    lazy var httpsMode: Bool = {
//        return false
//    }()
    
    lazy var cachePath: String = {
        return NSHomeDirectory().appending("/Library/Caches/\(Bundle.main.bundleIdentifier!)")
    }()

}
