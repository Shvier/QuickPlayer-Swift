//
//  QuickPlayer.swift
//  QuickPlayer
//
//  Created by Shvier on 31/03/2017.
//  Copyright © 2017 Shvier. All rights reserved.
//

import UIKit
import AVFoundation

open class QuickPlayer: NSObject {

    private(set) public var player: AVPlayer!
    private(set) public var currentTime: CGFloat = 0.0
    private(set) public var playerView: UIView!
    
    public var coverUrl: URL!
    public var videoUrl: URL!
    
    public weak var delegate: QuickPlayerDelegate?
    
}
