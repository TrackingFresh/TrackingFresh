//
//  EditProfileModel.swift
//  GoogleFacebookLogin
//
//  Created by V kishore kumar reddy  on 1/29/18.
//  Copyright © 2018 Raju sharma. All rights reserved.
//

import UIKit

class EditProfileModel: NSObject {
    var firstName: String!
    var lastName: String!
    var mobileNo : String!
    var emailId : String!
    var profileImage : String!
    var walletAmount : String!
   
    func initdata(userDict: [String: Any]) {
        if userDict.count>0 {
            self.firstName = self.validationResponsedat(stringdata:userDict["firstName"] as? String as NSString!)
            self.lastName = self.validationResponsedat(stringdata:userDict["lastName"] as? String as NSString!)
            self.emailId = self.validationResponsedat(stringdata:userDict["emailId"] as? String as NSString!)
//            self.mobileNo = self.validationResponsedat(NSNumber.init( value: Int32("mobileNo")!))
//            self.profileImage = self.validationResponsedat(stringdata:userDict["profileImage"] as? String as NSString!)
//            self.walletAmount = self.validationResponsedat(stringdata:userDict["walletAmount"] as! Int)
            
        }
    }
    
     func validationResponsedat(stringdata:Any) -> String! {
        print( stringdata)
        print("validation")
        
        if (stringdata as AnyObject).isEqual(nil){
            return ""
        }
        if  (stringdata as AnyObject).isKind(of: NSNull.self) {
            return ""
        }
        if (stringdata as AnyObject).isEqual(" ")
        {
            return ""
        }
        else {
            return stringdata as? String
        }
    }
    }


