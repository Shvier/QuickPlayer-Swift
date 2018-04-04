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
        player.startPlay(videoUrl: URL(string: "https://www.videvo.net/videvo_files/converted/2013_06/videos/OldFashionedFilmLeaderCountdownVidevo.mov22394.mp4")!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [unowned self] in
            self.player.replaceCurrentItem(coverUrl: nil, videoUrl: URL(string: "https://www.videvo.net/videvo_files/converted/2014_08/videos/Earth_Zoom_In.mov35908.mp4")!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ViewController: QuickPlayerDelegate {
    
}

