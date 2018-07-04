
//  WebserviceHelper.swift
//  NeostoreSwift
//
//  Created by webwerks on 3/16/17.
//  Copyright © 2017 Webwerks. All rights reserved.
//

import UIKit
//let baseUrl:String = "http://staging.php-dev.in:8844/trainingapp/api"

class WebserviceHelper: NSObject {
    static let sharedInstance : WebserviceHelper = {
        let instance = WebserviceHelper()
        return instance
    }()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
   
    func callPutDataWithMethod(strMethodName:String,requestDict:Dictionary<String, Any>,isHud:Bool, hudView: UIView, value:Dictionary<String, Any>,successBlock:@escaping (_ response:Any,_ responseStr: Dictionary<String, Any>)->Void, errorBlock:@escaping (_ error:Any)->Void)  {
       
        DispatchQueue.main.async {
            self.appDelegate.showHudtest()
        }
        let url = URL(string: WebseviceNameConstant.BaseURL + strMethodName)
        var request = URLRequest(url: url!)
        let session = URLSession.shared
        request.httpMethod = "PUT"
        if(requestDict != nil){
            request.httpBody =  self.getParam(requestDict as NSDictionary).data(using: String.Encoding.utf8.rawValue)
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 60
        if value.count > 0{
            for (key,param) in value{
                request.addValue(param as! String, forHTTPHeaderField: key)
            }
        }
        
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            if(data != nil && error == nil){
                do {
                    let responseStr = try JSONSerialization.jsonObject(with: (data)!, options: .mutableContainers) as! Dictionary<String, Any>
                    print("responseStr\(responseStr)")
                    DispatchQueue.main.async {
                        self.appDelegate.showHudHide()
                        successBlock(response!,responseStr)
                    }
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.appDelegate.showHudHide()
                        errorBlock(error.localizedDescription)
                    }
                }
            }
            else{
                errorBlock((error?.localizedDescription)! as String)
                self.appDelegate.showHudHide()
                
            }
        })
        task.resume()
    }
    
    
    func callMobileVerifyGetDataWithMethod(strMethodName:String,requestDict:String?,isHud:Bool, hudView: UIView, value:Dictionary<String, Any>,successBlock:@escaping (_ response:Any,_ responseStr: Dictionary<String, Any>)->Void, errorBlock:@escaping (_ error:Any)->Void)  {
        DispatchQueue.main.async {
            self.appDelegate.showHudtest()
        }
        var urlString = String()
        urlString.append(WebseviceNameConstant.BaseURL)
        urlString.append(strMethodName)
        urlString.append(requestDict!)

//        if requestDict.count > 0{
//            var i = 0;
//            let keysArray = requestDict.keys
//            for  key in keysArray {
//                if i == 0{
//                    urlString.append("?\(key)=\(requestDict[key] as! String)")
//                }else{
//                    urlString.append("&\(key)=\(requestDict[key] as! String)")
//                }
//                i += 1
//            }
//        }
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
        let url = NSURL(string: urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
        print(url!)
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "GET"
        request.timeoutInterval = 60
        
        if value.count > 0{
            for (key,param) in value{
                request.addValue(param as! String, forHTTPHeaderField: key)
            }
        }
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error in
            if data != nil && error == nil{
                do {
                    //                    let res = String(data: data!, encoding: .utf8)
                    //                    print(res as Any)
                    let responseStr = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: AnyObject]
                    DispatchQueue.main.async {
                        self.appDelegate.showHudHide()
                        successBlock(response ?? "",responseStr)
                    }
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        errorBlock(error.localizedDescription)
                        self.appDelegate.showHudHide()
                        
                    }
                }
            }else
            {
                DispatchQueue.main.async {
                    self.appDelegate.showHudHide()
                    errorBlock(error?.localizedDescription ?? "")
                    print(error?.localizedDescription ?? "")
                }
            }
        })
        dataTask.resume()
    }
  
    func callGetDataWithMethod(strMethodName:String,requestDict:Dictionary<String, Any>,isHud:Bool, hudView: UIView, value:Dictionary<String, Any>,successBlock:@escaping (_ response:Any,_ responseStr: Dictionary<String, Any>)->Void, errorBlock:@escaping (_ error:Any)->Void) {
        DispatchQueue.main.async
        {
            self.appDelegate.showHudtest()
        }
        var urlString = String()
        urlString.append(WebseviceNameConstant.BaseURL)
        urlString.append(strMethodName)
        if requestDict.count > 0{
            var i = 0;
            let keysArray = requestDict.keys
            for  key in keysArray {
                if i == 0{
                    urlString.append("?\(key)=\(requestDict[key] as! String)")
                }else{
                    urlString.append("&\(key)=\(requestDict[key] as! String)")
                }
                i += 1
            }
        }
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
        let url = NSURL(string: urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
        print(url!)
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "GET"
        request.timeoutInterval = 60
        
        if value.count > 0{
            for (key,param) in value{
                request.addValue(param as! String, forHTTPHeaderField: key)
            }
        }
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error in
            if data != nil && error == nil{
                do {
//                    let res = String(data: data!, encoding: .utf8)
//                    print(res as Any)
                    let responseStr = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: AnyObject]
                    DispatchQueue.main.async {
                        self.appDelegate.showHudHide()
                        successBlock(response ?? "",responseStr)
                    }
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        errorBlock(error.localizedDescription)
                        self.appDelegate.showHudHide()

                    }
                }
            }else
            {
                DispatchQueue.main.async {
                    self.appDelegate.showHudHide()
                    errorBlock(error?.localizedDescription ?? "")
                    print(error?.localizedDescription ?? "")
                }
            }
        })
        dataTask.resume()
    }
    
    func callGoogleAPiAddress(strMethodName:String,requestDict:Dictionary<String, Any>,isHud:Bool, hudView: UIView, value:Dictionary<String, Any>,successBlock:@escaping (_ response:Any,_ responseStr: Dictionary<String, Any>)->Void, errorBlock:@escaping (_ error:Any)->Void)  {
        DispatchQueue.main.async {
            self.appDelegate.showHudtest()
        }
        var urlString = String()
        urlString.append(strMethodName)
        if requestDict.count > 0{
            var i = 0;
            let keysArray = requestDict.keys
            for  key in keysArray {
                if i == 0{
                    urlString.append("?\(key)=\(requestDict[key] as! String)")
                }else{
                    urlString.append("&\(key)=\(requestDict[key] as! String)")
                }
                i += 1
            }
        }
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
        let url = NSURL(string: urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
        print(url!)
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "GET"
        request.timeoutInterval = 60
        
        if value.count > 0{
            for (key,param) in value{
                request.addValue(param as! String, forHTTPHeaderField: key)
            }
        }
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error in
            if data != nil && error == nil{
                do {
                    //                    let res = String(data: data!, encoding: .utf8)
                    //                    print(res as Any)
                    let responseStr = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: AnyObject]
                    DispatchQueue.main.async {
                        self.appDelegate.showHudHide()
                        successBlock(response ?? "",responseStr)
                    }
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        errorBlock(error.localizedDescription)
                        self.appDelegate.showHudHide()
                        
                    }
                }
            }else
            {
                DispatchQueue.main.async {
                    self.appDelegate.showHudHide()
                    errorBlock(error?.localizedDescription ?? "")
                    print(error?.localizedDescription ?? "")
                }
            }
        })
        dataTask.resume()
    }
    func callPostDataWithMethod(methodName:String, requestDict:[String : [String : Any]] , headerValue: Dictionary<String, Any>, isHud:Bool, hudView: UIView, successBlock:@escaping (_ response:Any, _ responseStr: Dictionary<String, Any> )->Void, errorBlock:@escaping (_ error:Any)->Void)  -> Void{

        DispatchQueue.main.async {
            self.appDelegate.showHudtest()
        }
        let url = URL(string: WebseviceNameConstant.BaseURL + methodName)
        var request = URLRequest(url: url!)
        let session = URLSession.shared
        request.httpMethod = "POST"
        if(requestDict != nil){
            request.httpBody =  self.getParam(requestDict as NSDictionary).data(using: String.Encoding.utf8.rawValue)
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.timeoutInterval = 60
        if headerValue.count > 0{
            for (key,param) in headerValue{
                request.addValue(param as! String, forHTTPHeaderField: key)
            }
        }
        
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            if(data != nil && error == nil){
                do {
                    let responseStr = try JSONSerialization.jsonObject(with: (data)!, options: .mutableContainers) as! Dictionary<String, Any>
                        print("responseStr\(responseStr)")
                    DispatchQueue.main.async {
                        self.appDelegate.showHudHide()
                        successBlock(response!,responseStr)
                    }
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.appDelegate.showHudHide()
                        errorBlock(error.localizedDescription)
                    }
                }
            }
            else{
                errorBlock((error?.localizedDescription)! as String)
                self.appDelegate.showHudHide()

            }
        })
        task.resume()
    }
    
        
    func getParam(_ params: NSDictionary) -> NSString{
        var passparam : NSString!
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            let theJSONText = NSString(data: jsonData,
                                       encoding: String.Encoding.ascii.rawValue)
            passparam = theJSONText!
        } catch let error as NSError {
//            print("getParam() \(error)")
            passparam = ""
        }
