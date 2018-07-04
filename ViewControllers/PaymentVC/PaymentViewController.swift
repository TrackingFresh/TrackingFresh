//
//  PaymentViewController.swift
//  GoogleFacebookLogin
//
//  Created by V kishore kumar reddy  on 2/28/18.
//  Copyright © 2018 Raju sharma. All rights reserved.
//

import UIKit
import Razorpay

class PaymentViewController: UIViewController,RazorpayPaymentCompletionProtocol,UITextFieldDelegate
{
   
    //MARK: -  IBOutlets & Objects
    
    @IBOutlet weak var walletLbl: UILabel!
    var razorpay: Razorpay!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var TotPayableAmt: UILabel!
    @IBOutlet weak var TotalAmountLbl: UILabel!
    @IBOutlet weak var PromocodeTxt: UITextField!
    @IBOutlet weak var cashWalletBtn: UIButton!
    @IBOutlet weak var creditCartBtn: UIButton!
    @IBOutlet weak var cashOnDeliveryBtn: UIButton!
    
    @IBOutlet weak var coupanLbl: UILabel!
    @IBOutlet weak var discountLbl: UILabel!
    var datacheckaddressViewArrayCart = [NSDictionary]()
    var cordinateDict1 = [NSDictionary]()

    var addCartArray = [NSDictionary]()
    var RouteDetailArray : NSArray = []
    var paymentNearDetailArray : NSArray = []

    var VehicaleLatitiude1:Double!
    var VehicaleLongitude1:Double!
    var checkdatabase : Bool!
    let dbManager = DBManager()
    var totalPrize: String!
    var orderId : String!
    var finalOrderPrize: String!
    var walletamountCheck :Int = 0
    var applyPromoCode: String!
      var checkStatus : Bool!
       var alert:UIAlertController?
    var checknoVerfication : String!
    var orderPlacedDict: NSDictionary = [:]
    var checkPayemntType:String!
    var checkwallet:String!
    
    //MARK: -  viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyPromoCode = "No"
        PromocodeTxt.delegate = self
        coupanLbl.isHidden = true
        discountLbl.isHidden = true
        self.customNavigationItem(stringText: "PAYMENT DETAILS", showbackButon: false)
        WalletMAount()
        razorpay = Razorpay.initWithKey("rzp_test_kVs0tsrXki2uYm", andDelegate: self)
print(totalPrize)
        
