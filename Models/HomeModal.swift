//
//  HomeModal.swift
//  GoogleFacebookLogin
//
//  Created by V kishore kumar reddy  on 2/4/18.
//  Copyright © 2018 Raju sharma. All rights reserved.
//

import UIKit

class HomeModal: NSObject {
    
    var _id:String!
    var vehicleNo:String!
    var vehicleId: String!
    var createdBy: String!
    //Address
    var createdAt:String!
   var calculated:String!
    var routeArray: NSArray! = nil
    var dict:NSDictionary!
    var userLocation:NSDictionary!
    var userLatLong: NSArray! = nil
    
    // route dict
    
//    var routeid = String!
//    
//    var endTime = String!
//    var from_lat = String!
//    var from_lng = String!
//    var fromlocation = String!
//    var geoDIct = NSDictionary!

    
    

    func initdata(Dict:[String: Any])
    {
        print(Dict)
        self._id = self.validationResponsedat(stringdata:Dict["_id"] as? String as NSString!)
        self.vehicleId = self.validationResponsedat(stringdata:Dict["vehicleId"] as? String as NSString!)
        self.vehicleNo = self.validationResponsedat(stringdata:Dict["vehicleNo"] as? String as NSString!);      self.createdAt = self.validationResponsedat(stringdata:Dict["createdAt"] as? String as NSString!)
        self.createdBy = self.validationResponsedat(stringdata:Dict["createdBy"] as? String as NSString!)
        dict = Dict["dist"] as! NSDictionary
        
        self.calculated = self.validationResponsedat(stringdata: String(describing: dict["calculated"] as! NSNumber))
        userLocation = dict["location"] as! NSDictionary
        userLatLong = userLocation["coordinates"]as! NSArray
        routeArray = Dict["routes"]as! NSArray
        
 
       
        //self.validationResponsedat(stringdata:Dict["total_price"] as? String as NSString!)
    }
    
    func validationResponsedat(stringdata:Any) -> String! {
        print( stringdata)
        print("validation")
        
        if  (stringdata as AnyObject).isKind(of: NSNull.self) {
            return ""
        }
        if (stringdata as AnyObject).isEqual(" ")
        {
            return ""
        }
        else if (stringdata as AnyObject).isEqual(nil){
            return ""
        }
        else {
            return stringdata as? String
        }
    }
}