//        print("getParam() \(passparam!)")
        return passparam
    }
    //Delete
    func callDeleteDataWithMethod(strMethodName:String,requestDict:String?,isHud:Bool, hudView: UIView, value:Dictionary<String, Any>,successBlock:@escaping (_ response:Any,_ responseStr: Dictionary<String, Any>)->Void, errorBlock:@escaping (_ error:Any)->Void)  {
        DispatchQueue.main.async {
            self.appDelegate.showHudtest()
        }
        var urlString = String()
        urlString.append(WebseviceNameConstant.BaseURL)
        urlString.append(strMethodName)
        urlString.append(requestDict!)
//        if requestDict.count > 0{
//            var i = 0;
//            let keysArray = requestDict.keys
//            for  key in keysArray {
//                if i == 0{
//                    urlString.append("?\(key)=\(requestDict[key] as! String)")
//                }else{
//                    urlString.append("&\(key)=\(requestDict[key] as! String)")
//                }
//                i += 1
//            }
//        }
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
        let url = NSURL(string: urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
        //        print(url!)
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "DELETE"
        request.timeoutInterval = 60
        
        if value.count > 0{
            for (key,param) in value{
                request.addValue(param as! String, forHTTPHeaderField: key)
            }
        }
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error in
            if data != nil && error == nil{
                do {
                
                    let responseStr = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: AnyObject]
                    DispatchQueue.main.async {
                        self.appDelegate.showHudHide()
                        successBlock(response ?? "",responseStr)
                    }
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        errorBlock(error.localizedDescription)
                        self.appDelegate.showHudHide()
                        
                    }
                }
            }else
            {
                DispatchQueue.main.async {
                    self.appDelegate.showHudHide()
                    errorBlock(error?.localizedDescription ?? "")
                    print(error?.localizedDescription ?? "")
                }
            }
        })
        dataTask.resume()
    }
    
}

