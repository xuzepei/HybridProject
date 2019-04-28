//
//  RNEventManagerSwift.swift
//  HybridDemo
//
//  Created by xuzepei on 2019/4/26.
//  Copyright © 2019 xuzepei. All rights reserved.
//

import UIKit

class RNEventManagerSwift: NSObject {
    
    let shared = RNEventManagerSwift()
    
    @objc class func showAlert(_ title:String?, message:String?) {
        
        let alert = UIAlertController(title: title, message: message
            , preferredStyle: .alert)
        let action1 = UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
            print("click OK")
        })
        alert.addAction(action1)
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: {
            
        })
    }
}
