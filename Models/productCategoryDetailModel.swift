//
//  productCategoryDetailModel.swift
//  GoogleFacebookLogin
//
//  Created by V kishore kumar reddy  on 2/4/18.
//  Copyright © 2018 Raju sharma. All rights reserved.
//

import UIKit

class productCategoryDetailModel: NSObject {

    
    var _id:String!
    var unitsOfMeasurement:String!
    var productCategory: String!
    var cuid: String!
    //Address
    var slug:String!
    var productCategoryId :String!
    var productName :String!
    var brand: String!
    var productDescription :String!
    var productDetails:String!
    var unit :String!
    var unitsOfMeasurementId :String!
    var productId:String!
    var productImage:String!
    
    var active:String!
    var createdBy:String!
    var createdAt:String!
    var selling_price:String!
    var quantity:String!
    var MRP:String?
    var editedBy: String?
    var editedAt:String!
    var offer:String?
    var mfgDate: String?
    var expDate:String?
    var qc: String?
      var batchNo: String?
     var productImages: NSArray! = nil
    var MultipleproductImages: NSArray! = nil
 
   
    
    func initdata(Dict:[String: Any])
    {
        print(Dict)
         self._id = self.validationResponsedat(stringdata:Dict["_id"] as? String as NSString!)
         self.unitsOfMeasurement = self.validationResponsedat(stringdata:Dict["unitsOfMeasurement"] as? String as NSString!)
        self.productCategory = self.validationResponsedat(stringdata:Dict["productCategory"] as? String as NSString!)
         self.cuid = self.validationResponsedat(stringdata:Dict["cuid"] as? String as NSString!)
         self.slug = self.validationResponsedat(stringdata:Dict["slug"] as? String as NSString!)
         self.productCategoryId = self.validationResponsedat(stringdata:Dict["productCategoryId"] as? String as NSString!)
        
        self.productName = self.validationResponsedat(stringdata:Dict["productName"] as? String as NSString!)
        self.brand = self.validationResponsedat(stringdata:Dict["brand"] as? String as NSString!)
        self.productDescription = self.validationResponsedat(stringdata:Dict["productDescription"] as? String as NSString!)
        self.productDetails = self.validationResponsedat(stringdata:Dict["productDetails"] as? String as NSString!)
        self.unit = self.validationResponsedat(stringdata: String(Dict["unit"] as! Int))
        self.productName = self.validationResponsedat(stringdata:Dict["productName"] as? String as NSString!)
    
        self.unitsOfMeasurementId = self.validationResponsedat(stringdata:Dict["unitsOfMeasurementId"] as? String as NSString!)
        
        let producIdData = Dict["productId"] as! String
        self.productId =  String(producIdData) != nil ? String(producIdData) : ""
        
        self.productImage = self.validationResponsedat(stringdata:Dict["productImage"] as? String as NSString!)
         self.active = self.validationResponsedat(stringdata:Dict["active"] as? String as NSString!)
//        self.createdBy = self.validationResponsedat(stringdata:Dict["createdBy"] as? String as NSString!)
//        self.createdAt = self.validationResponsedat(stringdata:Dict["createdAt"] as? String as NSString!)
        
         self.selling_price = self.validationResponsedat(stringdata: String(Dict["selling_price"] as! Int))
         self.quantity = self.validationResponsedat(stringdata: String(Dict["quantity"] as! Int))
         self.MRP = self.validationResponsedat(stringdata: String(Dict["MRP"] as! Int))
        
        
//        self.editedBy = self.validationResponsedat(stringdata:Dict["editedBy"] as? String as NSString!)
//        self.editedAt = self.validationResponsedat(stringdata:Dict["editedAt"] as? String as NSString!)
        self.offer = self.validationResponsedat(stringdata: String(Dict["offer"] as! Int))

        if Dict["mfgDate"] != nil{
             self.mfgDate = self.validationResponsedat(stringdata:Dict["mfgDate"] as? String as NSString!)
        }else{
             self.mfgDate = ""
        }
        if Dict["expDate"] != nil{
            self.expDate = self.validationResponsedat(stringdata:Dict["expDate"] as? String as NSString!)
        }else{
          self.expDate = ""
        }
        if Dict["qc"] != nil{
            self.qc = self.validationResponsedat(stringdata:Dict["qc"] as? String as NSString!)
        }else{
           self.expDate = ""
        }
        if Dict["batchNo"] != nil{
//            self.self.batchNo = self.validationResponsedat(stringdata:Dict["batchNo"] as? String as NSString!)
        }
////        self.mfgDate = self.validationResponsedat(stringdata:Dict["mfgDate"] as? String as NSString!)
////        self.expDate = self.validationResponsedat(stringdata:Dict["expDate"] as? String as NSString!)
//        self.qc = self.validationResponsedat(stringdata:Dict["qc"] as? String as NSString!)
//
////       self.batchNo = self.validationResponsedat(stringdata: String(Dict["batchNo"] as! Int))
       
        self.productImages = Dict["productImages"]as! NSArray
        
        
    }
    
    func validationResponsedat(stringdata:Any) -> String! {
        print( stringdata)
        print("validation")
        
        
        if stringdata == nil {
            return stringdata as? String
        }
        
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
