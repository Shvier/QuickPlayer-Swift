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
    
    var frame: CGRect = CGRect.zero
    var playbackTimeObserver: Any?
    
    public func preparePlay(coverUrl: URL) {
        
    }
    
    public func startPlay(videoUrl: URL) {
        
    }
    
    public func pause() {
        
    }
    
    public func resume() {
        
    }
    
    public func play() {
        
    }
    
    public func stop() {
        
    }
    
    public init(frame: CGRect) {
        super.init()
        self.frame = frame
        self.initialize()
    }
    
    deinit {
        removeObserver(self, forKeyPath: "player.currentItem.loadedTimeRanges")
        removeObserver(self, forKeyPath: "player.status")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        if let observer = playbackTimeObserver {
            player.removeTimeObserver(observer)
        }
    }
    
    func initialize() {
        self.addObserverForPlayer()
        playerView = ({
            let view = UIView(frame: self.frame)
            return view
        }())
    }
    
    func addObserverForPlayer() {
        addObserver(self, forKeyPath: "player.currentItem.loadedTimeRanges", options: [.old, .new], context: nil)
        addObserver(self, forKeyPath: "player.status", options: [.old, .new], context: nil)
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: OperationQueue.current) { [unowned self] (notification) in
            if notification.object as? AVPlayerItem == self.player.currentItem {
                
            }
        }
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "player.status" {
            let status: AVPlayerStatus = AVPlayerStatus(rawValue: ((object as? NSNumber)?.intValue)!)!
            switch status {
            case .readyToPlay:
                playbackTimeObserver = player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1.0/60.0, Int32(NSEC_PER_SEC)), queue: DispatchQueue.main, using: { (time) in
                    
                })
                break
            case .unknown:
                break
            case .failed:
                break
            }
        }
    }
    
}
