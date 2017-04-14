//
//  QuickCacheHandle.swift
//  QuickPlayer
//
//  Created by Shvier on 12/04/2017.
//  Copyright © 2017 Shvier. All rights reserved.
//

import UIKit

// default cache path: /Library/Caches/com.Shvier.QuickPlayer/xxx.mp4
// default temp file path: /Library/Caches/com.Shvier.QuickPlayer/xxx

public class QuickCacheHandle: NSObject {
    
    static let fileManager = FileManager.default
    static let cachePath = NSHomeDirectory().appending("/Library/Caches/\(Bundle.main.bundleIdentifier!)")

    static open func createTempFile(filename: String) -> Bool {
        let filePath = QuickCacheHandle.tempFilePath(filename: filename)
        if fileManager.fileExists(atPath: filePath) {
            do {
                try fileManager.removeItem(atPath: filePath)
            } catch let error {
                print("remove temp file error: \(error)")
            }
        }
        return fileManager.createFile(atPath: filePath, contents: nil, attributes: nil)
    }
    
    static open func writeTempFile(data: Data, filename: String) {
        let fileHandle = FileHandle(forWritingAtPath: QuickCacheHandle.tempFilePath(filename: filename))
        fileHandle?.seekToEndOfFile()
        fileHandle?.write(data)
    }
    
    static open func readTempFileData(offset: UInt64, length: UInt64, filename: String) -> Data {
        let fileHandle = FileHandle(forReadingAtPath: QuickCacheHandle.tempFilePath(filename: filename))
        fileHandle?.seek(toFileOffset: offset)
        return (fileHandle?.readData(ofLength: Int(length)))!
    }
    
    static open func cacheTempFile(filename: String) {
        do {
            let cacheFilePath = "\(cacheFolderPath)/\(filename)"
            try fileManager.copyItem(atPath: QuickCacheHandle.tempFilePath(filename: filename), toPath: cacheFilePath)
            print("cache file success")
        } catch let error {
            print("cache file error: \(error)")
        }
    }
    
    static open func cacheFileExists(filename: String) -> String? {
        let cacheFilePath = "\(QuickCacheHandle.cacheFolderPath())/\(filename).mp4"
        if fileManager.fileExists(atPath: cacheFilePath) {
            print("cache found: \(cacheFilePath)")
            return cacheFilePath
        }
        return nil
    }
    
    static open func clearCache() {
        do {
            try fileManager.removeItem(atPath: QuickCacheHandle.cacheFolderPath())
        } catch let error {
            print("clear cache error: \(error)")
        }
    }
    
    static private func tempFilePath(filename: String) -> String {
        return "\(QuickCacheHandle.cacheFolderPath())/\(filename).tmp"
    }
    
    static open func cacheFolderPath() -> String {
        let isDirectory = UnsafeMutablePointer<ObjCBool>.allocate(capacity: 1)
        if !fileManager.fileExists(atPath: cachePath, isDirectory: isDirectory) {
            do {
                try fileManager.createDirectory(atPath: cachePath, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("create cache folder error: \(error)")
            }
        }
        return cachePath
    }
    
}
