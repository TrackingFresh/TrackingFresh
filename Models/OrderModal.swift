//
//  OrderModal.swift
//  GoogleFacebookLogin
//
//  Created by V kishore kumar reddy  on 1/31/18.
//  Copyright © 2018 Raju sharma. All rights reserved.
//

import UIKit

class OrderModal: NSObject {
    
    var productId:String!
    var productName:String!
    var quantity: String!
    var price: String!
    //Address
    var MRP:String!
    var sub_total :String!
    var sub_total_MRP :String!
    var productImage: String!
    var unitsOfMeasurement :String!
    var productCategory:String!
    var productDescription :String!
    var selling_price :String!
    var productDetails:String!
    var brand:String!
    
    func initdata(Dict:[String: Any])
    {
        print(Dict)
         self.productId = self.validationResponsedat(stringdata:Dict["productId"] as? String as NSString!)
        self.productName = self.validationResponsedat(stringdata:Dict["productName"] as? String as NSString!)
        self.quantity = self.validationResponsedat(stringdata: String(Dict["quantity"] as! Int))
        self.price = self.validationResponsedat(stringdata: String(Dict["price"] as! Int))
         self.MRP = self.validationResponsedat(stringdata: String(Dict["MRP"] as! Int))
         self.sub_total = self.validationResponsedat(stringdata: String(Dict["sub_total"] as! Int))
         self.sub_total_MRP = self.validationResponsedat(stringdata: String(Dict["sub_total_MRP"] as! Int))
        //self.validationResponsedat(stringdata:Dict["total_price"] as? String as NSString!)
        
        if Dict["productImage"] != nil{
            self.productImage = self.validationResponsedat(stringdata:Dict["productImage"] as? String as NSString!)
        }else{
            self.productImage = ""
        }
        //self.productImage = self.validationResponsedat(stringdata:Dict["productImage"] as? String as NSString!)
        
        if Dict["unitsOfMeasurement"] != nil{
            self.unitsOfMeasurement = self.validationResponsedat(stringdata:Dict["unitsOfMeasurement"] as? String as NSString!)
        }else{
             self.unitsOfMeasurement = ""
        }
        if Dict["productCategory"] != nil{
            self.productCategory = self.validationResponsedat(stringdata:Dict["productCategory"] as? String as NSString!)
            
        }else{
            self.productCategory = ""
        }
        
        if Dict["productDescription"] != nil{
            self.productDescription = self.validationResponsedat(stringdata:Dict["productDescription"] as? String as NSString!)

        }else{
            self.productDescription = ""
        }
        if Dict["selling_price"] != nil{
            self.selling_price = self.validationResponsedat(stringdata: String(Dict["selling_price"] as! Int))

        }else{
            self.selling_price = ""
        }
        if Dict["productDetails"] != nil{
            self.productDetails = self.validationResponsedat(stringdata:Dict["productDetails"] as? String as NSString!)

        }else{
            self.productDetails = ""
        }
        if Dict["brand"] != nil{
            self.brand = self.validationResponsedat(stringdata:Dict["brand"] as? String as NSString!)

        }else{
            self.brand  = ""
        }
       
       
        //        self.pickUp = self.validationResponsedat(stringdata:Dict["pickUp"] as? String as NSString!)
        
        
       
    }
    
    
    
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
