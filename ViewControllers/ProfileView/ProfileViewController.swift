//
//  ProfileViewController.swift
//  GoogleFacebookLogin
//
//  Created by V kishore kumar reddy  on 1/20/18.
//  Copyright © 2018 Raju sharma. All rights reserved.
//

import UIKit
import AAPopUp
import GoogleMaps
import GooglePlaces
import NVActivityIndicatorView
import UnderLineTextField

class ProfileViewController: UIViewController,SlideMenuControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,CLLocationManagerDelegate,GMSMapViewDelegate
{
    // MARK: - IBOutlets & Objects
    
    var  AddressListArray: NSArray = []
    
    @IBOutlet weak var AddressTxt: UnderLineTextField!
    @IBOutlet weak var EmailIdTxt: UnderLineTextField!
    @IBOutlet weak var PhoneTxt: UnderLineTextField!
    @IBOutlet weak var profileNameLBL: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    let  picker = UIImagePickerController()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: - viewDidLoad

    override func viewDidLoad()
    {
        super.viewDidLoad()
       // self.title = "Profile"
        self.customNavigationItem(stringText: "PROFILE", showbackButon: false)
        self.setNavigationBarItem()
        profileImg.layer.borderWidth = 1
        profileImg.layer.masksToBounds = false
        profileImg.layer.borderColor = UIColor.white.cgColor
        profileImg.layer.cornerRadius = profileImg.frame.height/2
        profileImg.clipsToBounds = true
        AddressTxt.delegate = self
        let loginUserInfoDict  = UserDefaults.standard.object(forKey: "loginUserinfo") as?Dictionary<String,Any>
        profileNameLBL.text = loginUserInfoDict?["fullname"] as? String

        
       // let googleURl = UserDefaults.standard.value(forKey: "profile_pic")
        
        //var googleURl = NSString()
        
       let googleURl =  UserDefaults.standard.value(forKey: "profile_pic") as? String
      
        if googleURl == nil || (googleURl?.isEqual("<null>"))! || (googleURl?.isEqual("null)"))! || (googleURl?.isEqual(" "))! || (googleURl?.isEqual("NULL"))!
        {
           print("If profile image is not save")
        
           let userImage: UIImage = UIImage(named: "userprofile.png")!
            
           profileImg.image = userImage
        }
        else
        {
//            DispatchQueue.main.async {
//
//                let url = URL(string: googleURl as! String)
//                let data = try? Data(contentsOf: url!)
//
//                if let imageData = data {
//                    let image1 = UIImage(data: imageData)
//                    self.profileImg.image = image1
//                }
//            }
            
        print("If profile image is save")
            
            self.profileImg.sd_setImage(with: URL(string:(googleURl) as! String), placeholderImage: UIImage(named: " "))
        }
        GetAddress()
    }
    
    // MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.appDelegate.hideHud()
        let loginUserInfoDict  = UserDefaults.standard.object(forKey: "loginUserinfo") as?Dictionary<String,Any>
        PhoneTxt.text = loginUserInfoDict?["Mobileno"] as? String
        EmailIdTxt.text = loginUserInfoDict?["social_email"] as? String
        
    }
    
    // MARK: - customNavigationItem
    
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
    
    // MARK: - backAction
    
    @objc func backAction(){
          self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - GetAddress
    
    func GetAddress()  {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.IsReachabilty! {
            let auth = UserDefaults.standard.value(forKey: "user_auth_token")!
            let token = "\(WebseviceNameConstant.StrJWT)\(auth)"
            let headerDict=["Authorization": token]
            WebserviceHelper.sharedInstance.callGetDataWithMethod(strMethodName:"address", requestDict: [:], isHud: false, hudView: self.view, value: headerDict, successBlock:
                {  response, responseStr in print(response)
                    print("\(responseStr)");
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200{
                        self.AddressListArray = (responseStr["data"] as! NSArray)
                         for i in 0..<(self.AddressListArray.count){
                            let AddressDict = self.AddressListArray[i] as! NSDictionary
                            let checkAddressDefault = AddressDict.value(forKey: "isDefault") as? Int
                            if  checkAddressDefault == 1 {
                               
                                let fullAddressStr = (AddressDict.value(forKey: "flat_No") as! String) + "," + (AddressDict.value(forKey: "buildingName") as! String) + "," + (AddressDict.value(forKey: "landmark") as! String) + "," + (AddressDict.value(forKey: "city") as! String) + "," + (AddressDict.value(forKey: "state") as! String)  + "," + (AddressDict.value(forKey: "pincode") as! String)
                                self.AddressTxt.text = fullAddressStr
                            }
                            
                        }
                       // self.SettingTableView.reloadData()
                    }
                    else{
                        let userDict=responseStr ["user_msg" ] as! String
                        self.view.makeToast(userDict as String, duration: 0.5, position: CSToastPositionCenter)
                        
                    }
            },
                                                                  errorBlock: {error in
                                                                    //            self.view.makeToast(error.d as String, duration: 0.5, position: CSToastPositionCenter)
                                                                    
            })
        }
        else{
            // self.view.makeToast("Please check internet connection", duration: 0.5, position: CSToastPositionCenter)
            
            self.checkInternetConnection()
            
        }
        
    }
    
    // MARK: - getLocationAddress
    
    func getLocationAddress(location:CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error)->Void in
            var placemark:CLPlacemark!
            if error == nil && placemarks!.count > 0 {
                placemark = placemarks![0] as CLPlacemark
                var addressString : String = ""
                if placemark.isoCountryCode == "TW" /*Address Format in Chinese*/ {
                    if placemark.country != nil {
                        addressString = placemark.country!
                    }
                    if placemark.subAdministrativeArea != nil {
                        addressString = addressString + placemark.subAdministrativeArea! + ", "
                    }
                    if placemark.postalCode != nil {
                        addressString = addressString + placemark.postalCode! + " "
                    }
                    if placemark.locality != nil {
                        addressString = addressString + placemark.locality!
                    }
                    if placemark.thoroughfare != nil {
                        addressString = addressString + placemark.thoroughfare!
                    }
                    if placemark.subThoroughfare != nil {
                        addressString = addressString + placemark.subThoroughfare!
                    }
                } else {
                    if placemark.subThoroughfare != nil {
                        addressString = placemark.subThoroughfare! + " "
                    }
                    if placemark.thoroughfare != nil {
                        addressString = addressString + placemark.thoroughfare! + ", "
                    }
                    if placemark.postalCode != nil {
                        addressString = addressString + placemark.postalCode! + " "
                    }
                    if placemark.locality != nil {
                        addressString = addressString + placemark.locality! + ", "
                    }
                    if placemark.administrativeArea != nil {
                        addressString = addressString + placemark.administrativeArea! + " "
                    }
                    if placemark.country != nil {
                        addressString = addressString + placemark.country!
                    }
                }
                self.AddressTxt.text = addressString
            }
        })
    }
    
    // MARK: - textFieldShouldReturn
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // MARK: - EditProfileBtn_Clicked
    
    @IBAction func EditProfileBtn_Clicked(_ sender: Any)
    {
        let popup: AAPopUp = AAPopUp(popup: .demo2)
        popup.present { popup in
        }
//        let editProfileViewController: EditProfileViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
//        self.present(editProfileViewController, animated: true, completion: nil)
//
        
    }
    
    
    // MARK: - didReceiveMemoryWarning
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - EditPhotoBtn_Clicked
    
    @IBAction func EditPhotoBtn_Clicked(sender: AnyObject)
    {
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
        }
        
        // Add the actions
        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - openCamera
 
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            picker.sourceType = UIImagePickerControllerSourceType.camera
            self .present(picker, animated: true, completion: nil)
        }
        else{
            let alertWarning = UIAlertView(title:"Warning", message: "You don't have camera", delegate:nil, cancelButtonTitle:"OK", otherButtonTitles:"")
            alertWarning.show()
        }
    }
    
    // MARK: - openGallary
    
    func openGallary(){
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
  
    //MARK: - Add image to Library
  
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    //MARK: - Done image capture here
  
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        imageArrayToNSData(array:[(info[UIImagePickerControllerOriginalImage] as? UIImage)!])
    }
    
        func imageArrayToNSData(array: [UIImage]) {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if appDelegate.IsReachabilty! {
                let activityData = ActivityData.init(size: CGSize(width:50, height: 50), message: "Waiting...", messageFont: UIFont(name: "HelveticaNeue-bold", size: 14.0)!, messageSpacing: 3.0, type: .ballRotateChase, color: UIColor.green, padding: 0.0, displayTimeThreshold: 0, minimumDisplayTime: 0, backgroundColor: UIColor.black.withAlphaComponent(0.5), textColor: UIColor.green)
                NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
                NVActivityIndicatorPresenter.sharedInstance.setMessage("Uploading image...")
                
                
                let auth = UserDefaults.standard.value(forKey: "user_auth_token")!
                let token = "\(WebseviceNameConstant.StrJWT)\(auth)"
                let body = NSMutableData()
                var i = 0;
                let URLSTR = "http://35.154.11.54/api/upload"
                let strRequestUrl = (URLSTR as NSString).addingPercentEscapes(using: String.Encoding.utf8.rawValue)
                let request = NSMutableURLRequest()
                request.url = URL(string: strRequestUrl!)
                request.httpMethod = "POST"
                request.addValue("Token \(token)", forHTTPHeaderField: "Authorization")
                
                let boundary = "---------------------------14737809831466499882746641449"
                let contentType = "multipart/form-data; boundary=\(boundary)"
                request.addValue(contentType, forHTTPHeaderField: "Content-Type")
                for image in array{
                    let filename = "image\(i).jpg"
                    let data = UIImageJPEGRepresentation(image,0.8);
                    let mimetype = "image/jpeg"
                    let key = "profile_images"
                    body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                    body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                    body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n".data(using: String.Encoding.utf8)!)
                    body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
                    body.append(data!)
                    body.append("\r\n".data(using: String.Encoding.utf8)!)
                    i += 1
                }
                body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
                request.httpBody = body as Data
                guard URL(string:URLSTR) != nil else { return }
                let task = URLSession.shared.dataTask(with: request as URLRequest) {
                    (data, response, error) in
                    if error == nil {
                        if data != nil && error == nil{
                            do {
                                let responseStr = try JSONSerialization.jsonObject(with: (data)!, options: .mutableContainers) as! Dictionary<String, Any>
                                print("\(responseStr)")
                               // Imageupload(Urlstr: <#T##String#>)
                                DispatchQueue.main.async {
                                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                                }
                                let messge = responseStr["message"] as! String
                                if messge == "uploaded"{
                                let imgeurl = responseStr["url"] as! String
                                    self.Imageupload(Urlstr: imgeurl)
                                    
                                    DispatchQueue.main.async {
                                        
                                        let url = URL(string: imgeurl)
                                        let data = try? Data(contentsOf: url!)
                                        
                                        if let imageData = data {
                                            let image1 = UIImage(data: imageData)
                                            self.profileImg.image = image1
                                        }
                                    }
//                                    DispatchQueue.main.async {
//                            self.profileImg.sd_setImage(with: URL(string:(imgeurl)), placeholderImage: UIImage(named: " "))
                                 //   }
                                }

                            }
                            catch let error as NSError {
                                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                                print("Failed to load: \(error.localizedDescription)")
                            }
                        }
                    }
                }
                task.resume()

            }else{
               //  self.view.makeToast("Please check internet connection", duration: 0.5, position: CSToastPositionCenter)
                
                self.checkInternetConnection()

            }
            
    }
    
     // MARK: - Imageupload

     func Imageupload(Urlstr:String){
        if self.appDelegate.IsReachabilty! {
            let auth = UserDefaults.standard.value(forKey: "user_auth_token")!
            let token = "\(WebseviceNameConstant.StrJWT)\(auth)"
            let userlocationDict = ["post":["profileImage":Urlstr]]
            let headerDict=["Authorization": token]
            WebserviceHelper.sharedInstance.callPutDataWithMethod(strMethodName: "customer/update", requestDict: userlocationDict as Dictionary<String, Any>, isHud: true, hudView: self.view, value: headerDict,successBlock: { (success, response) in
                print("\(response)");
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200{
                }
                else{
                    
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
    
}
