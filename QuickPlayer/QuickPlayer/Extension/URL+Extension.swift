//
//  URL+Extension.swift
//  QuickPlayer
//
//  Created by Shvier on 12/04/2017.
//  Copyright © 2017 Shvier. All rights reserved.
//

import Foundation

let customScheme = "streaming"
let httpScheme = "http"
let httpsScheme = "https"

extension URL {
    func customSchemeURL() -> URL {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)
        components?.scheme = customScheme
        return (components?.url)!
    }
    
    func originalSchemeURL() -> URL {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)
        if QuickPlayerManager.sharedInstance.httpsMode {
            components?.scheme = httpsScheme
        } else {
            components?.scheme = httpScheme
        }
        return (components?.url)!
    }
}
