//
//  QuickPlayerResourceManager.swift
//  QuickPlayer
//
//  Created by Shvier on 27/05/2017.
//  Copyright © 2017 Shvier. All rights reserved.
//

import UIKit
import AVFoundation

class QuickPlayerResourceManager: NSObject {
    
    lazy var session: URLSession = {
        return URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
    }()
    
    private(set) public var videoURL: URL!
    public weak var delegate: QuickPlayerResourceManagerDelegate!

    public init(_ videoURL: URL, delegate: QuickPlayerResourceManagerDelegate) {
        super.init()
        self.videoURL = videoURL
        self.delegate = delegate
    }
    
    func resume() {
        
    }
    
    func suspend() {
        
    }
    
    func cancel() {
        
    }

}

extension QuickPlayerResourceManager: URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
    }
    
}
