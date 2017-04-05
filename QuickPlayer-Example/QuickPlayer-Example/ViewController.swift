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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let player = QuickPlayer(frame: CGRect.zero)
        player.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: QuickPlayerDelegate {
    
}

