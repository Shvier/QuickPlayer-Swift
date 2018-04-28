# QuickPlayer-Swift

<a href="https://travis-ci.org/Shvier/QuickPlayer-Swift"><img src="https://travis-ci.org/Shvier/QuickPlayer-Swift.svg?branch=master"></a>
<a href="#"><img src="https://img.shields.io/cocoapods/v/QuickPlayer.svg"></a>
<a href="https://raw.githubusercontent.com/Shvier/QuickPlayer-Swift/master/LICENSE"><img src="https://img.shields.io/cocoapods/l/QuickPlayer.svg"></a>
<a href="#"><img src="https://img.shields.io/cocoapods/p/QuickPlayer.svg"></a>

[**中文说明**](https://github.com/Shvier/QuickPlayer-Swift/blob/master/README_zh-CN.md)

## Features

- Based on AVPlayer, the performance is not bad.
- Stream caching player, just customize your own path to cache video.
- Use URLSession and Swift 4.

## Requirements

- iOS 8.1+
- Swift 4

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate QuickPlayer into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.1'
use_frameworks!

target '<Your Target Name>' do
    pod 'QuickPlayer'
end
```

Then, run the following command:

```bash
$ pod install
```

### Manually

Open Sample Project, build `Aggrate` in Xcode. Import `framework` to your own project.

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
