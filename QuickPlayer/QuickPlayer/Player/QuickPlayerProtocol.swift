//
//  QuickPlayerProtocol.swift
//  QuickPlayer
//
//  Created by Shvier on 01/04/2017.
//  Copyright © 2017 Shvier. All rights reserved.
//

@objc public enum PlayerStatus: Int {
    case Buffering
    case ReadyToPlay
    case Paused
    case Failed
    case Playing
    case Stopped
    case Finished
    case Unknown
}

@objc public protocol QuickPlayerDelegate: class {

    @objc optional func playerPlayingVideo(player: QuickPlayer, currentTime: CGFloat)
    @objc optional func playerChangedStatus(status: PlayerStatus)
    @objc optional func playerFinished(player: QuickPlayer)
    @objc optional func playerCached(player: QuickPlayer, cahceProgress: CGFloat)
    @objc optional func playerCacheFailed(player: QuickPlayer, error: Error)

}
