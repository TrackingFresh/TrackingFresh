//
//  EditProfileViewController.swift
//  GoogleFacebookLogin
//
//  Created by V kishore kumar reddy  on 1/20/18.
//  Copyright © 2018 Raju sharma. All rights reserved.
//

import UIKit

import UnderLineTextField

import AAPopUp

class EditProfileViewController: UIViewController,UIActionSheetDelegate,UITextFieldDelegate
{
    // MARK: - IBOutlets & Objects
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var submitBTN: UIButton!
    @IBOutlet weak var emailTXT: UnderLineTextField!
    @IBOutlet weak var lastNameTXT: UnderLineTextField!
    @IBOutlet weak var nameTXT: UnderLineTextField!
    var emailcheck: Bool!
    var phonenumber: Bool!
    var validationBool:Bool!
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
         lastNameTXT.delegate = self
        nameTXT.delegate = self
         emailTXT.delegate = self
        // Do any additional setup after loading the view.
    }
    
    // MARK: - closeMethodEdit
   
    @IBAction func closeMethodEdit(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.appDelegate.hideHud()
        let loginUserInfoDict  = UserDefaults.standard.object(forKey: "loginUserinfo") as?Dictionary<String,Any>
       let Fullname = loginUserInfoDict?["fullname"] as? String
       
        let fullNameArr = Fullname?.characters.split{$0 == " "}.map(String.init)
       
        nameTXT.text = fullNameArr?[0]
        lastNameTXT.text = fullNameArr?[1]
        emailTXT.text = loginUserInfoDict?["social_email"] as? String
        
        //self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }
    
    // MARK: - textFieldShouldReturn
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // MARK: - didReceiveMemoryWarning
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     // MARK: - validateEmail
    
    func validateEmail(testStr:String) -> Bool {
        print("\(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    // MARK: - submitAction
    
    @IBAction func submitAction(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.IsReachabilty! {
            if nameTXT.text == ""{
                self.view.makeToast(" Please Enter your name", duration: 0.5, position: CSToastPositionCenter)
            }
            if lastNameTXT.text == ""{
                self.view.makeToast(" Please Enter your last name", duration: 0.5, position: CSToastPositionCenter)
            }
            if emailTXT.text == "" {
                self.view.makeToast("Please Enter your EmailId", duration: 0.5, position: CSToastPositionCenter)
            }else{
                emailcheck=self.validateEmail(testStr:emailTXT.text!)
                if emailcheck==false {
                    self.view.makeToast("Please Enter valid EmailId" as String, duration: 1.0, position: CSToastPositionCenter)
                    //   Alertviewclass.showalertMethod("", strBody: "Enter valid Email name", delegate: nil)
                   
                   
                }
            }
            
            let auth = UserDefaults.standard.value(forKey: "user_auth_token")!
            let token = "\(WebseviceNameConstant.StrJWT)\(auth)"
            let userlocationDict = ["post":["firstName": nameTXT?.text,"lastName":lastNameTXT?.text,"emailId":emailTXT?.text ]]
            let headerDict=["Authorization": token]
            
            WebserviceHelper.sharedInstance.callPutDataWithMethod(strMethodName: "customer/update", requestDict:userlocationDict as Any as! [String : [String : Any]]  , isHud: false, hudView: self.view, value: headerDict, successBlock:
                {  response, responseStr in print(response)
                    print("\(responseStr)");
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200{
                        print(response)
                        self.dismiss(animated: true, completion: nil)
                        let message = responseStr ["message" ] as? NSString
                        self.view.makeToast(message! as String, duration: 0.5, position: CSToastPositionCenter)
                        
                    }
                    else{
                        self.dismiss(animated: true, completion: nil)
                        let message = responseStr ["message" ] as? NSString
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
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
