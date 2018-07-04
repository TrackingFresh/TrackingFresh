//
//  DeliveryViewController.swift
//  GoogleFacebookLogin
//
//  Created by V kishore kumar reddy  on 2/23/18.
//  Copyright © 2018 Raju sharma. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces


class DeliveryViewController: UIViewController, CLLocationManagerDelegate,GMSMapViewDelegate
{

    // MARK: - IBOutlets & Objects

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var Namelbl: UILabel!
    @IBOutlet weak var Addresslbl: UILabel!
    var Latitiude:Double!
    var Longitude:Double!
    let geocoder = CLGeocoder()
    var  AddressListArray: NSArray = []
    let locationManager = CLLocationManager()
    var  adddressDict = [String :Any]()
    var sourceLocation = CLLocationCoordinate2D()
   
    // MARK: -  viewDidLoad
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
//        locationManager.requestAlwaysAuthorization()
//        locationManager.requestWhenInUseAuthorization()

        // Do any additional setup after loading the view.
    }
  
    // MARK: -  viewWillAppear
    
    override func  viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
        self.customNavigationItem(stringText: "DELIVERY ADDRESS", showbackButon: false)
//    let distination = CLLocation(latitude:19.1579, longitude:72.9935)
//    self.getLocationAddress(location: distination);
//    self.locationManager.startUpdatingLocation()
    let loginUserInfoDict  = UserDefaults.standard.object(forKey: "loginUserinfo") as?Dictionary<String,Any>
//        self.Namelbl.text = loginUserInfoDict?["fullname"] as? String
        UserDefaults.standard.set(false, forKey: "isCheck")
        GetAddress()
        self.appDelegate.hideHud()

   }
    
    
    // MARK: -   GetAddress
    
    func GetAddress()  {
        
        if appDelegate.IsReachabilty! {
            let auth = UserDefaults.standard.value(forKey: "user_auth_token")!
            let token = "\(WebseviceNameConstant.StrJWT)\(auth)"
            let headerDict=["Authorization": token]
            WebserviceHelper.sharedInstance.callGetDataWithMethod(strMethodName:"address", requestDict: [:], isHud: false, hudView: self.view, value: headerDict, successBlock:
                {  response, responseStr in print(response)
                    print("\(responseStr)");
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200{
                        self.AddressListArray = (responseStr["data"] as! NSArray)
                        if (self.AddressListArray.count > 0)
                        {
                            for i in 0..<(self.AddressListArray.count){
                                let AddressDict = self.AddressListArray[i] as! NSDictionary
                                let checkAddressDefault = AddressDict.value(forKey: "isDefault") as? Int
                                if  checkAddressDefault == 1 {
                                    self.Namelbl.text = AddressDict.value(forKey: "fullName") as? String
                                    let fullAddressStr = (AddressDict.value(forKey: "flat_No") as! String) + "," + (AddressDict.value(forKey: "buildingName") as! String) + "," + (AddressDict.value(forKey: "landmark") as! String) + "," + (AddressDict.value(forKey: "city") as! String) + "," + (AddressDict.value(forKey: "state") as! String)  + "," + (AddressDict.value(forKey: "pincode") as! String)
                                    self.Addresslbl.text = fullAddressStr

                                    let locationDict = AddressDict["geo"] as! NSDictionary
                                    let cordinateDict1 = locationDict["coordinates"] as! NSArray
                                    if cordinateDict1.count>0{
                                        let locationDict = ["longitude":cordinateDict1[0] as! Double,"latitude": cordinateDict1[1] as! Double]
                                        print(locationDict)
                                        UserDefaults.standard.set(locationDict, forKey: "DeliveryLatLong")
                                        UserDefaults.standard.synchronize()

                                    }
                               
                                }
                            }
                        }
                        else{
                            let storyboard: AddressViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddressViewController") as! AddressViewController
                            self.navigationController?.pushViewController(storyboard, animated: true)
                        }
                        
                        
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
    
    // MARK: -   customNavigationItem
    
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
    
    // MARK: -   backAction
   
    @objc func backAction()
    {
         self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: -   SetAddressCheckBtn_Clciked
    
    @IBAction func SetAddressCheckBtn_Clciked(_ sender: Any)
    {
        
    }
//    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
//        if status == .authorizedWhenInUse {
//            locationManager.startUpdatingLocation()
//
//        }
//    }
    
//    private func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.first {
//
//            locationManager.stopUpdatingLocation()
//        }
//    }
//
//    func getLocationAddress(location:CLLocation) {
//        let geocoder = CLGeocoder()
//
//
//
//        geocoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error)->Void in
//            var placemark:CLPlacemark!
//            if error == nil && placemarks!.count > 0 {
//                placemark = placemarks![0] as CLPlacemark
//                var addressString : String = ""
//                if placemark.isoCountryCode == "TW" /*Address Format in Chinese*/ {
//                    if placemark.country != nil {
//
//                        addressString = placemark.country!
//
//                    }
//                    if placemark.subAdministrativeArea != nil {
//                        addressString = addressString + placemark.subAdministrativeArea! + ", "
//                    }
//                    if placemark.postalCode != nil {
//                        addressString = addressString + placemark.postalCode! + " "
//
//                    }
//                    if placemark.locality != nil {
//                        addressString = addressString + placemark.locality!
//
//                    }
//                    if placemark.thoroughfare != nil {
//                        addressString = addressString + placemark.thoroughfare!
//
//                    }
//                    if placemark.subThoroughfare != nil {
//                        addressString = addressString + placemark.subThoroughfare!
//                    }
//                } else {
//                    if placemark.subThoroughfare != nil {
//                        addressString = placemark.subThoroughfare! + " "
//                    }
//                    if placemark.thoroughfare != nil {
//                        addressString = addressString + placemark.thoroughfare! + ", "
//                    }
//                    if placemark.postalCode != nil {
//                        addressString = addressString + placemark.postalCode! + " "
//
//
//                    }
//                    if placemark.locality != nil {
//                        addressString = addressString + placemark.locality! + ", "
//
//                    }
//                    if placemark.administrativeArea != nil {
//                        addressString = addressString + placemark.administrativeArea! + " "
//
//                    }
//                    if placemark.country != nil {
//                        addressString = addressString + placemark.country!
//
//                    }
//                }
//                self.Addresslbl.text = addressString
//            }
//
//
//        })
//    }
//

    // MARK: -   CheckBtn_Clicked
    
    @IBAction func CheckBtn_Clicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if(sender.isSelected == true) {
        UserDefaults.standard.set(true, forKey: "isCheck")
        } else{
            UserDefaults.standard.set(false, forKey: "isCheck")
        }
    }
    
    // MARK: -   ChnageAdddresBtn_Clicked
    
    @IBAction func ChnageAdddresBtn_Clicked(_ sender: Any) {
        let storyboard: ChangeAddressViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChangeAddressViewController") as! ChangeAddressViewController
        self.navigationController?.pushViewController(storyboard, animated: true)
    }
    
    // MARK: -  NewAddressBtn_Clicked
    
    @IBAction func NewAddressBtn_Clicked(_ sender: Any) {
        let storyboard: AddressViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddressViewController") as! AddressViewController
        self.navigationController?.pushViewController(storyboard, animated: true)
    }
    
    // MARK: - ViewOrderBtn_Clicked
   
    @IBAction func ViewOrderBtn_Clicked(_ sender: Any) {
        let storyboard: ConfirmOrderViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConfirmOrderViewController") as! ConfirmOrderViewController
        self.navigationController?.pushViewController(storyboard, animated: true)
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
