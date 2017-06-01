# QuickPlayer-Swift

<a href="https://travis-ci.org/Shvier/QuickPlayer-Swift"><img src="https://travis-ci.org/Shvier/QuickPlayer-Swift.svg?branch=master"></a>
<a href="https://raw.githubusercontent.com/Shvier/QuickPlayer-Swift/master/README.md"><img src="https://img.shields.io/packagist/l/doctrine/orm.svg"></a>
<a href=""><img src="https://img.shields.io/badge/platform-ios-lightgray.svg"></a>

[**中文说明**]()

## Features

- Based on AVPlayer, the performance is not bad.
- Stream caching player, just customize your own path to cache video.
- Use URLSession and Swift 3.

## Requirements

- iOS 8.0+
- Swift 3

## Usage

1. Init Player  
`let player = QuickPlayer(frame: view.frame)`

2. Add player view.  
`view.addSubview(player.playerView)`

3. Set cover url or video url  
`player.preparePlay(coverUrl: #URL#)`
`player.startPlayer(videoUrl: #URL#)`

4. Change video source
`player.replaceCurrentItem(coverUrl: #URL#, videoUrl: #URL#)`

## Other

### Contact

Follow and contact me on [Sina Weibo](http://weibo.com/Shvier) or my [Home Page](https://www.shvier.com). If you find an issue, just [open a ticket](https://github.com/Shvier/QuickPlayer-Swift/issues/new). Pull requests are warmly welcome as well.

### License

QuickPlayer is released under the MIT license. See LICENSE for details.