        print(datacheckaddressViewArrayCart)
        // Do any additional setup after loading the view.
    }
    
    //MARK: -  viewWillAppear
    
    override func viewWillAppear(_ animated: Bool)  {
    super.viewWillAppear(animated)
    mobileNOverify()
    TotalAmountLbl.text = DeviceSizeConstants.rupee + totalPrize
    TotPayableAmt.text = DeviceSizeConstants.rupee + totalPrize
    self.appDelegate.hideHud()
    }
    func customNavigationItem(stringText:String ,showbackButon : Bool)  {
        
        let button : UIButton = UIButton.init(frame: CGRect(x:-10, y: 0, width: 25, height: 25))
        button.backgroundColor = UIColor.clear
        let label : UILabel
        var imageview1 :UIImageView
        button.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        button.backgroundColor = UIColor.clear
        imageview1 = UIImageView.init(frame: CGRect(x: 0, y: 5, width: 25, height: 25))
        imageview1.image = UIImage(named: "Back")
        imageview1.contentMode = UIViewContentMode.scaleAspectFill
        button.addSubview(imageview1)
        let leftbarbutton : UIBarButtonItem = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = leftbarbutton
        label = UILabel.init(frame: CGRect(x:0, y:-2, width: 150, height: 20))
        label.text = stringText
        label.textColor = UIColor.white
        label.font = UIFont.init(name: "ProximaNova-Bold", size: 16.0)
        label.textAlignment = .center
        self.navigationItem.titleView = label
    }
    
    //MARK: -  backAction
    
    @objc func backAction()
    {
          self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    //MARK: -  didReceiveMemoryWarning
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: -  cashOnDelivery
   
    @IBAction func cashOnDelivery(_ sender: UIButton)
    {
        sender.isSelected = !sender.isSelected
        if(sender.isSelected == true) {
            checkPayemntType = "COD"
        } else  {
        }
     //cashWalletBtn.isSelected = false
    creditCartBtn.isSelected = false
    }
    
    //MARK: -  creditCart
    
    @IBAction func creditCart(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if(sender.isSelected == true) {
            checkPayemntType = "creditCard"
        } else
        {
        }
        //cashWalletBtn.isSelected = false
        cashOnDeliveryBtn.isSelected = false
        
    }
    
    //MARK: -  wallet
    
    @IBAction func wallet(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        if self.walletamountCheck > 0 {
            if(sender.isSelected == true) {
                checkwallet = "wallet"
                WalletMAount()
            } else  {
                checkwallet = "wallet11"
                WalletMAount()
            }
        }
        
        
      
    }
    
    //MARK: -  WalletMAount
    
    func WalletMAount()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.IsReachabilty! {
            let auth = UserDefaults.standard.value(forKey: "user_auth_token")!
            let token = "\(WebseviceNameConstant.StrJWT)\(auth)"
            let headerDict=["Authorization": token]
            let selectedStr = "operation=" + "add"
            WebserviceHelper.sharedInstance.callMobileVerifyGetDataWithMethod(strMethodName:"userWallet/?", requestDict: selectedStr, isHud: false, hudView: self.view, value: headerDict, successBlock:
                {  response, responseStr in print(response)
                    print("\(responseStr)");
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200{
                        let paidArray = responseStr["data"] as! NSArray
                        var walletamount1 :Int = 0
                        for i in 0..<(paidArray.count){
                            let WalletDict = paidArray[i] as! NSDictionary
                            let  ammount = WalletDict["sourceAmount"] as! Int
                            walletamount1 = walletamount1 + ammount
                            self.walletamountCheck = walletamount1
                        }
                        if  self.checkwallet == "wallet"{
                            self.walletLbl.text = "Use cash from wallet[" + "0" + "]"
                            let totalCal = Int(self.totalPrize)! - Int(walletamount1)
                            self.TotalAmountLbl.text = DeviceSizeConstants.rupee + self.totalPrize
                            self.TotPayableAmt.text = DeviceSizeConstants.rupee + "\(totalCal)"
                            self.finalOrderPrize = "\(totalCal)"
                        }
                        else
                        {
                            self.walletLbl.text = "Use cash from wallet[" + "\(walletamount1) " + "]"
                            self.TotalAmountLbl.text = DeviceSizeConstants.rupee + self.self.totalPrize
                            self.TotPayableAmt.text = DeviceSizeConstants.rupee + self.totalPrize
                            self.finalOrderPrize = self.totalPrize
                        }
                     
                    }
                    else{
                        let userDict=responseStr ["user_msg" ] as! String
                        self.view.makeToast(userDict as String, duration: 0.5, position: CSToastPositionCenter)
                        
                    }
            },
                                                                              errorBlock: {error in
                                                                                // self.view.makeToast(error.d as String, duration: 0.5, position: CSToastPositionCenter)
                                                                                
            })
        }
        else
        {
           // self.view.makeToast("Please check internet connection", duration: 0.5, position: CSToastPositionCenter)
            
            self.checkInternetConnection()

        }
        
    }
    
    //MARK: -  ConfirmOrderWallet
    
    func ConfirmOrderWallet() {
        discountLbl.isHidden = true
        coupanLbl.isHidden = true
        // callActionshitWithTimer()

        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.IsReachabilty! {
            let auth = UserDefaults.standard.value(forKey: "user_auth_token")!
            let vehicleID = UserDefaults.standard.value(forKey: "VehicleID")!
            let token = "\(WebseviceNameConstant.StrJWT)\(auth)"
            let userlocationDict : Dictionary<String, Any>
            if checkwallet == "wallet"{
                if self.applyPromoCode == "Applied"
                {
                    userlocationDict = ["post":["orders":datacheckaddressViewArrayCart,"total_price":finalOrderPrize, "pickUp":UserDefaults.standard.bool(forKey: "isCheck"),"vehicleId":vehicleID,"walletAmount": self.walletamountCheck,"promoCode":self.PromocodeTxt.text]]
                }else{
                     userlocationDict = ["post":["orders":datacheckaddressViewArrayCart,"total_price":finalOrderPrize, "pickUp":UserDefaults.standard.bool(forKey: "isCheck"),"vehicleId":vehicleID,"walletAmount": self.walletamountCheck]]
                }
               
            }else {
                if self.applyPromoCode == "Applied"
                {
                    userlocationDict = ["post":["orders":datacheckaddressViewArrayCart,"total_price":finalOrderPrize, "pickUp":UserDefaults.standard.bool(forKey: "isCheck"),"vehicleId":vehicleID,"promoCode":self.PromocodeTxt.text]]
                }else{
                     userlocationDict = ["post":["orders":datacheckaddressViewArrayCart,"total_price":finalOrderPrize, "pickUp":UserDefaults.standard.bool(forKey: "isCheck"),"vehicleId":vehicleID]]
                }
             
            }
            let headerDict=["Authorization": token]
            WebserviceHelper.sharedInstance.callPostDataWithMethod(methodName: "order/add", requestDict: userlocationDict as! [String : [String : Any]] , headerValue: headerDict, isHud: false, hudView: self.view, successBlock:
                {  response, responseStr in print(response)
                    print("\(responseStr)");
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200{
                        let messageResponse = responseStr["message"]  as! [String : Any]
                        let orderIdReponse = messageResponse["_id"] as? String
                        self.orderId = orderIdReponse as! String
                        self.orderPlacedDict = messageResponse as NSDictionary
                        UserDefaults.standard.set(orderIdReponse, forKey: "OrderId")
                        UserDefaults.standard.synchronize()
                        self.applyPromoCode = "No"
                        self.UpdateOrder()

                    }
                    else{
                        let message = responseStr ["message" ] as? NSString
                        print(message ?? 0);
                        self.view.makeToast(message! as String, duration: 0.5, position: CSToastPositionCenter)
                    }
            },
                                                                   errorBlock: {error in
                                                                    
            })
            
        }
        else{
           // self.view.makeToast("Please check internet connection", duration: 0.5, position: CSToastPositionCenter)
            
            self.checkInternetConnection()
        }
        
    }
    
    //MARK: -  textFieldShouldReturn
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    //MARK: -  mobileNOverify
    
    func mobileNOverify()  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.IsReachabilty! {
            let auth = UserDefaults.standard.value(forKey: "user_auth_token")!
            let token = "\(WebseviceNameConstant.StrJWT)\(auth)"
            let headerDict=["Authorization": token]
             let customerId = UserDefaults.standard.value(forKey: "CustmerID")!
            WebserviceHelper.sharedInstance.callMobileVerifyGetDataWithMethod(strMethodName:"customer/isMobile/", requestDict: customerId as! String, isHud: false, hudView: self.view, value: headerDict, successBlock:
                {  response, responseStr in print(response)
                    print("\(responseStr)");
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200{
                        self.checkStatus = (responseStr["status"] as? Bool)!
//                        if  !self.checkStatus!  {
//                            self.callActionshitWithTimer()
//                        }
                    }
                    else{
                        let userDict=responseStr ["user_msg" ] as! String
                        self.view.makeToast(userDict as String, duration: 0.5, position: CSToastPositionCenter)
                        
                    }
            },
                                                                              errorBlock: {error in
                                                                                // self.view.makeToast(error.d as String, duration: 0.5, position: CSToastPositionCenter)
                                                                                
            })
        }
        else{
           // self.view.makeToast("Please check internet connection", duration: 0.5, position: CSToastPositionCenter)
            
            self.checkInternetConnection()
            
        }
        
    }
    
    //MARK: -  callActionshitWithTimer
    
    func callActionshitWithTimer(){
        DispatchQueue.main.async() {
            
            if(self.alert != nil){
                let when = DispatchTime.now() + 120
                DispatchQueue.main.asyncAfter(deadline: when){
                    self.alert?.dismiss(animated: true, completion: nil)
                }
            }
            
            self.alert = UIAlertController(title: "Tracking Fresh", message: "Please verify mobile no.", preferredStyle:
                UIAlertControllerStyle.alert)
            self.alert?.addTextField(configurationHandler: self.textFieldHandler)
            
            self.alert?.addAction(UIAlertAction(title: "VERIFY", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
                print("ok pressed")
                let code = self.alert?.textFields?[0].text
                self.handlePromocode(code: code!)
            }))
           
            self.present(self.alert!, animated: true, completion:nil)
        }
    }
    
    //MARK: -  textFieldHandler
    
    func textFieldHandler(textField: UITextField!) {
        if (textField) != nil {
            textField.placeholder = "Please enter your number"
        }
    }
    
    //MARK: -  handlePromocode
    
    func handlePromocode(code: String) -> Void {
        let code = self.alert?.textFields?[0].text
        print(code)
        if code == ""  {
            self.view.makeToast("Please enter your number", duration: 0.5, position: CSToastPositionCenter)
            self.alert?.dismiss(animated: false, completion: nil)
            callActionshitWithTimer()
        }else{
            SendOTPAPI(alertText: code!)
            
        }
        
    }
    
    //MARK: -   SendOTPAPI
    
    func SendOTPAPI(alertText : String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.IsReachabilty! {
            let auth = UserDefaults.standard.value(forKey: "user_auth_token")!
            let token = "\(WebseviceNameConstant.StrJWT)\(auth)"
              let customerId = UserDefaults.standard.value(forKey: "CustmerID")!
            let userlocationDict = ["post":["mobileNo":alertText,"id":customerId]]
            let headerDict=["Authorization": token]
            
            WebserviceHelper.sharedInstance.callPostDataWithMethod(methodName: "OTP/sendOtp/", requestDict:userlocationDict , headerValue: headerDict, isHud: false, hudView: self.view, successBlock:
                {  response, responseStr in print(response)
                    print("\(responseStr)");
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200{
                        self.alert?.dismiss(animated: true, completion: nil)
                        
                        let numberVerificationViewController: NumberVerificationViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NumberVerificationViewController") as! NumberVerificationViewController
                        numberVerificationViewController.mobileNo = alertText
                         let customerId = UserDefaults.standard.value(forKey: "CustmerID")!
                        numberVerificationViewController.customerID = customerId as! String
                       // self.navigationController?.pushViewController(numberVerificationViewController, animated: true)
                       self.present(numberVerificationViewController, animated: true, completion: nil)
                        
                    }
                    else{
                        let message = responseStr ["message" ] as? NSString
                        print(message ?? 0);
                        self.view.makeToast(message! as String, duration: 0.5, position: CSToastPositionCenter)
                    }
            },
                                                                   errorBlock: {error in
                                                                    
            })
        }
        else{
          //  self.view.makeToast("Please check internet connection", duration: 0.5, position: CSToastPositionCenter)
            
            self.checkInternetConnection()
        }
        
    }
    
    //MARK: -   applyPromoCode
    
    @IBAction func applyPromoCode(_ sender: Any) {
        if PromocodeTxt.text == nil || PromocodeTxt.text ==  "" {
            let alertWarning = UIAlertView(title:"TreckFresh", message: "Please Enter PromoCode!", delegate:nil, cancelButtonTitle:"OK")
            alertWarning.show()
            return
        }else{
         PromocodeTxt.resignFirstResponder()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if appDelegate.IsReachabilty! {
                let auth = UserDefaults.standard.value(forKey: "user_auth_token")!
                let token = "\(WebseviceNameConstant.StrJWT)\(auth)"
                let userlocationDict = ["post":["total":totalPrize,"promoCode": PromocodeTxt!.text]]
                let headerDict=["Authorization": token]
            WebserviceHelper.sharedInstance.callPostDataWithMethod(methodName: "promoCode/validate", requestDict: userlocationDict as [String : [String : Any]] , headerValue: headerDict, isHud: false, hudView: self.view, successBlock:
                    {  response, responseStr in print(response)
                        print("\(responseStr)");
                        let message = responseStr["message"] as? String
                        if message == "PromoCode Not Valid" || message == "PromoCode Not Found" || message == "PromoCode Is Not Applicable"{
                            let message = responseStr ["message" ] as? NSString
                            print(message ?? 0);
                            self.view.makeToast(message! as String, duration: 0.5, position: CSToastPositionCenter)
                            
                        }else{
                            self.applyPromoCode = "Applied"
                            self.discountLbl.isHidden = false
                            self.coupanLbl.isHidden = false
                            let Discount =  responseStr["discount"] as! Int
                            let totalamount = responseStr["newTotal"] as! Int
                            self.discountLbl.text =  "-" + DeviceSizeConstants.rupee + String(Discount)
                            self.TotPayableAmt.text = String(totalamount)
                            self.finalOrderPrize = String(totalamount)
                        }
                        
                        
                        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200{
                            
                        }
                        else{
                            let message = responseStr ["message" ] as? NSString
                            print(message ?? 0);
                            self.view.makeToast(message! as String, duration: 0.5, position: CSToastPositionCenter)
                        }
                },
                                                                       errorBlock: {error in
                                                                        
                })
            }
            else{
               // self.view.makeToast("Please check internet connection", duration: 0.5, position: CSToastPositionCenter)
                
                self.checkInternetConnection()
            }
            
        }
            
        
        
        
    }
    
    //MARK: -  nearrestRoute
    
    func nearrestRoute(latitiude: Double,  longitude : Double){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.IsReachabilty! {
            let auth = UserDefaults.standard.value(forKey: "user_auth_token")!
            let token = "\(WebseviceNameConstant.StrJWT)\(auth)"
            let userlocationDict = ["post":["longitude":longitude,"latitude": latitiude]]
            let headerDict=["Authorization": token]
            
            WebserviceHelper.sharedInstance.callPostDataWithMethod(methodName: "vehicleTimeTable/nearestRoute", requestDict: userlocationDict as [String : [String : Any]] , headerValue: headerDict, isHud: false, hudView: self.view, successBlock:
                {  response, responseStr in print(response)
                    print("\(responseStr)");
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200{
                        self.RouteDetailArray = responseStr ["data" ] as! NSArray
                        if self.RouteDetailArray.count>0{
                            let dict = self.RouteDetailArray[0] as! NSDictionary
                            let distDict = dict["dist"] as! NSDictionary
                            let locationDict = distDict["location"] as! NSDictionary
                            self.paymentNearDetailArray = locationDict["coordinates"] as! NSArray
                            print(self.paymentNearDetailArray)
                            if self.paymentNearDetailArray.count>0{
                                self.VehicaleLongitude1  = self.paymentNearDetailArray[0] as! Double
                                self.VehicaleLatitiude1 = self.paymentNearDetailArray[1] as! Double
                            }else{

                                return
                            }
                        }
                    }
                    else{
                        let message = responseStr ["message" ] as? NSString
                        print(message ?? 0);
                        self.view.makeToast(message! as String, duration: 0.5, position: CSToastPositionCenter)
                    }
            },
                                                                   errorBlock: {error in
                                                                    
            })
        }
        else{
           // self.view.makeToast("Please check internet connection", duration: 0.5, position: CSToastPositionCenter)
            
            self.checkInternetConnection()
        }
    }
    
    
    //MARK: -  placeOrder
    
    @IBAction func placeOrder(_ sender: Any) {
        let deliveryLatLongDcit  = UserDefaults.standard.object(forKey: "DeliveryLatLong") as?Dictionary<String,Any>
        let longitude = deliveryLatLongDcit!["longitude"] as! Double
        let latitude =  deliveryLatLongDcit!["latitude"] as! Double
        nearrestRoute(latitiude: latitude, longitude: longitude)
        DispatchQueue.main.asyncAfter(deadline: .now()+3.0, execute: {
            if  self.paymentNearDetailArray.count > 0 {
                if  !self.checkStatus! {
                    self.callActionshitWithTimer()
                }
                else{
                    if self.self.checkPayemntType == " " || self.checkPayemntType == nil {
                        let alertWarning = UIAlertView(title:"TreckFresh", message: "Select Payment Mode", delegate:nil, cancelButtonTitle:"OK")
                        alertWarning.show()
                        return
                    }
                    if self.checkPayemntType == "COD" {
                        self.ConfirmOrderWallet()
                        
                    }else if self.checkPayemntType == "Online Payment"{
                        self.showPaymentForm()
                    }
                }
            }else{
                
                let alertWarning = UIAlertView(title:"TreckFresh", message:"Sorry! We don't serve on this delivery address you have selected . Please add or change delivery address", delegate:nil, cancelButtonTitle:"OK")
                alertWarning.show()

            }
         })
       
   }
    
    //MARK: -  UpdateOrder
    
    func UpdateOrder(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.IsReachabilty! {
            let auth = UserDefaults.standard.value(forKey: "user_auth_token")!
            let token = "\(WebseviceNameConstant.StrJWT)\(auth)"
            
            let userlocationDict = ["post":["id":orderId,"status": "Pending","payment_Mode":checkPayemntType,"payment_Status":"Pending"]]
            let headerDict=["Authorization": token]
            
            WebserviceHelper.sharedInstance.callPutDataWithMethod(strMethodName: "order/update", requestDict: userlocationDict as Dictionary<String, Any>, isHud: true, hudView: self.view, value: headerDict,successBlock: { (success, response) in
                print("\(response)");
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200{
                        let message = response ["message" ] as? NSString
                        if message == "Updated Successfull!!" {
                            self.checkdatabase = self.dbManager.createDatabase()
                            var result : Bool = false
                            result = self.dbManager.deleteAllRecord()
                            if result == true {
                                UserDefaults.standard.set(0, forKey: "cartcount")
                                UserDefaults.standard.synchronize()
                            let orderCompletedViewController: OrderCompletedViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderCompletedViewController") as! OrderCompletedViewController
                            orderCompletedViewController.CompltedorderDict = self.orderPlacedDict
                            self.navigationController?.pushViewController(orderCompletedViewController, animated: true)
                            }
                        }

                    }
                    else{
                        let message = response ["message" ] as? NSString
                        if message == "Updated Successfull!!" {
                            self.checkdatabase = self.dbManager.createDatabase()
                            var result : Bool = false
                            result = self.dbManager.deleteAllRecord()
                            if result == true {
                                UserDefaults.standard.set(0, forKey: "cartcount")
                                UserDefaults.standard.synchronize()
                                let orderCompletedViewController: OrderCompletedViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderCompletedViewController") as! OrderCompletedViewController
                                orderCompletedViewController.CompltedorderDict = self.orderPlacedDict
                                self.navigationController?.pushViewController(orderCompletedViewController, animated: true)
                            }
                        }
//                        let message = response ["message" ] as? NSString
//                        print(message ?? 0);
//                        self.view.makeToast(message! as String, duration: 0.5, position: CSToastPositionCenter)
                    }
            },
                                                                   errorBlock: {error in
                                                                    
            })
        }
        else{
          //  self.view.makeToast("Please check internet connection", duration: 0.5, position: CSToastPositionCenter)
            
            self.checkInternetConnection()
            
        }
    }
    
    //MARK: -  showPaymentForm
   
    internal func showPaymentForm(){
        let loginUserInfoDict  = UserDefaults.standard.object(forKey: "loginUserinfo") as?Dictionary<String,Any>
        let emailid = loginUserInfoDict!["social_email"] as! String
        let amount = Int(totalPrize)! * 100
        let options: [String:Any] = [
            "amount" : amount,
            "description": "User Id",
            "image": "http://35.154.11.54/de9c9f22b8a8dec7da918ef79e723110.png",
            "name": "Tracking Fresh",
            "prefill": [
                "contact": "9762868180",
                "email": emailid
            ],
            "theme": [
                "color": "#F37254"
            ]
        ]
        razorpay.open(options)
    }
    
    //MARK: - RozorPay Delegate
    public func onPaymentError(_ code: Int32, description str: String){
        let alertController = UIAlertController(title: "FAILURE", message: str, preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.view.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    public func onPaymentSuccess(_ payment_id: String){
        let alertController = UIAlertController(title: "SUCCESS", message: "Payment Id \(payment_id)", preferredStyle: UIAlertControllerStyle.alert)
        let OkAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: myHandler)
        alertController.addAction(OkAction)
        self.view.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func myHandler(alert: UIAlertAction){
        ConfirmOrderWallet()
    }
    
    //MARK: -  Check Internet Connection
    
    func checkInternetConnection()
    {
        //Background Image
        
        let imageName = "bg.png"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        
        imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height : self.view.frame.size.height)
        view.addSubview(imageView)
        
        //No wifi image
        
        let imageName1 = "no-internet-white.png"
        let image1 = UIImage(named: imageName1)
        let imageView1 = UIImageView(image: image1!)
        imageView1.frame = CGRect(x: 115, y: 90, width:92 , height : 94)
        imageView1.center = CGPoint(x : UIScreen.main.bounds.size.width/2, y : 90)
        view.addSubview(imageView1)
        
        //Lable 1
        
        let label1 = UILabel(frame: CGRect(x : 120, y : 110, width : 92, height : 94))
        label1.center = CGPoint(x : UIScreen.main.bounds.size.width/2, y : imageView1.center.y + 85)
        label1.textAlignment = NSTextAlignment.center
        label1.text = "Ooops!"
        label1.textColor = UIColor.white
        label1.font = UIFont(name:"HelveticaNeue-Bold", size: 20.0)
        self.view.addSubview(label1)
        
        //Lable 2
        
        let label = UILabel(frame: CGRect(x : 16, y : 210, width : 288, height : 76))
        label.center = CGPoint(x : UIScreen.main.bounds.size.width/2, y : label1.center.y + 100)
        label.textAlignment = NSTextAlignment.center
        label.text = "No internet connection found check your connection & try again"
        label.font = UIFont(name:"HelveticaNeue", size: 18.0)
        label.textColor = UIColor.white
        label.numberOfLines = 2
        self.view.addSubview(label)
        
        
    }
    
}
