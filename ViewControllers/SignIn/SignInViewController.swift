//
//  SignInViewController.swift
//  GoogleFacebookLogin
//
//  Created by V kishore kumar reddy  on 1/20/18.
//  Copyright © 2018 Raju sharma. All rights reserved.
//

import UIKit

import GoogleSignIn
import FBSDKLoginKit
import FBSDKCoreKit
import FirebaseAuth
import FirebaseDatabase
import UnderLineTextField

class SignInViewController: UIViewController,GIDSignInDelegate,GIDSignInUIDelegate,UITextFieldDelegate
{

    // MARK: -  IBOutlets & Objects
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var passwordLBL: UnderLineTextField!
    @IBOutlet weak var phoneNumberLBL: UnderLineTextField!
   // @IBOutlet weak var leadingwidthContraint: NSLayoutConstraint!
     var firebaseRef:DatabaseReference!
    
    var emailcheck: Bool!
    var phonenumber: Bool!
    var validationBool:Bool!
    
    @IBOutlet var forgotPasswordBtn: UIButton!
    
    @IBOutlet var signUpBtn: UIButton!
    
    var attrs = [
        NSAttributedStringKey.font : UIFont(name: "HelveticaNeue-Bold", size: 18) ?? "font name",
        NSAttributedStringKey.foregroundColor : UIColor.white,
        NSAttributedStringKey.underlineStyle : 1] as [NSAttributedStringKey : Any]
    
    var attributedString = NSMutableAttributedString(string:"")
    
    var attrs1 = [
        NSAttributedStringKey.font : UIFont(name: "HelveticaNeue-Bold", size: 16) ?? "font name",
        NSAttributedStringKey.foregroundColor : UIColor.white,
        NSAttributedStringKey.underlineStyle : 1] as [NSAttributedStringKey : Any]
    
    var attributedString1 = NSMutableAttributedString(string:"")
    
    
    // MARK: -  viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firebaseRef = Database.database().reference()
        phoneNumberLBL.delegate = self
        passwordLBL.delegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        //Forgot Password Button
        
        let buttonTitleStr = NSMutableAttributedString(string:"Forgot Password?", attributes:attrs)
        attributedString.append(buttonTitleStr)
        forgotPasswordBtn.setAttributedTitle(attributedString, for: .normal)
        
        
        //SignUp Button
        
        let buttonTitleStr1 = NSMutableAttributedString(string:"SignUp", attributes:attrs1)
        attributedString1.append(buttonTitleStr1)
        signUpBtn.setAttributedTitle(attributedString1, for: .normal)
        
    
    
