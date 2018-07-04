//
//  AddressViewController.swift
//  GoogleFacebookLogin
//
//  Created by V kishore kumar reddy  on 1/20/18.
//  Copyright © 2018 Raju sharma. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import UnderLineTextField

class AddressViewController: UIViewController, CLLocationManagerDelegate,GMSMapViewDelegate
{

    // MARK: - IBOutlets & Objects
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var scrollview: TPKeyboardAvoidingScrollView!
    var Latitiude:Double!
    var Longitude:Double!
    var TapLatitiude:Double!
    var TapLongitude:Double!
    
    let geocoder = CLGeocoder()
    var setDefaultAdress: Bool!
    var emailcheck: Bool!
    var phonenumber: Bool!
    var validationBool:Bool!
    var setdefault : String!
    let marker2 = GMSMarker()
    @IBOutlet weak var NameTxt: UnderLineTextField!
    @IBOutlet weak var EmailIdTxt: UnderLineTextField!
    @IBOutlet weak var MobileNOTxt: UnderLineTextField!
    @IBOutlet weak var FlatNoTxt: UnderLineTextField!
    @IBOutlet weak var BulidingNameTxt: UnderLineTextField!
    
    @IBOutlet weak var LandMarkTxt: UnderLineTextField!
    
    @IBOutlet weak var CityTxt: UnderLineTextField!
    
    @IBOutlet weak var StateTxt: UnderLineTextField!
    
    @IBOutlet weak var PincodeTxt: UnderLineTextField!
    @IBOutlet weak var AddressTxt: UnderLineTextField!
    var checkdatabase : Bool!
    let dbManager = DBManager()
    var databaseAddressArray = [NSDictionary]()
    @IBOutlet weak var mapView: GMSMapView!
     let locationManager = CLLocationManager()
    var  adddressDict = [String :Any]()
    var sourceLocation = CLLocationCoordinate2D()
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaultAdress = false
        self.customNavigationItem(stringText: "DELIVERY ADDRESS", showbackButon: false)
        let Camera = GMSCameraPosition.camera(withLatitude: 19.1579,
                                              longitude: 72.9935,
                                              zoom: 12)
        Latitiude = 19.1579
        Longitude = 72.9935
        mapView.camera = Camera
        mapView.isMyLocationEnabled = true
        mapView.mapType = .normal
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        mapView.settings.zoomGestures = true
        locationManager.delegate = self
        mapView.delegate = self
        self.scrollview.addSubview(mapView)
        //locationManager.requestAlwaysAuthorization()
        //locationManager.requestWhenInUseAuthorization()
        // Do any additional setup after loading the view.
        
        
        let lastView : UIView! = scrollview!.subviews.last
        let height = lastView.frame.size.height
        let pos = lastView.frame.origin.y
        let sizeOfContent = height + pos
        
        scrollview?.contentSize.height = sizeOfContent
        
        scrollview?.contentSize = CGSize(width: (scrollview?.frame.size.width)!,height: 1020)
        
