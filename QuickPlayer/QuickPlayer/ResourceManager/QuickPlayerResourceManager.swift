//
//  QuickPlayerResourceManager.swift
//  QuickPlayer
//
//  Created by Shvier on 27/05/2017.
//  Copyright © 2017 Shvier. All rights reserved.
//

import UIKit
import AVFoundation

open class QuickPlayerResourceManager: NSObject {
    
    let RequestTimeOut:                        TimeInterval = 20
    
    lazy var session:                          URLSession = {
        return URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
    }()
    
    private(set) public var videoURL:          URL!
    private(set) public var filename:          String!
    private(set) public weak var delegate:     QuickPlayerResourceManagerDelegate!
    
    // video size
    fileprivate(set) public var totalLength:   Int64 = 0
    // current cache size
    fileprivate(set) public var currentLength: Int = 0
    
    var tempPath:                              String?
    var cachePath:                             String?
    var dataTask:                              URLSessionDataTask?

    public init(_ videoURL: URL, filename: String, delegate: QuickPlayerResourceManagerDelegate) {
        super.init()
        self.videoURL = videoURL
        self.filename = filename
        self.delegate = delegate
        handleFile()
    }
    
    // start or resume http request
    func resume() {
        if dataTask == nil {
            startRequest()
        } else {
            dataTask?.resume()
        }
    }
    
    // pause http request
    func suspend() {
        dataTask?.suspend()
    }
    
    // cancel http request
    func cancel() {
        dataTask?.cancel()
        session.invalidateAndCancel()
        dataTask = nil
    }
    
    func startRequest() {
        var request: URLRequest = URLRequest(url: videoURL, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: RequestTimeOut)
        request.setValue("bytes=\(currentLength)-", forHTTPHeaderField: "Range")
        dataTask = session.dataTask(with: request)
        dataTask?.resume()
    }
    
    func handleFile() {
        tempPath = QuickCacheHandle.tempFilePath(filename: filename)
        cachePath = QuickCacheHandle.cacheFilePath(filename: filename)
        let _ = QuickCacheHandle.createTempFile(filename: filename)
        startRequest()
    }

}

extension QuickPlayerResourceManager: URLSessionDataDelegate {
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        let httpResponse = response as! HTTPURLResponse
        let headerFields = httpResponse.allHeaderFields
        let content = headerFields["Content-Range"] as? String
        let array = content?.components(separatedBy: "/")
        let length = array?.last
        
        var videoLength: Int64 = 0
        if Int64.init(length ?? "0")! == 0 {
            videoLength = Int64(httpResponse.expectedContentLength)
        } else {
            videoLength = Int64.init(length!)!
        }
        
        completionHandler(.allow)
        
        totalLength = response.expectedContentLength + Int64(currentLength)
        delegate.resourceManagerRequestResponsed(manager: self, videoLength: videoLength)
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        QuickCacheHandle.writeTempFile(data: data, filename: filename!)
        currentLength = currentLength + data.count
        let progress: Float = Float(currentLength) / Float(totalLength)
        delegate.resourceManagerReceiving(manager: self, progress: progress)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error == nil { // Download Completed
            if (QuickCacheHandle.cacheFileExists(filename: filename!) != nil) {
                QuickCacheHandle.clearCacheFile(filename: filename!)
            }
            
            QuickCacheHandle.cacheTempFile(filename: filename!)
            QuickCacheHandle.clearTempFile(filename: filename!)
            delegate.resourceManagerFinshLoading(manager: self, cachePath: QuickCacheHandle.cacheFilePath(filename: filename!))
        } else {
            delegate.resourceManagerFailedLoading(manager: self, error: error!)
        }
    }
    
}
