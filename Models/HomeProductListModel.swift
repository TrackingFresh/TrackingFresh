//
//  HomeProductListModel.swift
//  GoogleFacebookLogin
//
//  Created by V kishore kumar reddy  on 2/4/18.
//  Copyright © 2018 Raju sharma. All rights reserved.
//

import UIKit

class HomeProductListModel: NSObject {
    var _id:String?
    var cuid:String?
    var slug: String?
    var categoryName: String?
    //Address
    var categoryImage:String?
    var active :String?
    var createdBy :String?
    var createdAt: String?
    var editedBy :String?
    var editedAt:String?
    
    func initdata(Dict:[String: Any])
    {
        self._id = self.validationResponsedat(stringdata:Dict["_id"] as? String as NSString!)
        self.cuid = self.validationResponsedat(stringdata:Dict["cuid"] as? String as NSString!)
        //self.validationResponsedat(stringdata:Dict["total_price"] as? String as NSString!)
        self.slug = self.validationResponsedat(stringdata:Dict["slug"] as? String as NSString!)
        self.active = self.validationResponsedat(stringdata:Dict["active"] as? String as NSString!)
        
        //        self.pickUp = self.validationResponsedat(stringdata:Dict["pickUp"] as? String as NSString!)
        self.categoryName = self.validationResponsedat(stringdata:Dict["categoryName"] as? String as NSString!)
        self.categoryImage = self.validationResponsedat(stringdata:Dict["categoryImage"] as? String as NSString!)
        
        self.createdBy = self.validationResponsedat(stringdata:Dict["createdBy"] as? String as NSString!)
        self.createdAt = self.validationResponsedat(stringdata:Dict["createdAt"] as? String as NSString!)
       // self.editedBy = self.validationResponsedat(stringdata:Dict[" editedBy"] as? String as NSString!)
//        self.editedAt = self.validationResponsedat(stringdata:Dict["editedAt"] as? String as NSString!)
    }
    
    
    func validationResponsedat(stringdata:Any) -> String! {
        print( stringdata)
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