        view.addSubview(scrollview!)
        
        
    }
    
    // MARK: - viewWillAppear

    override func  viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.appDelegate.hideHud()

        self.locationManager.startUpdatingLocation()
        let loginUserInfoDict  = UserDefaults.standard.object(forKey: "loginUserinfo") as?Dictionary<String,Any>
        NameTxt.text = loginUserInfoDict?["fullname"] as? String
        EmailIdTxt.text = loginUserInfoDict?["social_email"] as? String
        MobileNOTxt.text = loginUserInfoDict?["Mobileno"] as? String
         self.mapViewWithMarker()
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
    
    // MARK: - SetDeafultBtn_Clicked
    
    @IBAction func SetDeafultBtn_Clicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if(sender.isSelected == true) {
            setDefaultAdress = true
        } else  {
            setDefaultAdress = false

        }
    }
    
    // MARK: - validation
    
    func validation()->Bool  {
        var check:Bool!
        check=false
        
         if (NameTxt.text == nil) ||  (NameTxt.text=="") {
            self.view.makeToast("Please Enter First name" as String, duration: 1.0, position: CSToastPositionCenter)
            //  Alertviewclass.showalertMethod("", strBody: "Enter First name", delegate: nil)
            check=true
            return check
        }
       if (EmailIdTxt.text == nil) ||  (EmailIdTxt.text=="") {
            self.view.makeToast(" Please Enter Email name" as String, duration: 1.0, position: CSToastPositionCenter)
            //Alertviewclass.showalertMethod("", strBody: "Enter Email name", delegate: nil)
            check=true
            return check
            
        }
        else{
            emailcheck=self.validateEmail(testStr:EmailIdTxt.text!)
            if emailcheck==false {
                self.view.makeToast("Please Enter valid Email namer" as String, duration: 1.0, position: CSToastPositionCenter)
                //   Alertviewclass.showalertMethod("", strBody: "Enter valid Email name", delegate: nil)
                check=true
                return check
            }
        }
        
        if (MobileNOTxt.text == nil) ||  (MobileNOTxt.text=="") {
            self.view.makeToast("Please Enter mobile number" as String, duration: 1.0, position: CSToastPositionCenter)
            // Alertviewclass.showalertMethod("", strBody: "Please Enter valid number ", delegate: nil)
            check=true
            return check
            
        }
        else{
            emailcheck=self.myMobileNumberValidate(number:MobileNOTxt.text!)
            if emailcheck==false {
                self.view.makeToast("Please Enter valid phone number" as String, duration: 1.0, position: CSToastPositionCenter)
                // Alertviewclass.showalertMethod("", strBody: "Please Enter valid phone number", delegate: nil)
                check=true
                return check
                
            }
        }
        if (FlatNoTxt.text == nil) ||  (FlatNoTxt.text=="") {
            self.view.makeToast(" Please Enter Flat No" as String, duration: 1.0, position: CSToastPositionCenter)
            // Alertviewclass.showalertMethod("", strBody: "Enter last  name", delegate: nil)
            check=true
            return check
            
        }
        
         if (BulidingNameTxt.text == nil) ||  (BulidingNameTxt.text=="") {
            self.view.makeToast("Please Enter Building name" as String, duration: 1.0, position: CSToastPositionCenter)
            // Alertviewclass.showalertMethod("", strBody: "password must be minimum 6 digit", delegate: nil)
            check=true
            return check
            
        }
        if (LandMarkTxt.text == nil) ||  (LandMarkTxt.text=="") {
            self.view.makeToast("Please Enter Landmark" as String, duration: 1.0, position: CSToastPositionCenter)
            // Alertviewclass.showalertMethod("", strBody: "password must be minimum 6 digit", delegate: nil)
            check=true
            return check
            
        }
        if (CityTxt.text == nil) ||  (CityTxt.text=="") {
            self.view.makeToast("Please Enter City" as String, duration: 1.0, position: CSToastPositionCenter)
            // Alertviewclass.showalertMethod("", strBody: "password must be minimum 6 digit", delegate: nil)
            check=true
            return check
            
        }
        if (StateTxt.text == nil) ||  (StateTxt.text=="") {
            self.view.makeToast("Please Enter State" as String, duration: 1.0, position: CSToastPositionCenter)
            // Alertviewclass.showalertMethod("", strBody: "password must be minimum 6 digit", delegate: nil)
            check=true
            return check
            
        }
        if (PincodeTxt.text == nil) ||  (PincodeTxt.text=="") {
            self.view.makeToast("Please Enter pincode" as String, duration: 1.0, position: CSToastPositionCenter)
            // Alertviewclass.showalertMethod("", strBody: "password must be minimum 6 digit", delegate: nil)
            check=true
            return check
            
        }
        if (AddressTxt.text == nil) ||  (AddressTxt.text=="") {
            self.view.makeToast("Please Enter Address" as String, duration: 1.0, position: CSToastPositionCenter)
            // Alertviewclass.showalertMethod("", strBody: "password must be minimum 6 digit", delegate: nil)
            check=true
            return check
            
        }
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
        let numberRegEx="^[2-9][0-9]{9}$"
        let phoneTest = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        return phoneTest.evaluate(with: number)
    }
    
     // MARK: - mapViewWithMarker
  
    func mapViewWithMarker()  {
   
        
    }
    
    // MARK: - locationManager
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        if let location = locations.first {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 10, bearing: 0, viewingAngle: 10)
            Latitiude = location.coordinate.latitude
            Longitude = location.coordinate.longitude
            TapLatitiude = location.coordinate.latitude
            TapLongitude = location.coordinate.longitude
            
            let distination = CLLocation(latitude:location.coordinate.latitude, longitude:location.coordinate.longitude)
        self.getLocationAddress(location: distination);
            let marker1 = GMSMarker()
            marker1.position = CLLocationCoordinate2D(latitude:Latitiude, longitude:Longitude)
            marker1.icon = UIImage(named: "ic_customer_marker")
            marker1.map = mapView
            let loginUserInfoDict  = UserDefaults.standard.object(forKey: "loginUserinfo") as?Dictionary<String,Any>
            marker1.title = loginUserInfoDict?["fullname"] as? String
            
            locationManager.stopUpdatingLocation()
            
        }
    }
    
    // MARK: - mapView
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
         let center = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        TapLatitiude = coordinate.latitude
        TapLongitude = coordinate.longitude
        self.marker2.map = nil
        marker2.position = CLLocationCoordinate2D(latitude:coordinate.latitude, longitude:coordinate.longitude)
        marker2.icon = UIImage(named: "ic_locationRed")
        marker2.map = mapView
        marker2.title = "Delevery location";
        getLocationAddress(location: center)
       
    }
    
    // MARK: - getAddressForLatLng
    
    func getAddressForLatLng(latitude: Double, longitude: Double) -> String {
        
        let url = NSURL(string: "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(latitude),\(longitude)&key=\("AIzaSyCznLu2roHMQiMUGRHwb1qRSdAUAAQaFf0")")
        let data = NSData(contentsOf: url! as URL)
        if data != nil {
            let json = try! JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
            if let result = json["results"] as? NSArray   {
                if result.count > 0 {
                    if let addresss:NSDictionary = result[0] as! NSDictionary {
                        if let address = addresss["address_components"] as? NSArray {
                            var newaddress = ""
                            var number = ""
                            var street = ""
                            var city = ""
                            var state = ""
                            var zip = ""
                            
                            if(address.count > 1) {
                                number =  (address.object(at: 0) as! NSDictionary)["short_name"] as! String
                            }
                            if(address.count > 2) {
                                street = (address.object(at: 1) as! NSDictionary)["short_name"] as! String
                            }
                            if(address.count > 3) {
                                city = (address.object(at: 2) as! NSDictionary)["short_name"] as! String
                            }
                            if(address.count > 4) {
                                state = (address.object(at: 4) as! NSDictionary)["short_name"] as! String
                            }
                            if(address.count > 6) {
                                zip =  (address.object(at: 6) as! NSDictionary)["short_name"] as! String
                            }
                            newaddress = "\(number) \(street), \(city), \(state) \(zip)"
                            return newaddress
                        }
                        else {
                            return ""
                        }
                    }
                } else {
                    return ""
                }
            }
            else {
                return ""
            }
            
        }   else {
            return ""
        }
        
    }
