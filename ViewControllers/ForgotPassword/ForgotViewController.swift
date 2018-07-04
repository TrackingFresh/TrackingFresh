//
//  ForgotViewController.swift
//  GoogleFacebookLogin
//
//  Created by V kishore kumar reddy  on 1/17/18.
//  Copyright © 2018 Raju sharma. All rights reserved.
//

import UIKit
import UnderLineTextField

class ForgotViewController: UIViewController,UITextFieldDelegate,UIScrollViewDelegate
{
    // MARK: - IBOutlets & Objects
    
    @IBOutlet weak var EmailIdTxt: UnderLineTextField!
    @IBOutlet weak var MobileTxt: UnderLineTextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var sendBtn: UIButton!
   // @IBOutlet weak var topHeightConstraint: NSLayoutConstraint!
    let button = UIButton(type: UIButtonType.custom)
    //@IBOutlet weak var emailHeightConstraint: NSLayoutConstraint!
    //@IBOutlet weak var sendTopHeighConstrains: NSLayoutConstraint!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var emailcheck: Bool!
    var phonenumber: Bool!
    var validationBool:Bool!
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        EmailIdTxt.delegate = self
        MobileTxt.delegate = self
       
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        
        // Do any additional setup after loading the view.
    }
    
     // MARK: - addDoneButtonOnKeyboard
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(ForgotViewController.doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.MobileTxt.inputAccessoryView = doneToolbar
    }
    
    // MARK: - doneButtonAction
    
    @objc func doneButtonAction() {
        self.MobileTxt.resignFirstResponder()
    }
    
    // MARK: - textFieldDidBeginEditing
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1
        {
             self.addDoneButtonOnKeyboard()
//            NotificationCenter.default.addObserver(self, selector: #selector(ForgotViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil);
        }
        
        if (textField == MobileTxt)
        {
            scrollView.contentOffset = CGPoint(x : 0, y : 20)
        }
        if (textField == EmailIdTxt)
        {
            scrollView.contentOffset = CGPoint(x : 0, y : 100)
        }

    }
    
    // MARK: - viewWillAppear

    override func viewWillAppear(_ animated: Bool) {
     super.viewWillAppear(animated)
        self.appDelegate.hideHud()

        self.navigationController?.setNavigationBarHidden(false, animated: animated)

    }
    
    // MARK: - didReceiveMemoryWarning
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - validation
    
    func validation()->Bool  {
        var check:Bool!
        check=false
        
        if (EmailIdTxt.text == nil)  && (MobileTxt.text == "")
        {
            emailcheck = self.validateEmail(testStr:EmailIdTxt.text!)
            if emailcheck==false {
                self.view.makeToast("Please Enter valid Email namer" as String, duration: 1.0, position: CSToastPositionCenter)
                //   Alertviewclass.showalertMethod("", strBody: "Enter valid Email name", delegate: nil)
                check=true
                return check
            }
            else{
                
            }
        }
        if (MobileTxt.text == nil) && (EmailIdTxt.text == " " )
        {
            emailcheck = self.myMobileNumberValidate(number:MobileTxt.text!)
            if emailcheck==false {
                self.view.makeToast("Please Enter valid phone number" as String, duration: 1.0, position: CSToastPositionCenter)
                // Alertviewclass.showalertMethod("", strBody: "Please Enter valid phone number", delegate: nil)
                check=true
                return check
                
            }
            else{
                
            }
        }
        if (MobileTxt.text == nil) && (EmailIdTxt.text == nil ) && (MobileTxt.text == " ") && (EmailIdTxt.text == " ") {
        
         self.view.makeToast("Please Enter Atleast One field" as String, duration: 1.0, position: CSToastPositionCenter)
            
            check=true
            return check
        
    }
       return check
    }
    
    // MARK: - textFieldShouldReturn
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        textField.resignFirstResponder()
        return true
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
        let numberRegEx="^[2-9][0-9]{9}$"
        let phoneTest = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        return phoneTest.evaluate(with: number)
    }
        
    // MARK: - SendBtn_Clicked
    
    @IBAction func SendBtn_Clicked(_ sender: AnyObject)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.IsReachabilty! {
            let auth = UserDefaults.standard.value(forKey: "user_auth_token")
            let token = "\(WebseviceNameConstant.StrJWT)\(auth)"
            let userlocationDict : [String : [String : Any]]
            if MobileTxt.text == ""{
                userlocationDict = ["post":["email":EmailIdTxt?.text! as Any ]]//
            }
            else{
                userlocationDict  = ["post":["mobileNo": MobileTxt?.text! as Any ]]

            }
           
            let headerDict=["Authorization": token]
            
            WebserviceHelper.sharedInstance.callPostDataWithMethod(methodName: "customer/forgotPassword", requestDict: userlocationDict as [String : [String : Any]] , headerValue: headerDict, isHud: false, hudView: self.view, successBlock:
                {  response, responseStr in print(response)
                    print("\(responseStr)");
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200{
                        self.view.makeToast(responseStr["message"]! as! String, duration: 1.0, position: CSToastPositionCenter)
                      self.MobileTxt.text = ""
                      self.EmailIdTxt.text = ""
                        self.navigationController?.popViewController(animated: true)
                        //self.dismiss(animated: true, completion: nil)
                    }
                    else{
                        let message = responseStr ["message" ] as? NSString
                        print(message ?? 0);
                        self.view.makeToast(message! as String, duration: 1.0, position: CSToastPositionCenter)
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
