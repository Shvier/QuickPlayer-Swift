//
//  QuickPlayerAssetResourceLoader.swift
//  QuickPlayer
//
//  Created by Shvier on 2018/5/29.
//  Copyright © 2018 Shvier. All rights reserved.
//

import UIKit
import AVFoundation

class QuickPlayerAssetResourceLoader: NSObject {
    
    var itemCache: QuickPlayerItemCacheFile
    var pendingRequests: [AVAssetResourceLoadingRequest]
    var currentRequest: AVAssetResourceLoadingRequest?
    var currentDataRange: NSRange
    var response: HTTPURLResponse?
    var operationQueue: OperationQueue
    
    // MARK: - Constructor
    init(_ fileName: String, _ fileExtension: String? = DefaultCacheFileExtension) {
        itemCache = QuickPlayerItemCacheFile(fileName, fileExtension)
        self.pendingRequests = [AVAssetResourceLoadingRequest]()
        self.operationQueue = OperationQueue()
        self.operationQueue.maxConcurrentOperationCount = 1
        self.operationQueue.name = QuickPlayerAssetReesourceLoaderOperationQueueName
        self.currentDataRange = InvalidRange
    }
    
    // MARK: - Handle Request
    func startNextRequest() {
        if currentRequest != nil || pendingRequests.count == 0 {
            return
        }
        currentRequest = pendingRequests.first
        // handle data range
        currentDataRange = NSMakeRange(Int(currentRequest!.dataRequest!.requestedOffset), currentRequest!.dataRequest!.requestedLength)
        // handle response
        if response == nil && itemCache.responseHeader.count > 0 {
            if currentDataRange.length == Int.max {
                currentDataRange.length = Int(itemCache.fileLength) - currentDataRange.location
            }
            var responseHeader = itemCache.responseHeader!
            let supportRange = responseHeader.keys.contains(HTTPContentRangeKey)
            if supportRange && QuickPlayerSupport.validByteRange(currentDataRange) {
                responseHeader[HTTPContentRangeKey] = QuickPlayerSupport.convertNSRangeToHTTPContentRange(currentDataRange, itemCache.fileLength)
            } else {
                responseHeader.removeValue(forKey: HTTPContentRangeKey)
            }
            responseHeader[HTTPContentLengthKey] = "\(currentDataRange.length)"
            let statusCode = supportRange ? HTTPStatusCode.SupportRange : HTTPStatusCode.Successed
            response = HTTPURLResponse(url: (currentRequest?.request.url!)!, statusCode: Int(statusCode.rawValue), httpVersion: HTTPResponseVersion, headerFields: responseHeader)
            currentRequest?.fillWithResponse(response!)
        }
        startCurrentRequest()
    }
    
    func startCurrentRequest() {
        operationQueue.isSuspended = true
        if currentDataRange.length == Int.max {
            
        } else {
            var start = currentDataRange.location
            var end = NSMaxRange(currentDataRange)
            while start < end {

            }
        }
    }
    
    func cancelCurrentRequest(_ completeCurrentRequest: Bool) {
        operationQueue.cancelAllOperations()
        if completeCurrentRequest {
            guard let wrappedRequest = currentRequest else {
                return
            }
            if wrappedRequest.isFinished {
                finishCurrentRequest(NSError(domain: NSURLErrorDomain, code: NSURLErrorCancelled, userInfo: nil))
            }
        } else {
            
        }
    }
    
    func finishCurrentRequest(_ error: NSError?) {
        currentRequest?.finishLoading(with: error)
        cleanCurrentRequest()
        startNextRequest()
    }
    
    func cleanCurrentRequest() {
        if currentRequest == nil {
            return
        }
        pendingRequests.removeObject(currentRequest!)
        currentRequest = nil
        response = nil
        currentDataRange = InvalidRange
    }
    
    func addTask(_ range: NSRange, _ cached: Bool) {
        
    }
    
    // MARK: - Life Cycle
    deinit {
        operationQueue.cancelAllOperations()
    }

}

// MARK: - AVAssetResourceLoaderDelegate
extension QuickPlayerAssetResourceLoader: AVAssetResourceLoaderDelegate {
    
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        cancelCurrentRequest(true)
        pendingRequests.append(loadingRequest)
        startNextRequest()
        return true
    }
    
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, didCancel loadingRequest: AVAssetResourceLoadingRequest) {
        if currentRequest == loadingRequest {
            cancelCurrentRequest(false)
        } else {
            pendingRequests.removeObject(loadingRequest)
        }
    }
    
}
