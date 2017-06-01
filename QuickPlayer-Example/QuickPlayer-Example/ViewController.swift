//
//  ViewController.swift
//  QuickPlayer-Example
//
//  Created by Shvier on 31/03/2017.
//  Copyright © 2017 Shvier. All rights reserved.
//

import UIKit
import QuickPlayer
import AVFoundation

class ViewController: UIViewController {
    
    var player: QuickPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        player = QuickPlayer(frame: view.frame)
        view.addSubview(player.playerView)
        player.startPlay(videoUrl: URL(string: "http://o4saor8w2.qnssl.com/89MB.mp4")!)
        player.startPlay(videoUrl: URL(fileURLWithPath: Bundle.main.path(forResource: "test", ofType: "m4v")!))
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [unowned self] in
            self.player.replaceCurrentItem(coverUrl: nil, videoUrl: URL(fileURLWithPath: Bundle.main.path(forResource: "test", ofType: "m4v")!))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ViewController: QuickPlayerDelegate {
    
}

