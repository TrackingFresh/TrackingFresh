//
//  NumberVerificationViewController.swift
//  GoogleFacebookLogin
//
//  Created by V kishore kumar reddy  on 1/20/18.
//  Copyright © 2018 Raju sharma. All rights reserved.
//

import UIKit

class NumberVerificationViewController: UIViewController,UITextFieldDelegate
{

    // MARK: - IBOutlets & Objects

    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var TimerMinLbl: UILabel!
    @IBOutlet weak var MobileLbl: UILabel!
    @IBOutlet weak var OTPTxt: CustomtextField!
    var mobileNo : String! = nil
      var customerID : String! = nil
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        OTPTxt.delegate = self
        self.customNavigationItem(stringText: "TRACKING FRESH", showbackButon: false)
        MobileLbl.text = mobileNo
        // Do any additional setup after loading the view.
    }
    
    // MARK: - viewWillAppear
    
    override func  viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.appDelegate.hideHud()
        
        
    }
    
    // MARK: - customNavigationItem
    
    func customNavigationItem(stringText:String ,showbackButon : Bool)  {
        
        let button : UIButton = UIButton.init(frame: CGRect(x:-10, y: 0, width: 25, height: 25))
//        button.backgroundColor = UIColor.clear
        let label : UILabel
//        var imageview1 :UIImageView
//        button.addTarget(self, action: #selector(backAction), for: .touchUpInside)
//        button.backgroundColor = UIColor.clear
//        imageview1 = UIImageView.init(frame: CGRect(x: 0, y: 5, width: 25, height: 25))
//        imageview1.image = UIImage(named: "Back")
//        imageview1.contentMode = UIViewContentMode.scaleAspectFill
//        button.addSubview(imageview1)
       // let leftbarbutton : UIBarButtonItem = UIBarButtonItem(customView: button)
     //   self.navigationItem.leftBarButtonItem = leftbarbutton
        label = UILabel.init(frame: CGRect(x:0, y:-2, width: 150, height: 20))
        label.text = stringText
        label.textColor = UIColor.white
        label.font = UIFont.init(name: "ProximaNova-Bold", size: 16.0)
        label.textAlignment = .center
        self.navigationItem.titleView = label
    }
    
    // MARK: - didReceiveMemoryWarning

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - textFieldShouldReturn
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - NumberVerfiyedBtn_Clicked
    
    @IBAction func NumberVerfiyedBtn_Clicked(_ sender: Any) {
        
        if OTPTxt.text == " " {
            self.view.makeToast("Please enter OTP", duration: 0.5, position: CSToastPositionCenter)
        }else{
            OTPMatchMethod(alertText: mobileNo)
        }
    }
    
    // MARK: - OTPMatchMethod
    
    func OTPMatchMethod(alertText : String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.IsReachabilty! {
            let auth = UserDefaults.standard.value(forKey: "user_auth_token")!
            let token = "\(WebseviceNameConstant.StrJWT)\(auth)"
            let otp1 = OTPTxt.text as! String
            
            let userlocationDict = ["post":["otp":otp1,"mobileNo":alertText,"id":customerID]]
            let headerDict=["Authorization": token]
            
            WebserviceHelper.sharedInstance.callPostDataWithMethod(methodName: "OTP/matchOtp", requestDict:userlocationDict , headerValue: headerDict, isHud: false, hudView: self.view, successBlock:
                {  response, responseStr in print(response)
                    print("\(responseStr)");
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200{
                        //self.alert?.dismiss(animated: true, completion: nil)
                       // self.createMenuView()
                       self.dismiss(animated: true, completion: nil)
                        
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
            //self.view.makeToast("Please check internet connection", duration: 0.5, position: CSToastPositionCenter)
            
            self.checkInternetConnection()

        }
        
    }
    
    // MARK: - CallMeBtn_Clicked
    
    @IBAction func CallMeBtn_Clicked(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.IsReachabilty! {
            let auth = UserDefaults.standard.value(forKey: "user_auth_token")!
            let token = "\(WebseviceNameConstant.StrJWT)\(auth)"
            let userlocationDict = ["post":["mobileNo":mobileNo]]
            let headerDict=["Authorization": token]
            
            WebserviceHelper.sharedInstance.callPostDataWithMethod(methodName: "OTP/sendVoiceOtp", requestDict:userlocationDict , headerValue: headerDict, isHud: false, hudView: self.view, successBlock:
                {  response, responseStr in print(response)
                    print("\(responseStr)");
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200{
                        //self.alert?.dismiss(animated: true, completion: nil)
                       // self.dismiss(animated: true, completion: nil)
                        
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
    
    // MARK: - createMenuView
    
    fileprivate func createMenuView() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let leftViewController = storyboard.instantiateViewController(withIdentifier: "LeftViewController") as! LeftViewController
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        UINavigationBar.appearance().tintColor = UIColor(hex:"689F38")
        leftViewController.mainViewController = nvc
        let slideMenuController = ExSlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        slideMenuController.delegate = mainViewController
        appDelegate.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        appDelegate.window?.rootViewController = slideMenuController
        appDelegate.window?.makeKeyAndVisible()
        
    }
    
    // MARK: - ResendMsgBtn_Clicked
  
    @IBAction func ResendMsgBtn_Clicked(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.IsReachabilty! {
            let auth = UserDefaults.standard.value(forKey: "user_auth_token")!
            let token = "\(WebseviceNameConstant.StrJWT)\(auth)"
            let userlocationDict = ["post":["mobileNo":mobileNo,"id":customerID]]
            let headerDict=["Authorization": token]
            
            WebserviceHelper.sharedInstance.callPostDataWithMethod(methodName: "OTP/sendOtp/", requestDict:userlocationDict , headerValue: headerDict, isHud: false, hudView: self.view, successBlock:
                {  response, responseStr in print(response)
                    print("\(responseStr)");
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
    
    // MARK: - checkInternetConnection
    
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
    
    
    
    
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
