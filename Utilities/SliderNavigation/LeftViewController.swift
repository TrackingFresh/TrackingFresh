//  MycartModel.swift
//  DemoSwift
//
//  Created by webwerks on 5/19/17.
//  Copyright © 2017 Raju Sharma. All rights reserved.

import UIKit

enum LeftMenu: Int {
    case main = 0
    case MyCart
    case Tables
    case Chairs
    case Sofas
    case Cupboard
    case MyAccount
    case StoreLocation
    case MyOrders
    case Logout
}

protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: LeftMenu)
}

class LeftViewController : UIViewController, LeftMenuProtocol,UIAlertViewDelegate {
     let dbManager = DBManager()
    var checkdatabase : Bool!
    var view1: UIView!
    var customObject : EditProfileModel!
    @IBOutlet weak var balanceAmtLBL: UILabel!
    @IBOutlet weak var NameLBL: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var data1  : NSDictionary = [:] as! [String : Any] as NSDictionary
    var customerId : String = " "
    
    let cellReuseIdentifier = "cell"
    @IBOutlet weak var tableView: UITableView!
    var menus = ["Menu","My Offers", "MyCart", " Last Orders", "Refers & Earn", "TK Cash","Notification"," Settings","Reset Password","Logout","Help","Legal"]
    
     var imageSliderArray = ["menu","offers", "cart-1", "latsorder", "latsorder", "tkf_cash","notification","setting","reset_password","reset_password","reset_password","reset_password"]
   
