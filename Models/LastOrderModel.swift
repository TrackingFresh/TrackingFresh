//
//  LastOrderModel.swift
//  GoogleFacebookLogin
//
//  Created by V kishore kumar reddy  on 1/29/18.
//  Copyright © 2018 Raju sharma. All rights reserved.
//

import UIKit

class LastOrderModel: NSObject {
    
    var ID:String!
    var orderNo:String!
    var total_price:String!
    var status: String!
    var createdAt: String!
    //Address
    var address_Type:String!
    var buildingName :String!
    var city :String!
    var email_Id: String!
    var flat_No :String!
    var fullName:String!
    var landmark :String!
    var mobileNo :String!
    var pincode:String!
    var state:String!
    var totalAMount :String!
    var discount :String!
    var totalprize :String!
    
  var pickUp:String!
    var active:String!
    var delivery_charge:String!
    var vehicleId:String!
    var userId:String!
    var OrderrArray: NSArray! = nil
    var dict:NSDictionary!
    var paymentStatus:String?
    var paymentMode: String?
    var BikerID:String!
    var Cancelreason: String?
    
    func initdata(Dict:[String: Any])
    {
        print(Dict)
      self.paymentStatus = self.validationResponsedat(stringdata:Dict["payment_Status"] as? String)
        self.totalprize = self.validationResponsedat(stringdata: String(Dict["total_price"] as! Int))
        
         self.totalAMount = self.validationResponsedat(stringdata: String(Dict["totalAmount"] as! Int))
      self.paymentMode = self.validationResponsedat(stringdata:Dict["payment_Mode"] as? String )
        if Dict["discount"] != nil {
            self.discount  = self.validationResponsedat(stringdata: String(Dict["discount"] as! Int))
        }else{
            self.discount = ""
        }
         if Dict["cancelReason"] != nil {
            self.Cancelreason = self.validationResponsedat(stringdata:Dict["cancelReason"] as? String )
        
        }
        self.ID = self.validationResponsedat(stringdata:Dict["_id"] as? String as NSString?)
        self.orderNo = self.validationResponsedat(stringdata:Dict["orderNo"] as? String as NSString!)
        self.total_price = self.validationResponsedat(stringdata: String(Dict["total_price"] as! Int))
            //self.validationResponsedat(stringdata:Dict["total_price"] as? String as NSString!)
        self.status = self.validationResponsedat(stringdata:Dict["status"] as? String as NSString!)
        self.createdAt = self.validationResponsedat(stringdata:Dict["createdAt"] as? String as NSString!)
        self.pickUp = self.validationResponsedat(stringdata:Dict["pickUp"])
        self.active = self.validationResponsedat(stringdata:Dict["active"] as? String as NSString!)
        self.delivery_charge = self.validationResponsedat(stringdata: String(Dict["delivery_charge"] as! Int))
        self.vehicleId = self.validationResponsedat(stringdata:Dict["vehicleId"] as? String as NSString!)
        self.userId = self.validationResponsedat(stringdata:Dict["userId"] as? String as NSString!)
        
        
         dict = Dict["address"] as! NSDictionary
        
        self.address_Type = self.validationResponsedat(stringdata:dict["address_Type"] as? String as NSString!)
        self.buildingName = self.validationResponsedat(stringdata:dict["buildingName"] as? String as NSString!)
        self.city = self.validationResponsedat(stringdata:dict["city"] as? String as NSString!)
        self.email_Id = self.validationResponsedat(stringdata:dict["email_Id"] as? String as NSString!)
        self.flat_No = self.validationResponsedat(stringdata:dict["flat_No"] as? String as NSString!)
        self.fullName = self.validationResponsedat(stringdata:dict["fullName"] as? String as NSString!)
        self.landmark = self.validationResponsedat(stringdata:dict["landmark"] as? String as NSString!)
        if (dict["mobileNo"] as? String as NSString!) as String! == nil {
            self.mobileNo  = ""
        }else{
            self.mobileNo = (dict["mobileNo"] as? String as NSString!) as String!
        }
       
        self.pincode = self.validationResponsedat(stringdata:dict["pincode"] as? String as NSString!)
         self.state = self.validationResponsedat(stringdata:dict["state"] as? String as NSString!)
         OrderrArray = Dict["orders"]as! NSArray
        print(OrderrArray)
        
        
        print(dict)
        
//        self.idProduct = self.validationResponsedat(stringdata: String(Dict["id"] as! Int))
//        self.rating = self.validationResponsedat(stringdata: String(Dict["rating"] as! Double))
        
        
}
    
    func validationResponsedat(stringdata:Any) -> String! {
        print( stringdata)
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

