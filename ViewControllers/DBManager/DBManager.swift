//
//  DBManager.swift
//  FMDBTut
//
//  Created by Gabriel Theodoropoulos on 07/10/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

import UIKit

class DBManager: NSObject
{
    // MARK: - Objects
    
    let field_Address : String! = nil
    let field_Citylandmark : String! = nil
    let field_City : String! = nil
    let field_State : String! = nil
    let field_Zipcode : String! = nil
    let field_Country : String! = nil
    let databaseFileName = "TrackingFresh.sqlite"
    var pathToDatabase: String!
    var database: FMDatabase!
    var DatabaseProductArray = [NSDictionary]()
    var DatabaseAddressArray = [NSDictionary]()

    // MARK: - createDatabase
    
    func createDatabase() -> Bool {
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
        var created = false
        if !FileManager.default.fileExists(atPath: pathToDatabase)
        {
            database = FMDatabase(path: pathToDatabase!)
            if database != nil
            {
                // Open the database.
                if database.open()
                {
                    
                    let createTableQuery = "create table  CartTable123 (_id text, productId  text ,quantity  text, unitsOfMeasurement text  ,productName text PRIMARY KEY ,unit text,productDetails text,productImage text,brand text,selling_price text,offer text,MRP text,QuantityinStock text )"
                    
                    
                  let createTableAddress = "create table AddressTable123 (addressField text PRIMARY KEY)"
                    
                    
                    do {
                        try database.executeStatements(createTableQuery)
                        try database.executeStatements(createTableAddress)
                        created = true
                    }
                    catch {
                        print("Could not create table.")
                        print(error.localizedDescription)
                    }
                    
                    database.close()
                }
                else {
                    print("Could not open the database.")
                }
            }
        }
        
        return created
    }
    
    // MARK: - openDatabase
    
    func openDatabase() -> Bool {
        if database == nil {
            if FileManager.default.fileExists(atPath: pathToDatabase) {
                database = FMDatabase(path: pathToDatabase)
            }
        }
        
        if database != nil {
            if database.open() {
                return true
            }
        }
        
        return false
    }
    
    // MARK: - insertMovieData
    
    func insertMovieData(Dict:[String: String]) {
        if Dict.count > 0 {
            var  query = ""
            let _id = Dict["_id"]
            let  productId = Dict["productId"]
            let  quantity = Dict["quantity"]
            let  unitsOfMeasurement = Dict["unitsOfMeasurement"]
            let  productName = Dict["productName"]
             let  unit = Dict["unit"]
            let  productDetails = Dict["productDetails"]
            let  productImage = Dict["productImage"]
            let  brand = Dict["brand"]
            let  selling_price = Dict["selling_price"]
            let  offer = Dict["offer"]
            let  MRP = Dict["MRP"]
            let QuantityinStock = Dict["QuantityinStock"]
            
            
            if openDatabase() {
                query = "INSERT INTO CartTable123 (_id,productId, quantity,unitsOfMeasurement, productName, unit,productDetails,productImage,brand,selling_price,offer,MRP,QuantityinStock) VALUES ('\(_id!)','\(productId!)', '\(quantity!)', '\(unitsOfMeasurement!)', '\(productName!)', '\(unit!)','\(productDetails!)', '\(productImage!)', '\(brand!)','\(selling_price!)', '\(offer!)', '\(MRP!)','\(QuantityinStock!)');"
                
            }
            if !database.executeStatements(query) {
                print("Failed to insert initial data into the database.")
                print(database.lastError(), database.lastErrorMessage())
            }
            database.close()
        }
        }
    
    
    // MARK: - insertAdress
    
    func insertAdress(Dict:[String: String]) {
        if Dict.count > 0 {
            var  query = ""
            let addressField = Dict["addressField"]
           
            if openDatabase() {
                query = "INSERT INTO AddressTable123 (addressField) VALUES ('\(addressField!)');"
                
            }
            if !database.executeStatements(query) {
                print("Failed to insert initial data into the database.")
                print(database.lastError(), database.lastErrorMessage())
            }
            database.close()
        }
    }
    
    // MARK: - AddresssArray
    
