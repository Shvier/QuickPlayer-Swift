//
//  QuickSessionTask.swift
//  QuickPlayer
//
//  Created by Shvier on 12/04/2017.
//  Copyright © 2017 Shvier. All rights reserved.
//

import UIKit

public class QuickSessionTask: NSObject {
    
    let RequestTimeOut: TimeInterval = 10
    
    public weak var delegate: QuickSessionTaskDelegate?
    
    var requestURL: URL?
    var requestOffset: Int64 = 0
    var fileLength: Int64 = 0
    var cacheLength: Int = 0
    var allowCache: Bool = true
    var cancel: Bool {
        get {
            return self.cancel
        }
        set {
            self.cancel = newValue
            if newValue {
                sessionTask?.cancel()
                session?.invalidateAndCancel()
            }
        }
    }
    var filename: String!
    
    var session: URLSession?
    var sessionTask: URLSessionDataTask?
    
    public init(filename: String) {
        super.init()
        self.filename = filename
        let _ = QuickCacheHandle.createTempFile(filename: filename)
    }
    
    public func resume() {
        let request = NSMutableURLRequest(url: (requestURL?.originalSchemeURL())!, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: RequestTimeOut)
        if requestOffset > 0 {
            request.addValue("bytes=\(requestOffset)-\(fileLength-1)", forHTTPHeaderField: "Range")
        }
        session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
        sessionTask = session?.dataTask(with: request as URLRequest)
        sessionTask?.resume()
    }

}

extension QuickSessionTask: URLSessionDataDelegate {
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        if cancel {
            return
        }
        print("response: \(response)")
        completionHandler(.allow)
        let httpResponse = response as! HTTPURLResponse
        let contentRange = httpResponse.allHeaderFields["Content-Rage"] as! String
        let fileLength = contentRange.components(separatedBy: "/").last
        self.fileLength = Int64.init(fileLength!)! > 0 ? Int64.init(fileLength!)! : Int64.init(response.expectedContentLength)
        delegate?.requestTaskDidReceivedResponse!()
    }
    
}

extension QuickSessionTask: NSURLConnectionDataDelegate {
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if cancel {
            return
        }
        QuickCacheHandle.writeTempFile(data: data, filename: filename)
        cacheLength += NSData.init(data: data).length
        delegate?.requestTaskDidUpdateCache()
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if cancel {
            print("download cancel")
        } else {
            if let e = error {
                delegate?.requestTaskDidFailed!(error: e)
            } else {
                if allowCache {
                    QuickCacheHandle.cacheTempFile(filename: filename)
                }
                delegate?.requestTaskDidFinishedLoading!()
            }
        }
    }
    
}