        // Do any additional setup after loading the view, typically from a nib.
}
   
    // MARK: -  viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.appDelegate.hideHud()
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        //self.setUpContraintWidth()
    }
    
    // MARK: -  setUpContraintWidth
    
    func setUpContraintWidth(){
        if DeviceSizeConstants.IS_IPHONE5 {
           // leadingwidthContraint.constant = 44
        }else if DeviceSizeConstants.IS_IPHONE6{
            //leadingwidthContraint.constant = 74
        }else if DeviceSizeConstants.IS_IPHONE6PLUS {
           // leadingwidthContraint.constant = 44
        }else if DeviceSizeConstants.IS_IPHONE7{
           // leadingwidthContraint.constant = 44
        }else if DeviceSizeConstants.IS_IPHONEX{
           // leadingwidthContraint.constant = 44
        }
        
    }
    
    // MARK: -  facebookCheckLogin
    
   @IBAction func facebookCheckLogin(_ sender: Any) {
    
    let loginManager = FBSDKLoginManager()
    loginManager.loginBehavior = FBSDKLoginBehavior.web
    loginManager.logOut()
    
    loginManager.logIn(withReadPermissions: ["public_profile","email"], from: self) { (loginResult:FBSDKLoginManagerLoginResult?, error:Error?) in
        
        if (error != nil) {
            print("Error")
        }
        else if (loginResult?.isCancelled)!{
            print("Cancelled")
        }
        else {
            self.fetchUserInfoFromFacebook()
        }
        
    }
    
   }

    
    // MARK: -  textFieldShouldReturn
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    // MARK: -  fetchUserInfoFromFacebook
    
    func fetchUserInfoFromFacebook() -> Void {
        if (FBSDKAccessToken.current() != nil) {
            let fbAccessToken = FBSDKAccessToken.current().tokenString
            let request = FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields": "email,name,first_name,last_name,picture.type(large)"])
            request?.start(completionHandler: { (connection, result, error) in
                if (error == nil){
                    let userData = result as! Dictionary<String, Any>
                    UserDefaults.standard.set(userData, forKey: "loginUserinfo")
                    UserDefaults.standard.synchronize()

                    FBSDKAccessToken.refreshCurrentAccessToken({ (connection, result, error) in
                    })
                    self.fbLoginSuccessCall(userInfo: userData, token: fbAccessToken!)
                }
                else {
                    print("Error in getting token")
                }
            })
        }
        else {
            print("Token not found !")
        }
        
    }
    
    // MARK: -  fbLoginSuccessCall
    
    func fbLoginSuccessCall(userInfo:[String:Any], token accessToken: String) -> Void {
        
        if accessToken.count == 0 {
        self.view.makeToast("Access token is not found", duration: 1.0, position: CSToastPositionCenter)
        }
        else
        {
           
          let pictureDict = userInfo["picture"] as! NSDictionary
          let   pictureData = pictureDict["data"] as! NSDictionary
          let pictureURl = pictureData["url"] as! NSString
         if pictureURl != nil{
                UserDefaults.standard.set(pictureURl, forKey: "profile_pic")
                UserDefaults.standard.synchronize()
            }
            let userId = userInfo["id"] as! String
            let firstName = userInfo["first_name"] as! String
            let last_name = userInfo["last_name"] as! String
            let email = userInfo["email"] as! String
            self.loginWebService(fisrtNmae: firstName, lasttName: last_name, emailid: email, socialId: userId, registrationType: "facebook", signInmobile: "no")
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if error == nil {
                    let uid = user?.uid
                    let userRef = self.firebaseRef
                    
                    userRef?.observeSingleEvent(of: DataEventType.value, with: { (snapshot:DataSnapshot?) in
                        if (snapshot?.hasChild(uid!))! {
                            let appDelegateIns = UIApplication.shared.delegate as! AppDelegate
                            appDelegateIns.getUserData()
                            
                            if appDelegateIns.firebaseModel?.uId == "" {
                                self.getFirebaseDataPressed()
                            }
                            DispatchQueue.main.async {
                                
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now()+1.2, execute: {
                                //                                self.backAction()
                            })
                        }
                        else {
                            print("Register User")
                            
                            //  Create appdelegate shared instance
                            let appDelegateIns = UIApplication.shared.delegate as! AppDelegate
                            appDelegateIns.getUserData()
                            // Set info to UserModel
                            appDelegateIns.firebaseModel?.uId = (user?.uid)!
                            if (user?.email) != nil{
                                appDelegateIns.firebaseModel?.email = (user?.email)!
                            }
                            if (user?.displayName) != nil{
                                appDelegateIns.firebaseModel?.userName = (user?.displayName)!
                            }
                            if (user?.photoURL) != nil{
                                //   appDelegateIns.firebaseModel?.userProfilePic = "\((user?.photoURL)!)"
                            }
                            appDelegateIns.setUserData()
                            // login api hit here
                          
                        
                        }
                    })
                }
                else{
               self.view.makeToast("Error !", duration: 1.0, position: CSToastPositionCenter)
          
                }
                
            })
        }
        
    }
    
     // MARK: -  GmailAction
    
     @IBAction func GmailAction(_ sender: Any)
     {
          GIDSignIn.sharedInstance().signOut()
          GIDSignIn.sharedInstance().signIn()
    
     }


    // MARK: -  sign
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if error == nil {
        if user.profile.hasImage {
            let profile_pic = user?.profile.imageURL(withDimension: 100) as! URL
            let path:String = profile_pic.absoluteString
            UserDefaults.standard.set(path, forKey: "profile_pic")
            UserDefaults.standard.synchronize()
            
                }
                var dataDict = Dictionary<String,Any>()
                var fullName = (user.profile.name != nil) ? user.profile.name : ""
                let fullNameArr = fullName?.characters.split{$0 == " "}.map(String.init)
                let firstName: String = fullNameArr![0]
                let lastName: String? = fullNameArr!.count > 1 ? fullNameArr![1] : nil
                dataDict["firstname"] = firstName
                dataDict["fullname"] = fullName
                dataDict["social_email"] = user.profile.email
            UserDefaults.standard.set(dataDict, forKey: "loginUserinfo")
            UserDefaults.standard.synchronize()

                dataDict["social_site_name"] = "Google"
                dataDict["lastName"] = lastName
                dataDict["authentication.idToken"] = user.authentication.idToken
                let userId = user.userID
//            self.loginWebService(socialId: userId!, registrationType: "google",signInmobile :"no")
            self.loginWebService(fisrtNmae: firstName, lasttName: lastName!, emailid: user.profile.email, socialId: userId!, registrationType: "google", signInmobile: "no")
            
        guard let authentication = user.authentication else { return }

        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if error == nil {
                let uid = user?.uid
                let userRef = self.firebaseRef
                userRef?.observeSingleEvent(of: DataEventType.value, with: { (snapshot:DataSnapshot?) in
                    if (snapshot?.hasChild(uid!))! {
                        let appDelegateIns = UIApplication.shared.delegate as! AppDelegate
                        appDelegateIns.getUserData()
                        if appDelegateIns.firebaseModel?.uId == "" {
                            self.getFirebaseDataPressed()
                        }
                    }
                    else {
                        print("Register User")
                        //  Create appdelegate shared instance
                        let appDelegateIns = UIApplication.shared.delegate as! AppDelegate
                        appDelegateIns.getUserData()
                        // Set info to FirebaseModel
                        appDelegateIns.firebaseModel?.uId = (user?.uid)!
                        if (user?.email) != nil{
                            appDelegateIns.firebaseModel?.email = (user?.email)!
                        }
                        if (user?.displayName) != nil{
                            appDelegateIns.firebaseModel?.userName = (user?.displayName)!
                        }
                        if (user?.photoURL) != nil{
                            //  appDelegateIns.firebaseModel?.userProfilePic = "\((user?.photoURL)!)"
                        }
                        appDelegateIns.setUserData()

                    }
                })
            }
        })
        
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    
    
    
    

