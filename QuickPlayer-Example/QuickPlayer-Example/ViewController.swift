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
        addObserver(self, forKeyPath: #keyPath(player), options: [.initial, .old, .new], context: nil)
        player = QuickPlayer(frame: view.frame)
//        player.delegate = self
        view.addSubview(player.playerView)
        player.startPlay(videoUrl: URL(fileURLWithPath: Bundle.main.path(forResource: "test", ofType: "m4v")!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
    }

}

extension ViewController: QuickPlayerDelegate {
    
}

