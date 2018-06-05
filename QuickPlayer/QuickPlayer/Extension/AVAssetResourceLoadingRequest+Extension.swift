//
//  AVAssetResourceLoadingRequest+Extension.swift
//  QuickPlayer
//
//  Created by Shvier on 2018/5/29.
//  Copyright © 2018 Shvier. All rights reserved.
//

import Foundation
import AVFoundation

extension AVAssetResourceLoadingRequest {
    
    func fillWithResponse(_ response: HTTPURLResponse) {
        self.response = response
        if self.contentInformationRequest == nil {
            return
        }
        let mimeType = response.mimeType
        self.contentInformationRequest?.isByteRangeAccessSupported = response.supportRange()
        self.contentInformationRequest?.contentType = mimeType
        self.contentInformationRequest?.contentLength = response.contentLength()
    }
    
}
