//
//  OfferListModel.swift
//  GoogleFacebookLogin
//
//  Created by V kishore kumar reddy  on 2/4/18.
//  Copyright © 2018 Raju sharma. All rights reserved.
//

import UIKit

class OfferListModel: NSObject {

    var _id:String!
    var productId:String!
    var quantity: String!
    var unitsOfMeasurement: String!
    //Address
    var productName:String!
    var unit:String!
    var productDetails: String!
    var productImage: String!
    var brand: String!
    var selling_price:  String! 
    var offer: String!
    var MRP: String!
    
    func initdata(Dict:[String: Any])
    {
        print(Dict)
        self._id = self.validationResponsedat(stringdata:Dict["_id"] as? String as NSString!)
        self.productId = self.validationResponsedat(stringdata:Dict["productId"] as? String as NSString!)
        self.productName = self.validationResponsedat(stringdata:Dict["productName"] as? String as NSString!)
        self.quantity = self.validationResponsedat(stringdata: String(Dict["quantity"] as! Int))
        self.selling_price =  self.validationResponsedat(stringdata: String(Dict["selling_price"] as! Int))

        
        self.unit = self.validationResponsedat(stringdata: String(Dict["unit"] as! Int))
        self.productDetails = self.validationResponsedat(stringdata:Dict["productDetails"] as? String as NSString!)
        self.brand = self.validationResponsedat(stringdata:Dict["brand"] as? String as NSString!)
      self.offer = self.validationResponsedat(stringdata: String(Dict["offer"] as! Int))
        self.MRP = self.validationResponsedat(stringdata: String(Dict["MRP"] as! Int))
      
        self.productImage = self.validationResponsedat(stringdata:Dict["productImage"] as? String as NSString!)
        self.unitsOfMeasurement = self.validationResponsedat(stringdata:Dict["unitsOfMeasurement"] as? String as NSString!)}
    
    func validationResponsedat(stringdata:Any) -> String! {
        print(stringdata)
        
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
