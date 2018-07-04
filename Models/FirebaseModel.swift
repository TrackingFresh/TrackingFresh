//
//  FirebaseModel.swift
//  FireBaseDemo
//
//  Created by webwerks on 2/2/18.
//  Copyright © 2018 webwerks. All rights reserved.
//

import UIKit
import Foundation

class FirebaseModel: NSObject, NSCoding {
    
        var uId: String = ""
        var userName: String = ""
        var email : String = ""
        var password : String = ""
        var prayerPoint : Int = 0
        var totalShare : Int = 0
        var totalRewardVideos : Int = 0
        var totalBonusQuestion : Int = 0
    
        
        init(userDict: NSDictionary)
        {
            if (userDict.value(forKey: "uId") != nil) {
                self.uId = userDict.value(forKey: "uId") as! String
            } else {
                self.uId = ""
            }
            
            if (userDict.value(forKey: "userName") != nil) {
                self.userName = userDict.value(forKey: "userName") as! String
            } else {
                self.userName = ""
            }
            
            if (userDict.value(forKey: "email") != nil) {
                self.email = userDict.value(forKey: "email") as! String
            } else {
                self.email = ""
            }
            
            if (userDict.value(forKey: "password") != nil) {
                self.password = userDict.value(forKey: "password") as! String
            } else {
                self.password = ""
            }
            
            if (userDict.value(forKey: "totalBonusQuestion") != nil) {
                self.totalBonusQuestion = userDict.value(forKey: "totalBonusQuestion") as! Int
            } else {
                self.totalBonusQuestion = 0
            }
               
        }
        
        func getModelData() -> Dictionary<String, Any>
        {
            var dataDict = [String: Any]()
            dataDict["uId"] = self.uId as AnyObject
            dataDict["userName"] = self.userName as AnyObject
            dataDict["email"] = self.email as AnyObject
            dataDict["password"] = self.password as AnyObject
            dataDict["prayerPoint"] = self.prayerPoint as AnyObject
            dataDict["totalBonusQuestion"] = self.totalBonusQuestion as AnyObject
            return dataDict
        }
        
        func encode(with aCoder: NSCoder){
            
            aCoder.encode( self.uId, forKey: "uId")
            aCoder.encode( self.userName, forKey: "userName")
            aCoder.encode( self.email, forKey: "email")
            aCoder.encode( self.password, forKey: "password")
            aCoder.encode( self.prayerPoint, forKey: "prayerPoint")
            aCoder.encode( self.totalBonusQuestion, forKey: "totalBonusQuestion")
            
        }
        
        required init(coder decoder: NSCoder) {
            
            self.uId = (decoder.decodeObject(forKey: "uId") as? String ?? "")!
            self.userName = (decoder.decodeObject(forKey: "userName") as? String ?? "")!
            self.email = (decoder.decodeObject(forKey: "email") as? String ?? "")!
            self.password = (decoder.decodeObject(forKey: "password") as? String ?? "")!
            self.prayerPoint = (decoder.decodeInteger(forKey: "prayerPoint") )
            self.totalRewardVideos = (decoder.decodeInteger(forKey: "totalRewardVideos") )
            self.totalBonusQuestion = (decoder.decodeInteger(forKey: "totalBonusQuestion") )
        }
  
}