    var mainViewController: UIViewController!
    var MyOffersViewController: UIViewController!
    var MyCartViewController: UIViewController!
    var LastOrderViewController: UIViewController!
    var ReferEarnViewController: UIViewController!
    var TkCashViewController: UIViewController!
    var NotificatonsViewController: UIViewController!
    var SettingViewController: UIViewController!
    var HelpViewController: UIViewController!
    var LegalViewController: UIViewController!
    var ProfileController: UIViewController!
    var ChangePasswordViewController: UIViewController!

    
       override func viewDidLoad() {
        super.viewDidLoad()

        balanceAmtLBL.layer.masksToBounds = true
        balanceAmtLBL.layer.cornerRadius = 10
        tableView.delegate=self
        tableView.dataSource=self
        tableView.showsVerticalScrollIndicator=false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.layer.borderWidth = 1.5
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.clipsToBounds = true
        
        
        
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
       
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        mainViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        self.mainViewController = UINavigationController(rootViewController: mainViewController)
        
        let MyOffersViewController = storyboard.instantiateViewController(withIdentifier: "MyOffersViewController") as! MyOffersViewController
        self.MyOffersViewController = UINavigationController(rootViewController: MyOffersViewController)
        
        let MyCartViewController = storyboard.instantiateViewController(withIdentifier: "MyCartViewController") as! MyCartViewController
        self.MyCartViewController = UINavigationController(rootViewController: MyCartViewController)
        
        
        mainViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        self.mainViewController = UINavigationController(rootViewController: mainViewController)
        
        
        
        let LastOrderViewController = storyboard.instantiateViewController(withIdentifier: "LastOrderViewController") as! LastOrderViewController
        self.LastOrderViewController = UINavigationController(rootViewController: LastOrderViewController)
        
        let ChangePasswordViewController = storyboard.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
        self.ChangePasswordViewController = UINavigationController(rootViewController: ChangePasswordViewController)
        
        
        let ReferEarnViewController = storyboard.instantiateViewController(withIdentifier: "ReferEarnViewController") as! ReferEarnViewController
        self.ReferEarnViewController = UINavigationController(rootViewController: ReferEarnViewController)
        
        
        mainViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        self.mainViewController = UINavigationController(rootViewController: mainViewController)
        
        let TkCashViewController = storyboard.instantiateViewController(withIdentifier: "TkCashViewController") as! TkCashViewController
        self.TkCashViewController = UINavigationController(rootViewController: TkCashViewController)
        
        
        let NotificatonsViewController = storyboard.instantiateViewController(withIdentifier: "NotificatonsViewController") as! NotificatonsViewController
        self.NotificatonsViewController = UINavigationController(rootViewController: NotificatonsViewController)
        
        SettingViewController = storyboard.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
        self.SettingViewController = UINavigationController(rootViewController: SettingViewController)
        
        let HelpViewController = storyboard.instantiateViewController(withIdentifier: "HelpViewController") as! HelpViewController
        self.HelpViewController = UINavigationController(rootViewController: HelpViewController)
        
        
        let LegalViewController = storyboard.instantiateViewController(withIdentifier: "LegalViewController") as! LegalViewController
        self.LegalViewController = UINavigationController(rootViewController: LegalViewController)
        
        
        let ProfileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        self.ProfileController = UINavigationController(rootViewController: ProfileViewController)
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.data1 = [:]
        self.profileWebService()
    }
    
//   override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//    self.appDelegate.hideHud()
//
//    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.layoutIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }
    
    

    
    @IBAction func EditProfilreBtn_Clicked(_ sender: Any) {
        self.slideMenuController()?.changeMainViewController(self.ProfileController, close: true)
    }
    func changeViewController(_ menu: LeftMenu) {
//        switch menu {
////        case .main:
////            self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
////        case .swift:
////            self.slideMenuController()?.changeMainViewController(self.swiftViewController, close: true)
////        case .java:
////            self.slideMenuController()?.changeMainViewController(self.javaViewController, close: true)
////        case .go:
////            self.slideMenuController()?.changeMainViewController(self.goViewController, close: true)
////        case .nonMenu:
////            self.slideMenuController()?.changeMainViewController(self.nonMenuViewController, close: true)
//        }
    }
    
//    func uploadImage(imageUrl:String!){
//        if self.appDelegate.IsReachabilty! {
//            let auth = UserDefaults.standard.value(forKey: "user_auth_token")!
//            let token = "\(WebseviceNameConstant.StrJWT)\(auth)"
//            let userlocationDict = ["post":["FBT":imageUrl]]
//            let headerDict=["Authorization": token]
//            
//            WebserviceHelper.sharedInstance.callPutDataWithMethod(strMethodName: "customer/fbt", requestDict: userlocationDict as Dictionary<String, Any>, isHud: true, hudView: self.view, value: headerDict,successBlock: { (success, response) in
//                print("\(response)");
//                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200{
//
//                }
//                else{
//                    
//                }
//            },
//                        errorBlock: {error in
//                                                                    
//            })
//        }
//        else{
//            print("No internet")
//            
//        }
//    }
//    
    
    
    
