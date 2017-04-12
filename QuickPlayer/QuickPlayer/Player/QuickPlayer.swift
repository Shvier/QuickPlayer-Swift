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

    private(set) public var player: AVPlayer?
    private(set) public var currentTime: CGFloat = 0.0
    private(set) public var playerView: UIView!
    private(set) public var currentItem: AVPlayerItem?
    private(set) public var status: PlayerStatus = .Stopped
    
    public var coverUrl: URL!
    public var videoUrl: URL!
    public var timeFrequency: Float64 = 1.0
    
    public weak var delegate: QuickPlayerDelegate?
    
    var frame: CGRect = CGRect.zero
    var playbackTimeObserver: Any?
    var coverView: UIImageView?
    var playerLayer: AVPlayerLayer?
    
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
    
    public func startPlay(videoUrl: URL) {
        if player == nil {
            self.videoUrl = videoUrl
            currentItem = AVPlayerItem(url: videoUrl)
            self.configPlayer()
        }
        self.play()
    }
    
    public func pause() {
        delegate?.playerChangedStatus!(status: .Paused)
        status = .Paused
        player?.pause()
    }
    
    public func resume() {
        delegate?.playerChangedStatus!(status: .Playing)
        status = .Playing
        player?.play()
    }
    
    public func play() {
        delegate?.playerChangedStatus!(status: .Playing)
        status = .Playing
        player?.seek(to: kCMTimeZero)
        player?.play()
    }
    
    public func stop() {
        delegate?.playerChangedStatus!(status: .Stopped)
        status = .Stopped
        coverView?.removeFromSuperview()
        playerLayer?.removeFromSuperlayer()
        player?.pause()
        player?.replaceCurrentItem(with: nil)
    }
    
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