//    func getLocationAddress(lat1:Double, lon1:Double)  {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        if appDelegate.IsReachabilty! {
//            let userlatLong = String(lat1) + "," + String(lon1)
//            let vehiclelatLong = String(lat2) + "," + String(lon2)
//            let url : String = "https://maps.googleapis.com/maps/api/distancematrix/json"
//            let postParameters:[String: Any] = [ "origins": userlatLong,"destinations": vehiclelatLong,"mode":"driving","language":"en-EN",    "sensor":"false","key":"AIzaSyAnMmIt4AHmAYyW0qOW9J1nz2DW5tkEAls"]
//            WebserviceHelper.sharedInstance.callGoogleAPiAddress(strMethodName:url, requestDict: postParameters, isHud: false, hudView: self.view, value:[:], successBlock:
//                {  response, responseStr in print(response)
//                    print("\(responseStr)");
//                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200{
//                        let destination_addresses = responseStr["destination_addresses"] as! NSArray
//                        var straddress : String! = " "
//                        var orginaddress : String! = " "
//                        for i in 0..<(destination_addresses.count)  {
//                            let straddress1 =  destination_addresses[i] as! String
//                            straddress = straddress1 +  straddress
//                        }
//                        let origin_addresses = responseStr["origin_addresses"] as! NSArray
//                        for i in 0..<(origin_addresses.count)  {
//                            let  orginaddress1 = origin_addresses[i] as! String
//                            orginaddress = orginaddress1 + orginaddress
//
//                        }
//                        self.currentUserAddress.text = orginaddress
//                        let rows = responseStr["rows"] as! NSArray
//                        let dictelements = rows[0] as! NSDictionary
//                        let elementArray = dictelements["elements"] as! NSArray
//                        let distanceDict = elementArray[0] as! NSDictionary
//                        let distance = distanceDict["distance"] as! NSDictionary
//                        let Vehicledistancefromuser = distance["text"] as! String
//                        self.trackVanAddress.text = " Vehicle is " +  Vehicledistancefromuser  +  straddress
//                        print(Vehicledistancefromuser)
//                        let duration = distanceDict["duration"] as! NSDictionary
//                        let timetakenfromVehicleToUser = duration["text"] as! String
//                        self.DurationLBl.text = "Duration:" + timetakenfromVehicleToUser  + "away"
//                        print(timetakenfromVehicleToUser)
//                    }
//            },
//                                                                 errorBlock: {error in
//                                                                    //            self.view.makeToast(error.d as String, duration: 0.5, position: CSToastPositionCenter)
//
//            })
//        }
//        else{
//            print("No internet")
//
//        }
//
//    }
    
   
    