    func profileWebService() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.IsReachabilty! {
            let auth = UserDefaults.standard.value(forKey: "user_auth_token")!
            let token = "\(WebseviceNameConstant.StrJWT)\(auth)"
            let dict = ["post":["strange": "boom"]]
            let headerDict=["Authorization": token]
        
            WebserviceHelper.sharedInstance.callPostDataWithMethod(methodName: "customer/profile", requestDict: dict  , headerValue: headerDict, isHud: false, hudView: self.view, successBlock:
                {  response, responseStr in print(response)
                    print("\(responseStr)");
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200{
                        self.data1 = responseStr ["data" ] as! NSDictionary as! [String : Any] as NSDictionary
                        
                        self.customerId = self.data1["_id"] as! String
                        UserDefaults.standard.set(self.customerId, forKey: "CustmerID")
                        UserDefaults.standard.synchronize()
                        let userDefaults = UserDefaults.standard
                        let firstName  = self.data1["firstName"] as! String
                        let lastname =  self.data1["lastName"] as! String
                        let mobileno : String!
                        if self.data1["mobileNo"]as? String != nil{
                            mobileno =  self.data1["mobileNo"] as! String
                        }else{
                            mobileno = "-"
                        }
                        
                        // let mobileno =  self.data1["mobileNo"] as! Float
                        let finalName = firstName + " " + lastname
                        let dict = ["fullname":finalName,"social_email":self.data1["emailId"] as? String,"Mobileno":mobileno]
                        UserDefaults.standard.set(dict, forKey: "loginUserinfo")
                        UserDefaults.standard.synchronize()
                        userDefaults.set(self.data1, forKey: "UserProfileDic")
                        userDefaults.set(self.data1, forKey: "UserName")
                        let Refferalcode = self.data1["referralCode"] as? String
                        userDefaults.set(Refferalcode, forKey: "Refferalcode")
                        
                        self.NameLBL.text = self.data1["firstName"] as? String
                        let  wallet = self.data1["walletAmount"] as? Int
                        self.balanceAmtLBL.text = DeviceSizeConstants.rupee + "\(wallet ?? 0)"
                        let checkImage : String!
                        checkImage = self.data1["registrationType"] as? String
                        if checkImage == "simple"{
                            let profilepic1 = self.data1["profileImage"] as? String
                            if (profilepic1 == "" || profilepic1 == nil){
                                
                            }else{
                                //self.profileImage.image = nil
                                UserDefaults.standard.set(profilepic1, forKey: "profile_pic")
                                UserDefaults.standard.synchronize()
                                DispatchQueue.main.async {
                                    
//                                    let url = URL(string: profilepic1!)
//                                    let data = try? Data(contentsOf: url!)
//
//                                    if let imageData = data {
//                                        let image1 = UIImage(data: imageData)
//                                        self.profileImage.image = image1
//                                    }
                                    
                                    self.profileImage.sd_setImage(with: URL(string:(profilepic1)!), placeholderImage: UIImage(named: " "))
                                }
                          
                            }
                            
                        }else if checkImage == "google"{
                            let googleURl = UserDefaults.standard.value(forKey: "profile_pic")
                            if (googleURl == nil){
                            }else{
                                self.profileImage.sd_setImage(with: URL(string:(googleURl)! as! String), placeholderImage: UIImage(named: " "))
                            }
                        }else{
//                            let facebookUrl = UserDefaults.standard.value(forKey: "profile_pic")
//                            if (facebookUrl == nil){
//                            }else{
//                                self.profileImage.sd_setImage(with: URL(string:(facebookUrl)! as! String), placeholderImage: UIImage(named: " "))
//                            }
                        }
                        
                       
//                        self.balanceAmtLBL.text = self.customObject.walletAmount
                        
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
            
        // self.checkInternetConnection()
            
            
//            self.view.makeToast(message! as String, duration: 0.5, position: CSToastPositionCenter)

        }
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int){
        if buttonIndex == 1 {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
             checkdatabase=dbManager.createDatabase()
            var result : Bool = false
            result = dbManager.deleteAllRecord()
            if result == true {
                DispatchQueue.main.async {
                appDelegate.label?.text = "0"
                    self.appDelegate.flag = "map"
                    UserDefaults.standard.set(self.appDelegate.flag, forKey: "menu")
                    UserDefaults.standard.synchronize()
            }
            }
            UserDefaults.standard.set(" ", forKey: "profile_pic")
            UserDefaults.standard.synchronize()
            UserDefaults.standard.set("logoutSucessFully", forKey: "doneLogin")
            UserDefaults.standard.set("", forKey: "CustmerID")
            UserDefaults.standard.synchronize()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let signInViewController = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
            let nvc: UINavigationController = UINavigationController(rootViewController: signInViewController)
            appDelegate.window?.rootViewController = nvc
            appDelegate.window?.makeKeyAndVisible()
            
        }
    }
    
}

//Profile data

extension LeftViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 61
    }
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//
//        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
//        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
//        label.center = CGPoint(x: 160, y: 285)
//        label.backgroundColor = UIColor.yellow
//        label.textAlignment = .center
//        label.text = "Designed By: Dzyris Infotech Pvt.Ltd "
//        label.textColor = CommonMethod.hexStringToUIColor(hex:"#8dc33b")
//        footerView.backgroundColor = UIColor.blue
//        footerView.addSubview(label)
//        return footerView
//    }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 40
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            if indexPath.row==0{
                self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
                self.appDelegate.showCustomLabelONmap(time: "10 min away")
                self.appDelegate.flag = "menu"
                UserDefaults.standard.set(self.appDelegate.flag, forKey: "menu")
                UserDefaults.standard.synchronize()
                //return;
            }
            self.appDelegate.hideHud()
            if indexPath.row==1{
                self.slideMenuController()?.changeMainViewController(self.MyOffersViewController, close: true)
                
            }
            if indexPath.row==2  {
                self.slideMenuController()?.changeMainViewController(self.MyCartViewController, close: true)
                
            }
            if indexPath.row == 3{
                self.slideMenuController()?.changeMainViewController(self.LastOrderViewController, close: true)
            }
            if indexPath.row == 4
            {
                self.slideMenuController()?.changeMainViewController(self.ReferEarnViewController, close: true)
            }
            if indexPath.row == 5
            {
                self.slideMenuController()?.changeMainViewController(self.TkCashViewController, close: true)
            }
            if indexPath.row == 6
            {
                self.slideMenuController()?.changeMainViewController(self.NotificatonsViewController, close: true)
            }
            if indexPath.row == 7
            {
                self.slideMenuController()?.changeMainViewController(self.SettingViewController, close: true)
            }
            
