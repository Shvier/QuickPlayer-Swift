//
//  QuickPlayerDownloader.swift
//  QuickPlayer
//
//  Created by Shvier on 05/05/2017.
//  Copyright © 2017 Shvier. All rights reserved.
//

import UIKit

public class QuickPlayerDownloader: NSObject {
    
    let RequestTimeOut: TimeInterval = 20
    
    fileprivate(set) public lazy var connectionList: Array<NSURLConnection> = {
        return Array<NSURLConnection>()
    }()
    
    fileprivate(set) public var mimeType:            String?
    private(set) public var connection:              NSURLConnection?
    private(set) public var requestOffset:           Int64 = 0
    private(set) public var filename:                String!
    
    public weak var delegate:                        QuickPlayerDownloaderDelegate?
    
    var fileLength:                                  Int64 = 0
    var cacheLength:                                 Int = 0
    var requestURL:                                  URL?
    var cached:                                      Bool = true
    var once:                                        Bool = false
    var fileHandle:                                  FileHandle?
    var offset: Int64 = 0
    var tempPath: String?
    
    public init(filename: String) {
        super.init()
        self.filename = filename
//        let _ = QuickCacheHandle.createTempFile(filename: filename)
//        self.tempPath = QuickCacheHandle.tempFilePath(filename: filename)
        self.tempPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last?.appending("/temp.mp4")

        if FileManager.default.fileExists(atPath: self.tempPath!) {
            try? FileManager.default.removeItem(atPath: self.tempPath!)
            FileManager.default.createFile(atPath: self.tempPath!, contents: nil, attributes: nil)
        } else {
            FileManager.default.createFile(atPath: self.tempPath!, contents: nil, attributes: nil)
        }
    }
    
    public func cancel() {
        connection?.cancel()
    }
    
    public func clearData() {
        connection?.cancel()
        QuickCacheHandle.clearCache(filename: filename)
    }
    
    public func setRequestURL(requestURL: URL, requestOffset: Int64) {
        self.requestURL = requestURL
        self.requestOffset = requestOffset
        
        // If request for second time, create a new file and remove old file
        if connectionList.count >= 1 {
//            QuickCacheHandle.clearCache(filename: filename)
//            let _ = QuickCacheHandle.createTempFile(filename: filename)
            try? FileManager.default.removeItem(atPath: self.tempPath!)
            FileManager.default.createFile(atPath: self.tempPath!, contents: nil, attributes: nil)
        }
        
        cacheLength = 0
        var request = URLRequest(url: (self.requestURL?.originalSchemeURL())!, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: RequestTimeOut)
        if self.requestOffset > 0 && fileLength > 0 {
            request.addValue("bytes=\(self.requestOffset)-\(fileLength-1)", forHTTPHeaderField: "Range")
        }
        connection?.cancel()
        connection = NSURLConnection(request: request, delegate: self, startImmediately: false)
        connection?.setDelegateQueue(OperationQueue.main)
        connection?.start()
    }
    
    func continueLoading() {
        once = true
        var request = URLRequest(url: self.requestURL!, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: RequestTimeOut)
        if self.requestOffset > 0 && fileLength > 0 {
            request.addValue("bytes=\(self.requestOffset)-\(fileLength-1)", forHTTPHeaderField: "Range")
        }
        connection?.cancel()
        connection = NSURLConnection(request: request, delegate: self, startImmediately: false)
        connection?.setDelegateQueue(OperationQueue.main)
        connection?.start()
    }
}

extension QuickPlayerDownloader: NSURLConnectionDataDelegate {
    
    public func connection(_ connection: NSURLConnection, didReceive response: URLResponse) {
        cached = false
        let httpResponse = response as! HTTPURLResponse
        let headerFields = httpResponse.allHeaderFields
        let content = headerFields["Content-Range"] as? String
        let array = content?.components(separatedBy: "/")
        let length = array?.last

        var fileLength: Int64 = 0
        if Int64.init(length ?? "0")! == 0 {
            fileLength = Int64(httpResponse.expectedContentLength)
        } else {
            fileLength = Int64.init(length!)!
        }
        
        if content == nil {
            offset = 0
        } else {
            offset = fileLength - cacheLength
        }
        
        self.fileLength = fileLength
        self.mimeType = "video/mp4"
        
        delegate?.downloaderDidReceivedResponse!(fileLength: fileLength)
        connectionList.append(connection)
//        fileHandle = FileHandle.init(forWritingAtPath: QuickCacheHandle.tempFilePath(filename: filename))
        fileHandle = FileHandle.init(forWritingAtPath: self.tempPath!)
    }
    
    public func connection(_ connection: NSURLConnection, didReceive data: Data) {
//        QuickCacheHandle.writeTempFile(data: data, filename: filename)
//        cacheLength += data.count
        fileHandle?.seekToEndOfFile()
        fileHandle?.seek(toFileOffset: UInt64(offset))
        fileHandle?.write(data)
        cacheLength += data.count
        delegate?.downloaderDidUpdateCache!()
    }
    
    public func connectionDidFinishLoading(_ connection: NSURLConnection) {
        if connectionList.count < 2 {
            cached = true
            QuickCacheHandle.cacheTempFile(filename: filename)
        }
        delegate?.downloaderDidFinishedLoading!()
    }
    
    public func connection(_ connection: NSURLConnection, didFailWithError error: Error) {
        if (error as NSError).code == -1001 && !once {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { 
                self.continueLoading()
            })
        }
        delegate?.downloaderDidFailed!(error: error)
    }
    
}
