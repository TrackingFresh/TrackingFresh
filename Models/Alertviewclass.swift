//
//  Alertviewclass.swift
//  DemoSwift
//
//  Created by webwerks on 5/9/17.
//  Copyright © 2017 webwerks. All rights reserved.
//

import UIKit

class Alertviewclass: NSObject {
    
    class func showalertMethod(_ strTitle: NSString, strBody: NSString, delegate: AnyObject?) {
        let alert: UIAlertView = UIAlertView()
        alert.message = strBody as String
        alert.title = strTitle as String
        alert.delegate = delegate
        alert.addButton(withTitle: "Ok")
        alert.show()
    }
    
    
 }