    func AddresssArray() -> [Any] {
        if DatabaseAddressArray.count > 0  {
            DatabaseAddressArray.removeAll()
        }
        if openDatabase() {
            let query = "select * from AddressTable123 "
            do {
                print(database)
                let results = try database.executeQuery(query, withParameterDictionary: nil)
                if results == nil{
                    return DatabaseProductArray
                }
                while (results?.next())! {
                    
                    let dict = ["addressField":results?.string(forColumn: "addressField")! as Any] as [String : Any]
                    DatabaseAddressArray.append(dict as NSDictionary)
                    print(dict)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        return DatabaseAddressArray
    }
  
    // MARK: - loadAddresss
    
    func loadAddresss() -> [Any] {
        if DatabaseProductArray.count > 0  {
            DatabaseProductArray.removeAll()
        }
        if openDatabase() {
            let query = "select * from CartTable123 "
            do {
                print(database)
                let results = try database.executeQuery(query, withParameterDictionary: nil)
                if results == nil{
                   return DatabaseProductArray
                }
                while (results?.next())! {
                    
                    let dict = ["_id":results?.string(forColumn: "_id")! as Any,
                                "productId": results?.string(forColumn: "productId")! as Any,
                                "quantity":results?.string(forColumn: "quantity")! as Any,
                                "unitsOfMeasurement":results?.string(forColumn: "unitsOfMeasurement")! as Any,
                                "productName":results?.string(forColumn: "productName")! as Any,
                                "unit":results?.string(forColumn: "unit")! as Any,
                                "productDetails": results?.string(forColumn: "productDetails")! as Any,
                                "productImage":results?.string(forColumn: "productImage")! as Any,
                                "brand":results?.string(forColumn: "brand")! as Any,
                                "selling_price":results?.string(forColumn: "selling_price")! as Any,
                                "offer":" ",
                                "MRP": results?.string(forColumn: "MRP")! as Any,
                            "QuantityinStock":results?.string(forColumn: "QuantityinStock")! as Any
                    ] as [String : Any]
                    DatabaseProductArray.append(dict as NSDictionary)
                    print(dict)
                }
            }
            catch {
                print(error.localizedDescription)
            }

            database.close()
        }

        return DatabaseProductArray
    }
    
    // MARK: - deleteRecord
    
    func deleteRecord(withID : String) -> Bool {
        var deleted = false
        if openDatabase() {
             let query = "delete from CartTable123 where \("productId")=?"
           // let query = "DELETE FROM CartTable WHERE rocordID=?"
            do {
                try database.executeUpdate(query, withArgumentsIn: [withID])
                deleted = true
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        return deleted
    }

    // MARK: - deleteAllRecord
    
    func deleteAllRecord() -> Bool {
        var deleted = false
        if openDatabase() {
            let query = "delete from CartTable123"
            // let query = "DELETE FROM CartTable WHERE rocordID=?"
            do {
                try database.executeUpdate(query, withArgumentsIn:[])
                deleted = true
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        return deleted
    }


    // MARK: - deleteAddressRecord
    
    func deleteAddressRecord(withID : String) -> Bool {
        var deleted = false
        if openDatabase() {
            let query = "delete from AddressTable123 where \("addressField")=?"
            // let query = "DELETE FROM CartTable WHERE rocordID=?"
            do {
                try database.executeUpdate(query, withArgumentsIn: [withID])
                deleted = true
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        return deleted
    }
    
    // MARK: - updateAddressCart
   
    func updateAddressCart(addressField:String)-> Bool {
        var updateData = false
        if openDatabase() {
            let query = "UPDATE CartTable123 SET quantity=? WHERE productId=?"
            do {
                try database.executeUpdate(query, withArgumentsIn: [addressField])
                updateData = true
            }
            catch {
                print(error.localizedDescription)
            }
            database.close()
        }
        return updateData
    }
    
    
    
    // MARK: - updateCart

    func updateCart(productID: String,  quantity: String)-> Bool {
          var updateData = false
        if openDatabase() {
            let query = "UPDATE CartTable123 SET quantity=? WHERE productId=?"
            do {
                try database.executeUpdate(query, withArgumentsIn: [quantity,productID])
                updateData = true
            }
            catch {
                print(error.localizedDescription)
            }
            database.close()
        }
      return updateData
    }
  
}