// Present a view that prompts the user to sign in with Google
func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
    self.present(viewController, animated: true, completion: nil)
}

// Dismiss the "Sign in with Google" view
func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
    self.dismiss(animated: true, completion: nil)
}

    func loginWebService(fisrtNmae: String,lasttName: String,emailid:String,socialId:String , registrationType:String,signInmobile : String){
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    if appDelegate.IsReachabilty! {
        var loginServiceName :String = ""
        var dict = NSDictionary()
        if signInmobile == "yes"{
            validationBool = self.validation()
            if validationBool==false {
             loginServiceName = "customer/login"
                dict = ["post":["mobileNo":phoneNumberLBL.text,
                                "password": passwordLBL.text]]
            }
       }else{ 
            loginServiceName = "customer/"
        dict = ["post":["firstName":fisrtNmae,"lastName":lasttName,"emailId":emailid,"socialId":socialId,"registrationType":registrationType]]
        }
       
        WebserviceHelper.sharedInstance.callPostDataWithMethod(methodName: loginServiceName, requestDict: dict as! [String : [String : Any]]  , headerValue: [:], isHud: false, hudView: self.view, successBlock:
            {  response, responseStr in print(response)
                print("\(responseStr)");
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200{
                    let message = responseStr ["message" ] as? NSString
                    if message == "success"{
                       UserDefaults.standard.set("loginSucessFully", forKey: "doneLogin")
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
    else{
      //  self.view.makeToast("Please check internet connection", duration: 0.5, position: CSToastPositionCenter)
        
        self.checkInternetConnection()

    }
}

     // MARK: -  createMenuView

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

    // MARK: -  ForgotPasswordBtn_Clicked
    
    @IBAction func ForgotPasswordBtn_Clicked(_ sender: Any) {
         let storyboard: ForgotViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ForgotViewController") as! ForgotViewController
         self.navigationController?.pushViewController(storyboard, animated: true)
    }
    
    // MARK: -  SignUpBtn_Clicked
    
    @IBAction func SignUpBtn_Clicked(_ sender: Any) {
         let registerViewController: RegisterViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
         self.navigationController?.pushViewController(registerViewController, animated: true)
    }
    
    // MARK: -  validation
    
    func validation()->Bool  {
        var check:Bool!
        check=false
        if (phoneNumberLBL.text == nil) || (phoneNumberLBL.text == "") {
            self.view.makeToast("Please Enter mobile number" as String, duration: 1.0, position: CSToastPositionCenter)
            // Alertviewclass.showalertMethod("", strBody: "Please Enter valid number ", delegate: nil)
            check=true
            return check
            
        }
        else{
            emailcheck = self.myMobileNumberValidate(number:phoneNumberLBL.text!)
            if emailcheck==false {
                self.view.makeToast("Please Enter valid phone number" as String, duration: 1.0, position: CSToastPositionCenter)
                // Alertviewclass.showalertMethod("", strBody: "Please Enter valid phone number", delegate: nil)
                check=true
                return check
                
            }
            
        }
        
        if (passwordLBL.text == nil) || (passwordLBL.text == ""){
            self.view.makeToast("Please Enter password" as String, duration: 1.0, position: CSToastPositionCenter)
            // Alertviewclass.showalertMethod("", strBody: "password must be minimum 6 digit", delegate: nil)
            check=true
            return check
            
        }
         return check
    }
    
    // MARK: -  myMobileNumberValidate
    
    func myMobileNumberValidate(number:String) -> Bool {
        // "[0-9]{10}"
        
        let numberRegEx="^[2-9][0-9]{9}$"
        let phoneTest = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        return phoneTest.evaluate(with: number)
    }
    
    // MARK: -  signinbyMobileMethod
    
    @IBAction func signinbyMobileMethod(_ sender: Any) {
         var dataDict = Dictionary<String,Any>()
        dataDict["mobileno"] = self.phoneNumberLBL.text!
        UserDefaults.standard.set(dataDict, forKey: "mobileno")
        UserDefaults.standard.synchronize()
        self.loginWebService(fisrtNmae: "", lasttName: "", emailid: "", socialId: "", registrationType: "", signInmobile: "yes")
    }
    
    // MARK: -  getFirebaseDataPressed
    
    func getFirebaseDataPressed() {
        
        self.firebaseRef.observe(DataEventType.value, with: { (snapshot) in
            let userID = Auth.auth().currentUser?.uid
            self.firebaseRef.child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                // Get user value
                let value = snapshot.value as? NSDictionary
                if value != nil {
                    let userModel =   FirebaseModel.init(userDict: value!)
                    let appDelegateIns = UIApplication.shared.delegate as! AppDelegate
                    appDelegateIns.firebaseModel = userModel
                    appDelegateIns.setUserData()
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        })
    }
    
    // MARK: -  checkInternetConnection
    
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
