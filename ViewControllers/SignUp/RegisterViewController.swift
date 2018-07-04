 //
//  RegisterViewController.swift
//  GoogleFacebookLogin
//
//  Created by V kishore kumar reddy  on 1/21/18.
//  Copyright © 2018 Raju sharma. All rights reserved.
//

import UIKit

import UnderLineTextField

// MARK: List of Constants

let SCREEN_HEIGHT = UIInterfaceOrientationIsPortrait(UIApplication.shared.statusBarOrientation) ? UIScreen.main.bounds.height : UIScreen.main.bounds.width


let PASSWORD_MAX_LENGTH = 20
let MOBILE_LENGTH = 15
let FIRST_NAME_LENGTH = 30
let LAST_NAME_LENGTH = 30
let REFERRAL_LENGTH = 10
let ACCEPTABLE_CHARECTERS  = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz."
let USERNAME_ACCEPTABLE = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_@$*!%#+-^()[]{};:=|?.><~"
let MOBILE_ACCEPTABLE_CHARECTERS =  "1234567890."

class RegisterViewController: UIViewController,UITextFieldDelegate,UIScrollViewDelegate
{

    // MARK: - IBOutlets & Objects
    
    @IBOutlet weak var RefferalCodeTxt: UnderLineTextField!
    @IBOutlet weak var LastNameTxt: UnderLineTextField!
    @IBOutlet weak var Password: UnderLineTextField!
    @IBOutlet weak var EmailIdTxt: UnderLineTextField!
    @IBOutlet weak var MobileNoTxt: UnderLineTextField!
    @IBOutlet weak var FirstNameTxt: UnderLineTextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //@IBOutlet weak var RegisterTableView: UITableView!
    
    
    var firstname:String = ""
    var lastname:String = ""
    var mobileno:String = ""
    var emailId:String = ""
    var referralCode:String = ""
    var registrationType:String = ""
    var password:String = ""
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var emailcheck: Bool!
    var phonenumber: Bool!
    var validationBool:Bool!
    
    // MARK: - viewDidLoad
 
    override func viewDidLoad()
    {
        super.viewDidLoad()
   
       // RegisterTableView.delegate = self
       // RegisterTableView.dataSource = self
        
        self.title = "REGISTRATION"
        
        RefferalCodeTxt.delegate = self
        LastNameTxt.delegate = self
        Password.delegate = self
        EmailIdTxt.delegate = self
        MobileNoTxt.delegate = self
        FirstNameTxt.delegate = self
        
        firstname = FirstNameTxt.text!
        lastname = LastNameTxt.text!
        mobileno = MobileNoTxt.text!
        emailId = EmailIdTxt.text!
        referralCode = RefferalCodeTxt.text!
        password = Password.text!
        
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        //Submit Button
        
        submitBtn.layer.cornerRadius = 5
      
    }
    
    // MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.appDelegate.hideHud()

        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - didReceiveMemoryWarning
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  /*  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let hieghtcell : CGFloat!
        if  DeviceSizeConstants.IS_IPHONE5{
            hieghtcell = 530
       }else if DeviceSizeConstants.IS_IPHONE6{
            hieghtcell = 605
       }else if DeviceSizeConstants.IS_IPHONE6PLUS{
            hieghtcell = 675
       }else if DeviceSizeConstants.IS_IPHONE7{
            hieghtcell = 530
       }else{
            hieghtcell = 530
       }
        return hieghtcell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell :RegisterTableViewCell = tableView.dequeueReusableCell(withIdentifier: "RegisterTableViewCell") as! RegisterTableViewCell!
        cell.FirstNameTxt.delegate = self
        cell.LastNameTxt.delegate = self
       cell.MobileNoTxt.delegate = self
         cell.EmailIdTxt.delegate = self
        cell.RefferalCodeTxt.delegate = self
        cell.Password.delegate = self
        
        
        return cell
    }
 */
    
    // MARK: - Text field Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
        if (textField == EmailIdTxt)
        {
            scrollView.contentOffset = CGPoint(x : 0, y : 80)
        }
        if (textField == Password)
        {
            scrollView.contentOffset = CGPoint(x : 0, y : 155)
        }
        if (textField == RefferalCodeTxt)
        {
            scrollView.contentOffset = CGPoint(x : 0, y : 160)
        }
    
        
        
      /*  if textField.tag == 100 {
            firstname = textField .text!
        }
        
        else if textField.tag == 101
        {
            lastname = textField.text!
        }
        
        else if textField.tag == 102
        {
            mobileno = textField.text!
        }
        else if textField.tag == 103
        {
            emailId = textField.text!
        }
        
        else if textField.tag == 105
        {
            password = textField.text!
        }
        else if textField.tag == 106
        {
            referralCode = textField.text!
        }
    */
        
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        
       scrollView.contentOffset = CGPoint(x : 0, y : 0)
        
    
    /*   if textField.tag == 100 {
            firstname = textField .text!
        }
        else if textField.tag == 101
        {
            lastname = textField.text!
        }
            
        else if textField.tag == 102
        {
            mobileno = textField.text!
        }
        else if textField.tag == 103
        {
            emailId = textField.text!
        }
            
        else if textField.tag == 105
        {
            password = textField.text!
        }
        else if textField.tag == 106
        {
            referralCode = textField.text!
        }
     */
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - validation
    
