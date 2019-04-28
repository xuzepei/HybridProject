//
//  ViewController.swift
//  HybridDemo
//
//  Created by xuzepei on 2019/4/25.
//  Copyright © 2019 xuzepei. All rights reserved.
//

import UIKit
import React
import Alamofire
import SSZipArchive

class ViewController: UIViewController {
    
    let urlString = "https://color0001.oss-cn-shenzhen.aliyuncs.com/ios/test/test.zip"
    let localTestUrl = "http://10.0.3.4:8081/index.bundle?platform=ios"
    var rootView: RCTRootView? = nil

    @IBAction func clickedHotUpdateButton(_ sender: Any) {
        
        display()
    }
    
    @IBAction func clickedTestButton(_ sender: Any) {
        
        self.rootView?.appProperties = ["title":"Hot Update!!!"
        ]
        
        RNEventManager.shared()?.callbackToRN()
        
        RNEventManager.shared()?.sendEvent(toRN: "onTestEvent", body: ["body":"This is the event body!"])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.yellow
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
                        
                        self.display()
                        
                    } else {
                        print("$$$: upzip issue!!!!")
                    }
                    
                })
                
            })
    }
    
    
    func display() {
        
        print("$$$: display");
        
        let jsCodeLocation = URL(string: localTestUrl)

        let mockData:NSDictionary = ["title":"Hot Update"
        ]
        
        #if DEBUG
            print("$$$: Current is in debug mode!!!!")
        
            if let rootView = RCTRootView(
                bundleURL: jsCodeLocation,
                moduleName: "RNSubscriptionView",
                initialProperties: mockData as [NSObject : AnyObject],
                launchOptions: nil
                ) {
                
                rootView.loadingView = UIActivityIndicatorView(style: .whiteLarge)
                
                rootView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
                rootView.center = self.view.center
                self.view.addSubview(rootView)
                self.rootView = rootView
            }
        #else
            if let rootView = RCTRootView(bridge: BridgeManager.shared.bridge, moduleName: "RNSubscriptionView", initialProperties: mockData as [NSObject : AnyObject]) {
                
                rootView.loadingView = UIActivityIndicatorView(style: .whiteLarge)
                
                rootView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
                rootView.center = self.view.center
                self.view.addSubview(rootView)
                self.rootView = rootView
            }
        #endif

    }
    
    func sendEventToRN()
    {
//        let temp = RNEventEmitter()
//        temp.sendEvent(toRN: "remove", body: ["msg":"test"])
    }

}