//    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
//        if status == .authorizedWhenInUse {
//            locationManager.startUpdatingLocation()
//            mapView.isMyLocationEnabled = true
//            mapView.settings.myLocationButton = true
//        }
//    }
//    
//    private func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.first {
//            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 10, bearing: 0, viewingAngle: 10)
//            locationManager.stopUpdatingLocation()
//        }
//    }
//
    
    // MARK: - getLocationAddress
    
    func getLocationAddress(location:CLLocation)
    {
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
                        self.PincodeTxt.text = placemark.postalCode!
                    }
                    if placemark.locality != nil {
                        addressString = addressString + placemark.locality!
                         self.CityTxt.text = placemark.thoroughfare! + placemark.locality!
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
                        self.PincodeTxt.text = placemark.postalCode!

                    }
                    if placemark.locality != nil {
                        addressString = addressString + placemark.locality! + ", "
                        if placemark.thoroughfare != nil {
                            addressString = addressString + placemark.thoroughfare!
                             self.CityTxt.text = placemark.thoroughfare! + " " +  placemark.locality!
                        }
                        else{
                             self.CityTxt.text =  placemark.locality!
                        }
                       }
                    
                   
                    if placemark.administrativeArea != nil {
                        addressString = addressString + placemark.administrativeArea! + " "
                        
                    }
                    if placemark.country != nil {
                        addressString = addressString + placemark.country!
                        self.StateTxt.text = placemark.administrativeArea! + " " + placemark.country!
                        
                    }
                }  
                
            }
            
            
        })
    }
    
    // MARK: - ConfirmBtn_Clicked
    
    @IBAction func ConfirmBtn_Clicked(_ sender: Any) {

        validationBool=self.validation()
        if validationBool==false {
              let appDelegate = UIApplication.shared.delegate as! AppDelegate
                if appDelegate.IsReachabilty! {
                    let auth = UserDefaults.standard.value(forKey: "user_auth_token")!
                    let token = "\(WebseviceNameConstant.StrJWT)\(auth)"
                    let userlocationDict = ["post":["fullName":NameTxt.text!,"email_Id": EmailIdTxt.text!,"mobileNo":MobileNOTxt.text!,"flat_No": FlatNoTxt.text!,"buildingName":BulidingNameTxt.text!,"landmark": LandMarkTxt.text!,"city":CityTxt.text!,"state": StateTxt.text!,"pincode":PincodeTxt.text!,"address_Type": AddressTxt.text!,"isDefault":setDefaultAdress,"latitude": TapLatitiude,"longitude": TapLongitude]]
                    let headerDict=["Authorization": token]
        WebserviceHelper.sharedInstance.callPostDataWithMethod(methodName: "address/add", requestDict: userlocationDict as [String : [String : Any]] , headerValue: headerDict, isHud: false, hudView: self.view, successBlock:
                        {  response, responseStr in print(response)
                            print("\(responseStr)");
                            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200{
                               self.navigationController!.popToRootViewController(animated: true)
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