    func validation()->Bool  {
        var check:Bool!
        check=false
        
        if (FirstNameTxt.text?.isEmpty )! || (FirstNameTxt.text == " ")
        {
              self.view.makeToast("Enter First name" as String, duration: 1.0, position: CSToastPositionCenter)
          //  Alertviewclass.showalertMethod("", strBody: "Enter First name", delegate: nil)
            check=true
            return check
        }
        if (LastNameTxt.text?.isEmpty )! || (LastNameTxt.text == " ")
        {
              self.view.makeToast("Enter last  name" as String, duration: 1.0, position: CSToastPositionCenter)
           // Alertviewclass.showalertMethod("", strBody: "Enter last  name", delegate: nil)
            check=true
            return check
            
        }
        
        if (MobileNoTxt.text?.isEmpty)! || (MobileNoTxt.text == " ") {
            self.view.makeToast("Please Enter mobile number" as String, duration: 1.0, position: CSToastPositionCenter)
            // Alertviewclass.showalertMethod("", strBody: "Please Enter valid number ", delegate: nil)
            check=true
            return check
            
        }
        else{
            emailcheck=self.myMobileNumberValidate(number:MobileNoTxt.text!)
            if emailcheck==false
            {
                self.view.makeToast("Please Enter valid phone number" as String, duration: 1.0, position: CSToastPositionCenter)
                //Alertviewclass.showalertMethod("", strBody: "Please Enter valid phone number", delegate: nil)
                check=true
                return check
                
            }
            
        }
        if (EmailIdTxt.text?.isEmpty)! ||  (EmailIdTxt.text == " ")
        {
              self.view.makeToast("Enter Email name" as String, duration: 1.0, position: CSToastPositionCenter)
            //Alertviewclass.showalertMethod("", strBody: "Enter Email name", delegate: nil)
            check=true
            return check
            
        }
        else
        {
            emailcheck=self.validateEmail(testStr:EmailIdTxt.text!)
            if emailcheck==false
            {
                  self.view.makeToast("Enter valid Email name" as String, duration: 1.0, position: CSToastPositionCenter)
             //   Alertviewclass.showalertMethod("", strBody: "Enter valid Email name", delegate: nil)
                check=true
                return check
            }
        }
        if (Password.text?.isEmpty)! || (Password.text == " ")
        {
              self.view.makeToast("Please Enter password" as String, duration: 1.0, position: CSToastPositionCenter)
           // Alertviewclass.showalertMethod("", strBody: "password must be minimum 6 digit", delegate: nil)
            check=true
            return check
            
        }
//        else{
//            emailcheck=self.passwordValidate(number:password)
//            if emailcheck==false {
//                  self.view.makeToast("Please Enter valid number" as String, duration: 0.5, position: CSToastPositionCenter)
//                Alertviewclass.showalertMethod("", strBody: "Enter valid Email name", delegate: nil)
//                check=true
//                return check
//            }
//
    //    }
      
        return check
    }
    
    // MARK: - validateEmail
    
    func validateEmail(testStr:String) -> Bool {
        print("\(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    // MARK: - myMobileNumberValidate
    
    
    func myMobileNumberValidate(number:String) -> Bool {
       // "[0-9]{10}"
        
        let numberRegEx="^[2-9][0-9]{9}$"
        let phoneTest = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        return phoneTest.evaluate(with: number)
    }
    
     // MARK: - passwordValidate
    
    func passwordValidate(number:String) -> Bool {
        let numberRegEx="[0-9]{6}"
        let phoneTest = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        return phoneTest.evaluate(with: number)
    }
    
    // MARK: - RegisterSubmitBtn_Clicked
    
    @IBAction func RegisterSubmitBtn_Clicked(_ sender: Any)
    {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.IsReachabilty! {
            validationBool=self.validation()
            if validationBool==false {
           // let auth = UserDefaults.standard.value(forKey: "user_auth_token")!
            //let token = "\(WebseviceNameConstant.StrJWT)\(auth)"
            let userlocationDict = ["post":["firstName": FirstNameTxt.text!,"lastName":LastNameTxt.text!,"mobileNo":MobileNoTxt.text!,"emailId":EmailIdTxt.text!,"referralCode":RefferalCodeTxt.text!,"registrationType":"simple" ,"password":Password.text!]]
                WebserviceHelper.sharedInstance.callPostDataWithMethod(methodName: "customer", requestDict: userlocationDict as [String : [String : Any]] , headerValue: [:], isHud: false, hudView: self.view, successBlock:
                {  response, responseStr in print(response)
                    print("\(responseStr)");
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200{
                        let message = responseStr ["message" ] as? NSString
                        if message == "success"{
                            let finalName = self.firstname + self.lastname
                            let dict = ["fullname":finalName,"social_email":self.self.emailId]
                            UserDefaults.standard.set(dict, forKey: "loginUserinfo")
                            UserDefaults.standard.synchronize()

                            let data_dict = (responseStr["user"] as! NSDictionary)
                             print("\(data_dict)");
                            let token = data_dict["token"] as! NSString
                            UserDefaults.standard.setValue(token, forKey: "user_auth_token")
                            print("\(UserDefaults.standard.value(forKey: "user_auth_token")!)")
                      self.createMenuView()
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
        }
        else{
          //  self.view.makeToast("Please check internet connection", duration: 0.5, position: CSToastPositionCenter)
            
            self.checkInternetConnection()

        }
        
    }
    
    // MARK: - createMenuView
    
    fileprivate func createMenuView() {
        DispatchQueue.main.async {
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
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
