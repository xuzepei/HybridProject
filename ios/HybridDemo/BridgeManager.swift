//
//  BridgeManager.swift
//  HybridDemo
//
//  Created by xuzepei on 2019/4/26.
//  Copyright © 2019 xuzepei. All rights reserved.
//

import UIKit
import Alamofire
import SSZipArchive
import React

@objc class BridgeManager: NSObject {

    @objc static let shared = BridgeManager()
    @objc var bridge: RCTBridge? = nil
    
    let urlString = "https://color0001.oss-cn-shenzhen.aliyuncs.com/ios/test/test.zip"
    
    override init() {
        super.init()
        
        download()
    }
    
    func download() {
        
        let zipFileName = "test.zip"
        let fileURL = URL(fileURLWithPath:
            NSTemporaryDirectory()).appendingPathComponent(zipFileName)
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            return (fileURL, [.createIntermediateDirectories,
                              .removePreviousFile])
        }
        
        let url = URL(string:urlString)
        
        Alamofire.download(
            url!,
            method: .get,
            parameters: nil,
            encoding: URLEncoding.default,
            headers: nil,
            to: destination).downloadProgress(closure: { (progress) in
                //progress closure
                print("$$$: Progress: \(zipFileName):\(progress.fractionCompleted)")
                
            }).response(completionHandler: { (DefaultDownloadResponse) in
                //here you able to access the DefaultDownloadResponse
                
                let filePath = NSTemporaryDirectory() + "/" + zipFileName
                
                SSZipArchive.unzipFile(atPath: filePath, toDestination: NSTemporaryDirectory(), progressHandler: { (entry, info, entryNumber, total) in
                    
                }, completionHandler: { (path, succeeded, error) in
                    
                    print("$$$: result:" + (succeeded ? "succeeded" : "failed"))
                    
                    if succeeded == true {
                        
                        print("$$$: upzip succeeded!!!!")
                        
                        self.loadBridge();
                        
                    } else {
                        print("$$$: upzip issue!!!!")
                    }
                    
                })
                
            })
    }
    
    func loadBridge() {
        
        let path = "\(NSTemporaryDirectory())/index.jsbundle"
        if FileManager.default.fileExists(atPath: path) == true {
            let jsCodeLocation = URL(fileURLWithPath: path)
            self.bridge = RCTBridge(bundleURL: jsCodeLocation, moduleProvider: nil, launchOptions: nil)
            
            if self.bridge != nil {
                print("$$$: bridge loaded succeffully!!!!")
            }
        }
    }

}
