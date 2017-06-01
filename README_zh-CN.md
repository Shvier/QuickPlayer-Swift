# QuickPlayer-Swift

<a href="https://travis-ci.org/Shvier/QuickPlayer-Swift"><img src="https://travis-ci.org/Shvier/QuickPlayer-Swift.svg?branch=master"></a>
<a href="https://raw.githubusercontent.com/Shvier/QuickPlayer-Swift/master/README.md"><img src="https://img.shields.io/packagist/l/doctrine/orm.svg"></a>
<a href=""><img src="https://img.shields.io/badge/platform-ios-lightgray.svg"></a>

[**English**]()

## 特性

- 基于AVPlayer，较好的性能表现。
- 边下边播，自带缓存功能，可自定义缓存目录。
- 使用URLSession和Swift 3。

## 需求

- iOS 8.0+
- Swift 3

## 使用方法

1. 初始化播放器  
`let player = QuickPlayer(frame: view.frame)`

2. 将播放器的视图添加到想要显示的view上  
`view.addSubview(player.playerView)`

3. 设置封面图或者视频源  
`player.preparePlay(coverUrl: #URL#)`
`player.startPlayer(videoUrl: #URL#)`

4. 改变视频源
`player.replaceCurrentItem(coverUrl: #URL#, videoUrl: #URL#)`

## 其它

### 联系方式

欢迎使用，可以在[新浪微博](http://weibo.com/Shvier)上联系我，也欢迎访问我的[主页](https://www.shvier.com)。如果使用过程中有任何问题，欢迎提[issue](https://github.com/Shvier/QuickPlayer-Swift/issues/new)。

### 协议

本工程基于MIT协议。
