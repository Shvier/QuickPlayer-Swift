//
//  QuickResourceManager.swift
//  QuickPlayer
//
//  Created by Shvier on 12/04/2017.
//  Copyright © 2017 Shvier. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices

open class QuickResourceManager: NSObject {
    
    let MimeType = "video/mp4"
    
    public weak var delegate: QuickResourceManagerDelegate?
    
    lazy var requestList: [AVAssetResourceLoadingRequest] = {
        return Array<AVAssetResourceLoadingRequest>()
    }()
    
    public var seekRequired: Bool = false
    public var filename: String!
    
    var requestTask: QuickSessionTask?
    
    public init(filename: String) {
        super.init()
        self.filename = filename
    }
    
    public func stopLoading() {
        requestTask?.cancel = true
    }
    
    func addLoadingRequest(loadingRequest: AVAssetResourceLoadingRequest) {
        requestList.append(loadingRequest)
        objc_sync_enter(self)
        if requestTask != nil {
            if (loadingRequest.dataRequest?.requestedOffset)! >= Int64((requestTask?.requestOffset)!) &&
                (loadingRequest.dataRequest?.requestedOffset)! <= Int64((requestTask?.requestOffset)!) + Int64((requestTask?.cacheLength)!) {
                processLoadingRequest()
            } else {
                if seekRequired {
                    newTask(loadingRequest: loadingRequest, allowCache: false)
                }
            }
        } else {
            newTask(loadingRequest: loadingRequest, allowCache: true)
        }
        objc_sync_exit(self)
    }
    
    func removeLoadingRequest(loadingRequest: AVAssetResourceLoadingRequest) {
        requestList.remove(object: loadingRequest)
    }
    
    func finishLoading(loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        // fill request information
        let contentType = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, MimeType as CFString, String() as CFString)
        loadingRequest.contentInformationRequest?.contentType = String.init(describing: contentType)
        loadingRequest.contentInformationRequest?.isByteRangeAccessSupported = true
        loadingRequest.contentInformationRequest?.contentLength = (requestTask?.fileLength)!
        
        // read cache file
        let cacheLength: UInt64 = UInt64((requestTask?.cacheLength)!)
        var requestedOffset: UInt64 = UInt64((loadingRequest.dataRequest?.requestedOffset)!)
        if loadingRequest.dataRequest?.currentOffset != 0 {
            requestedOffset = UInt64((loadingRequest.dataRequest?.currentOffset)!)
        }
        let canReadLength = cacheLength - (requestedOffset - UInt64((requestTask?.requestOffset)!))
        let responseLength = min(canReadLength, UInt64(Int64((loadingRequest.dataRequest?.requestedLength)!)))
        loadingRequest.dataRequest?.respond(with: QuickCacheHandle.readTempFileData(offset: requestedOffset - UInt64((requestTask?.requestOffset)!), length: responseLength, filename: filename))
        // if cached offset > expected offset, return true
        let currentEndOffset: UInt64 = requestedOffset + canReadLength
        let requestEndOffset: UInt64 = UInt64((loadingRequest.dataRequest?.requestedOffset)!) + UInt64((loadingRequest.dataRequest?.requestedLength)!)
        if currentEndOffset > requestEndOffset {
            loadingRequest.finishLoading()
            return true
        }
        return false
    }
    
    func newTask(loadingRequest: AVAssetResourceLoadingRequest, allowCache: Bool) {
        var fileLength: Int64 = 0
        if requestTask != nil {
            fileLength += (requestTask?.fileLength)!
            requestTask?.cancel = true
        }
        requestTask = QuickSessionTask(filename: filename)
        requestTask?.requestURL = loadingRequest.request.url
        requestTask?.requestOffset = (loadingRequest.dataRequest?.requestedOffset)!
        requestTask?.allowCache = allowCache
        if fileLength > 0 {
            requestTask?.fileLength = fileLength
        }
        requestTask?.delegate = self
        requestTask?.resume()
        seekRequired = false
    }
    
    func processLoadingRequest() {
        let finishRequestList = requestList
        for loadingRequest in finishRequestList {
            if finishLoading(loadingRequest: loadingRequest) {
                requestList.remove(object: loadingRequest)
            }
        }
    }
    
    func synchronized(lock: AnyObject, closure: () -> ()) {
        objc_sync_enter(lock)
        closure()
        objc_sync_exit(lock)
    }

}

extension QuickResourceManager: AVAssetResourceLoaderDelegate {
    
    public func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool  {
        addLoadingRequest(loadingRequest: loadingRequest)
        return true
    }
    
    public func resourceLoader(_ resourceLoader: AVAssetResourceLoader, didCancel loadingRequest: AVAssetResourceLoadingRequest) {
        removeLoadingRequest(loadingRequest: loadingRequest)
    }
    
}

extension QuickResourceManager: QuickSessionTaskDelegate {
    
    public func requestTaskDidUpdateCache() {
        processLoadingRequest()
        let cacheProgress = CGFloat.init((requestTask?.cacheLength)!)/CGFloat.init((requestTask?.fileLength)! - (requestTask?.requestOffset)!)
        delegate?.resourceManagerCacheProgress!(manager: self, progress: cacheProgress)
    }
    
    public func requestTaskDidFinishedLoading() {
        delegate?.resourceManagerFinishLoading!(manager: self)
    }
    
}
