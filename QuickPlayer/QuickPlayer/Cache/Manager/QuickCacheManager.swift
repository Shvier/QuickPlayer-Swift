//
//  QuickCacheManager.swift
//  QuickPlayer
//
//  Created by Shvier on 12/04/2017.
//  Copyright © 2017 Shvier. All rights reserved.
//

import UIKit

// default cache path: /Library/Caches/com.Shvier.QuickPlayer/xxx.mp4
// default temp file path: /Library/Caches/com.Shvier.QuickPlayer/xxx.tmp

public class QuickCacheManager: NSObject {
    
    static let fileManager = FileManager.default
    static var cachePath: String = {
        return NSHomeDirectory().appending("/Library/Caches/\(BundleIdentifier)")
    }()
    
    static open func getOrCreateCacheFile(_ fileName: String, _ fileExtension: String? = "mp4") -> (String, Bool) {
        let filePath = getCacheFilePath(fileName, fileExtension)
        let cacheFileExisted = fileManager.fileExists(atPath: filePath)
        var successed = true
        if !cacheFileExisted {
            successed = createFile(filePath)
        }
        return (filePath, successed)
    }
    
    static open func getCacheFilePath(_ fileName: String, _ fileExtension: String? = "mp4") -> String {
        return "\(cachePath)/\(fileName)/.\(fileExtension ?? "mp4")"
    }
    
    static open func createFile(_ filePath: String) -> Bool {
        let _ = getOrCreateCacheFolderPath()
        let successed = fileManager.createFile(atPath: filePath, contents: nil, attributes: nil)
        return successed
    }
    
    static open func getOrCreateCacheFolderPath() -> String {
        let isDirectory = UnsafeMutablePointer<ObjCBool>.allocate(capacity: 1)
        if !fileManager.fileExists(atPath: cachePath, isDirectory: isDirectory) {
            do {
                try fileManager.createDirectory(atPath: cachePath, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                assert(false, error.localizedDescription)
            }
        }
        return cachePath
    }
    
    static open func cacheFolderPath() -> String {
        let isDirectory = UnsafeMutablePointer<ObjCBool>.allocate(capacity: 1)
        if !fileManager.fileExists(atPath: cachePath, isDirectory: isDirectory) {
            do {
                try fileManager.createDirectory(atPath: cachePath, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                assert(false, error.localizedDescription)
            }
        }
        return cachePath
    }
    
    static open func createTempFile(filename: String) -> Bool {
        let filePath = QuickCacheManager.tempFilePath(filename: filename)
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
        let fileHandle = FileHandle(forWritingAtPath: QuickCacheManager.tempFilePath(filename: filename))
        fileHandle?.seekToEndOfFile()
        fileHandle?.write(data)
    }
    
    static open func readTempFileData(offset: UInt64, length: UInt64, filename: String) -> Data {
        let fileHandle = FileHandle(forReadingAtPath: QuickCacheManager.tempFilePath(filename: filename))
        fileHandle?.seek(toFileOffset: offset)
        return (fileHandle?.readData(ofLength: Int(length)))!
    }
    
    static open func cacheTempFile(filename: String) {
        do {
            try fileManager.copyItem(atPath: QuickCacheManager.tempFilePath(filename: filename), toPath: QuickCacheManager.cacheFilePath(filename: filename))
            print("cache file success: \(cacheFilePath)")
        } catch let error {
            print("cache file error: \(error)")
        }
    }
    
    static open func cacheFileExists(filename: String) -> String? {
        let cacheFilePath = "\(QuickCacheManager.cacheFilePath(filename: filename))"
        if fileManager.fileExists(atPath: cacheFilePath) {
            print("cache found: \(cacheFilePath)")
            return cacheFilePath
        }
        return nil
    }
    
    static open func tempFilePath(filename: String) -> String {
        return "\(QuickCacheManager.cacheFolderPath())/\(filename).tmp"
    }
    
    static open func cacheFilePath(filename: String) -> String {
        return "\(QuickCacheManager.cacheFolderPath())/\(filename)"
    }
    
    static open func clearCache() {
        do {
            try fileManager.removeItem(atPath: QuickCacheManager.cacheFolderPath())
        } catch let error {
            print("clear cache error: \(error)")
        }
    }
    
    static open func clearCacheFile(filename: String) {
        do {
            try fileManager.removeItem(atPath: QuickCacheManager.cacheFilePath(filename: filename))
        } catch let error {
            print("clear \(filename) cache error: \(error)")
        }
    }
    
    static open func clearTempFile(filename: String) {
        do {
            try fileManager.removeItem(atPath: QuickCacheManager.tempFilePath(filename: filename))
        } catch let error {
            print("clear \(filename) cache error: \(error)")
        }
    }
    
    static open func clearFile(filePath: String) {
        do {
            try fileManager.removeItem(atPath: filePath)
        } catch let error {
            print("clear \(filePath) cache error: \(error)")
        }
    }
    
}