            if indexPath.row == 8
            {
                self.slideMenuController()?.changeMainViewController(self.ChangePasswordViewController, close: true)
            }
            if indexPath.row == 9
            {
                self.slideMenuController()?.closeLeft()
                DispatchQueue.main.async() {
                    let alertWarning: UIAlertView = UIAlertView(title: "TrackFresh", message:"Do you want to logout ?",delegate: self, cancelButtonTitle: "No", otherButtonTitles: "Yes")
                    alertWarning.delegate = self
                    alertWarning.show()
                }
                
            }
            if indexPath.row == 10
            {
                self.slideMenuController()?.changeMainViewController(self.NotificatonsViewController, close: true)
            }
            if indexPath.row == 11
            {
                self.slideMenuController()?.changeMainViewController(self.NotificatonsViewController, close: true)
            }
        }
        
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tableView == scrollView {
            
        }
    }
}
//



extension LeftViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.appDelegate.hideHud()
        let ceil = tableView.dequeueReusableCell(withIdentifier: "BaseTableViewCell", for: indexPath) as! BaseTableViewCell
        ceil.layoutMargins = UIEdgeInsets.zero
        ceil.cellImageViewLeft.image=UIImage(named: imageSliderArray[indexPath.item])
        ceil.cellLBLeft.text = menus[indexPath.row]
        return ceil
    }
    
  /*  func checkInternetConnection()
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
        imageView1.frame = CGRect(x: 95, y: 100, width:100 , height : 100)
        imageView1.center = CGPoint(x : UIScreen.main.bounds.size.width/2, y : 90)
        view.addSubview(imageView1)
        
        //Lable 1
        
        let label1 = UILabel(frame: CGRect(x : 105, y : 200, width : 92, height : 94))
        label1.center = CGPoint(x : UIScreen.main.bounds.size.width/2, y : imageView1.center.y + 120)
        label1.textAlignment = NSTextAlignment.center
        label1.text = "Ooops!"
        label1.textColor = UIColor.white
        label1.font = UIFont(name:"HelveticaNeue-Bold", size: 20.0)
        self.view.addSubview(label1)
        
        //Lable 2
        
        let label = UILabel(frame: CGRect(x : 0, y : 250, width : 230, height : 76))
        label.center = CGPoint(x : 0, y : label1.center.y + 150)
        label.textAlignment = NSTextAlignment.center
        label.text = "No internet connection found check your connection & try again"
        label.font = UIFont(name:"HelveticaNeue", size: 18.0)
        label.textColor = UIColor.white
        label.numberOfLines = 2
        self.view.addSubview(label)
        
        
    }
 */
    
    
    
    
}
