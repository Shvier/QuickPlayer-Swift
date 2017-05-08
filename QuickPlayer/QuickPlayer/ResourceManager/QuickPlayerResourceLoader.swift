//
//  QuickPlayerResourceLoader.swift
//  QuickPlayer
//
//  Created by Shvier on 06/05/2017.
//  Copyright © 2017 Shvier. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices

open class QuickPlayerResourceLoader: NSURLConnection {
    
    let bufferSize: Int64 = 1024 * 300
    
    lazy var downloaderList: Array<AVAssetResourceLoadingRequest> = {
        return Array<AVAssetResourceLoadingRequest>()
    }()
    
    public weak var delegate: QuickPlayerResourceLoaderDelegate?
    
    var downloader: QuickPlayerDownloader?
    var filename: String!

    public init(filename: String) {
        super.init()
        self.filename = filename
    }
    
    func fillInContentInformation(contentInformationRequest: AVAssetResourceLoadingContentInformationRequest) {
        let contentType = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, (downloader?.mimeType!)! as CFString, String() as CFString)
        contentInformationRequest.isByteRangeAccessSupported = true
        contentInformationRequest.contentType = String.init(describing: contentType)
        contentInformationRequest.contentLength = (downloader?.fileLength)!
    }
    
    func dealLoadingRequest(loadingRequest: AVAssetResourceLoadingRequest) {
        let interceptedURL = loadingRequest.request.url!
        let range = NSMakeRange(Int((loadingRequest.dataRequest?.currentOffset)!), LONG_MAX)
        if (downloader?.cacheLength)! > 0 {
            processDownloaderList()
        }
        
        if downloader == nil {
            downloader = QuickPlayerDownloader(filename: filename)
            downloader?.delegate = self
            downloader?.setRequestURL(requestURL: interceptedURL, requestOffset: 0)
        } else {
            if ((downloader?.requestOffset)! + Int64((downloader?.cacheLength)!) + bufferSize < Int64(range.location)) ||
                (Int64(range.location) < (downloader?.requestOffset)!) {
                downloader?.setRequestURL(requestURL: interceptedURL, requestOffset: Int64(range.location))
            }
        }
    }
    
    func processDownloaderList() {
        let finishedDownloaderList = downloaderList
        for loadingRequest in finishedDownloaderList {
            fillInContentInformation(contentInformationRequest: loadingRequest.contentInformationRequest!)
            if respondDataForRequest(dataRequest: loadingRequest.dataRequest!) {
                loadingRequest.finishLoading()
                downloaderList.remove(object: loadingRequest)
            }
        }
    }
    
    func respondDataForRequest(dataRequest: AVAssetResourceLoadingDataRequest) -> Bool {
        var startOffset = dataRequest.requestedOffset
        if dataRequest.currentOffset != 0 {
            startOffset = dataRequest.currentOffset
        }
        
        if ((downloader?.requestOffset)! + Int64((downloader?.cacheLength)!) < startOffset) ||
            (startOffset < (downloader?.requestOffset)!) {
            return false;
        }
        
        do  {
            let fileData = try NSData.init(contentsOf: URL(fileURLWithPath: QuickCacheHandle.tempFilePath(filename: filename)), options: .mappedIfSafe)
            let unreadBytes = Int64((downloader?.cacheLength)!) - startOffset - (downloader?.requestOffset)!
            let numberOfBytesToRespond: Int64 = min(Int64(dataRequest.requestedLength), unreadBytes)
            dataRequest.respond(with: fileData.subdata(with: NSMakeRange(Int(startOffset - (downloader?.requestOffset)!), Int(numberOfBytesToRespond))))
            let endOffset = startOffset + Int64(dataRequest.requestedLength)
            return ((downloader?.requestOffset)! + Int64((downloader?.cacheLength)!)) >= endOffset
        } catch (let error) {
            print("\(error)")
            return false
        }
    }
    
}

extension QuickPlayerResourceLoader: AVAssetResourceLoaderDelegate {
    
    public func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        downloaderList.append(loadingRequest)
        dealLoadingRequest(loadingRequest: loadingRequest)
        return true
    }
    
    public func resourceLoader(_ resourceLoader: AVAssetResourceLoader, didCancel loadingRequest: AVAssetResourceLoadingRequest) {
        downloaderList.remove(object: loadingRequest)
    }
    
}

extension QuickPlayerResourceLoader: QuickPlayerDownloaderDelegate {
    
    public func downloaderDidUpdateCache() {
        processDownloaderList()
        let progress: Float = Float((downloader?.cacheLength)!) / (Float((downloader?.fileLength)!) - Float((downloader?.requestOffset)!))
        delegate?.resourceLoaderCacheProgress!(progress: progress)
    }
    
    public func downloaderDidFinishedLoading() {
        delegate?.resourceLoaderFinishLoading!()
    }
    
    public func downloaderDidFailed(error: Error) {
        delegate?.resourceLoaderFailLoading!(error: error)
    }
    
}
