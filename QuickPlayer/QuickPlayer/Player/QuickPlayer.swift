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

    // AVPlayer
    private(set) public var player: AVPlayer?
    // video current play time
    private(set) public var currentTime: CGFloat = 0.0
    // view rendering video
    private(set) public var playerView: UIView!
    // current video item
    private(set) public var currentItem: AVPlayerItem?
    // current player status
    private(set) public var status: PlayerStatus = .Stopped
    // cover view url
    private(set) public var coverUrl: URL!
    // video url
    private(set) public var videoUrl: URL!
    
    // current time callback frequency
    public var timeFrequency: Float64 = 1.0
    
    // volume
    public var volume: Float {
        get {
            return (player?.volume)!
        }
        set {
            player?.volume = newValue
        }
    }
    
    // player delegate, jump to QuickPlayerDelegate.Swift
    public weak var delegate: QuickPlayerDelegate?
    
    // frame of player view
    var frame: CGRect = CGRect.zero
    // current time observer
    var playbackTimeObserver: Any?
    // cover image
    var coverView: UIImageView?
    // AVPlayer layer
    var playerLayer: AVPlayerLayer?
    // cache resource manager
    var resourceManager: QuickPlayerResourceManager?
    // cache filename
    var filename: String?
    
    /// if you like to fix a brief black screen before playing for video, just set a cover image
    ///
    /// - Parameter coverUrl: cover image url
    public func preparePlay(coverUrl: URL) {
        self.coverUrl = coverUrl
        if coverView == nil {
            self.configCoverView()
        } else {
            if (coverView?.isHidden)! {
                coverView?.isHidden = false
            }
        }
    }
    
    /// set a url for video
    ///
    /// - Parameter videoUrl: video url
    public func startPlay(videoUrl: URL) {
        self.videoUrl = videoUrl
        self.filename = videoUrl.path.components(separatedBy: "/").last
        if videoUrl.absoluteString.hasPrefix("http") {
            let cacheFilePath = QuickCacheHandle.cacheFileExists(filename: filename!)
            if cacheFilePath != nil {
                let url = URL(fileURLWithPath: cacheFilePath!)
                currentItem = AVPlayerItem(url: url)
            } else {
                resourceManager = QuickPlayerResourceManager.init(self.videoUrl, filename: self.filename!, delegate: self)
                currentItem = AVPlayerItem(url: self.videoUrl)
            }
        } else {
            currentItem = AVPlayerItem(url: videoUrl)
        }
        if player == nil {
            self.configPlayer()
        } else {
            
        }
        self.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { 
            if self.currentTime <= 0 {
                // play waiting indicator
            }
        }
    }
    
    /// pause player
    public func pause() {
        delegate?.playerChangedStatus!(status: .Paused)
        status = .Paused
        player?.pause()
    }
    
    /// resume Paused status
    public func resume() {
        delegate?.playerChangedStatus!(status: .Playing)
        status = .Playing
        player?.play()
    }
    
    /// play again from beginning time
    public func play() {
        delegate?.playerChangedStatus!(status: .Playing)
        status = .Playing
        player?.seek(to: kCMTimeZero)
        player?.play()
    }
    
    /// stop playing, the observer will be released when this object deinit
    public func stop() {
        delegate?.playerChangedStatus!(status: .Stopped)
        status = .Stopped
        coverView?.removeFromSuperview()
        playerLayer?.removeFromSuperlayer()
        player?.pause()
        player?.replaceCurrentItem(with: nil)
//        resourceManager?.stopLoading()
    }
    
    /// replace current item with another video
    ///
    /// - Parameters:
    ///   - coverUrl: if you don't like a cover image, leave it alone
    ///   - videoUrl: video url
    public func replaceCurrentItem(coverUrl: URL?, videoUrl: URL?) {
        if coverUrl != nil {
            self.coverUrl = coverUrl!
            self.preparePlay(coverUrl: self.coverUrl)
        }
        if videoUrl != nil {
            self.videoUrl = videoUrl
            currentItem = AVPlayerItem(url: videoUrl!)
            if self.player == nil {
                self.configPlayer()
            } else {
                self.playerLayer = AVPlayerLayer(player: player)
                self.playerLayer?.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
                player?.replaceCurrentItem(with: currentItem)
            }
            self.play()
        }
    }
    
    /// init
    ///
    /// - Parameter frame: frame of player view
    public init(frame: CGRect) {
        super.init()
        self.frame = frame
        self.initialize()
    }
    
    deinit {
        destoryPlayer()
    }
    
    func initialize() {
        playerView = ({
            let view = UIView(frame: frame)
            return view
        }())
    }
    
    func addObserverForPlayer() {
        addObserver(self, forKeyPath: #keyPath(player.currentItem.loadedTimeRanges), options: [.initial, .old, .new], context: nil)
        addObserver(self, forKeyPath: #keyPath(player.status), options: [.initial, .old, .new], context: nil)
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: OperationQueue.current) { [unowned self] (notification) in
            if notification.object as? AVPlayerItem == self.player?.currentItem {
                self.delegate?.playerFinished!(player: self)
                self.delegate?.playerChangedStatus!(status: .Stopped)
            }
        }
    }
    
    func configCoverView() {
        coverView = ({
            let view = UIImageView(frame: frame)
            view.contentMode = .scaleAspectFit
            return view
        }())
        playerView.addSubview(coverView!)
    }
    
    func configPlayer() {
        player = ({
            let player = AVPlayer(playerItem: self.currentItem)
            player.volume = 0
            return player
        }())
        playerLayer = ({
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
            return playerLayer
        }())
        playerView.layer.insertSublayer(playerLayer!, above: playerView.layer)
        addObserverForPlayer()
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if player == nil {
            return
        }
        if keyPath == "player.status" {
            let status: AVPlayerStatus = AVPlayerStatus(rawValue: ((change![NSKeyValueChangeKey.kindKey] as! NSNumber).intValue))!
            switch status {
            case .readyToPlay:
                self.delegate?.playerChangedStatus!(status: .ReadyToPlay)
                self.playbackTimeObserver = self.player?.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(timeFrequency, Int32(NSEC_PER_SEC)), queue: nil, using: { [unowned self] (time) in
                    let currentSecond = CGFloat((self.player?.currentItem?.currentTime().value)!)/CGFloat((self.player?.currentItem?.currentTime().timescale)!)
                    self.currentTime = currentSecond
                    if currentSecond > 0 {
                        if self.coverView != nil && !((self.coverView?.isHidden)!) {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                                self.coverView?.isHidden = true
                            })
                        }
                        self.delegate?.playerChangedStatus!(status: .Playing)
                    }
                    self.delegate?.playerPlayingVideo!(player: self, currentTime: currentSecond)
                })
                break
            case .unknown:
                self.delegate?.playerChangedStatus!(status: .Unknown)
                break
            case .failed:
                self.delegate?.playerChangedStatus!(status: .Failed)
                break
            }
        }
    }
    
    func destoryObserver() {
        NotificationCenter.default.removeObserver(self, forKeyPath: #keyPath(player.currentItem.loadedTimeRanges))
        NotificationCenter.default.removeObserver(self, forKeyPath: #keyPath(player.status))
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        if let observer = playbackTimeObserver {
            player?.removeTimeObserver(observer)
        }
    }
    
    func destoryPlayer() {
        destoryObserver()
        player?.pause()
        player = nil
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
    }
    
}

extension QuickPlayer: QuickPlayerResourceManagerDelegate {
    
    public func resourceManagerRequestResponsed(manager: QuickPlayerResourceManager, videoLength: Int64) {
        
    }
    
    public func resourceManagerReceiving(manager: QuickPlayerResourceManager, progress: Float) {
        
    }
    
    public func resourceManagerFinshLoading(manager: QuickPlayerResourceManager, cachePath: String) {
        
    }
    
    public func resourceManagerFailedLoading(manager: QuickPlayerResourceManager, error: Error) {
        
    }
    
}
