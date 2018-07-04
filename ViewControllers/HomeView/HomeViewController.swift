//
//  HomeViewController.swift
//  GoogleFacebookLogin
//
//  Created by V kishore kumar reddy  on 1/16/18.
//  Copyright © 2018 Raju sharma. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SocketIO

private let reuseIdentifier = "Cell"

//MARK: - Device Orientation

struct Device {
    // iDevice detection code
    static let IS_IPAD             = UIDevice.current.userInterfaceIdiom == .pad
    static let IS_IPHONE           = UIDevice.current.userInterfaceIdiom == .phone
    static let IS_RETINA           = UIScreen.main.scale >= 2.0
    
    static let SCREEN_WIDTH        = Int(UIScreen.main.bounds.size.width)
    static let SCREEN_HEIGHT       = Int(UIScreen.main.bounds.size.height)
    static let SCREEN_MAX_LENGTH   = Int( max(SCREEN_WIDTH, SCREEN_HEIGHT) )
    static let SCREEN_MIN_LENGTH   = Int( min(SCREEN_WIDTH, SCREEN_HEIGHT) )
    
    static let IS_IPHONE_4_OR_LESS = IS_IPHONE && SCREEN_MAX_LENGTH  < 568
    static let IS_IPHONE_5         = IS_IPHONE && SCREEN_MAX_LENGTH == 568
    static let IS_IPHONE_6_OR_IS_IPHONE_6s_OR_IS_IPHONE_7_OR_IS_IPHONE_8  = IS_IPHONE && SCREEN_MAX_LENGTH == 667
    static let IS_IPHONE_6P_OR_IS_IPHONE_6sP_OR_IS_IPHONE_7P_OR_IS_IPHONE_8P  = IS_IPHONE && SCREEN_MAX_LENGTH == 736
    static let IS_IPHONE_X   = IS_IPHONE && SCREEN_MAX_LENGTH == 812
    
   static let IS_IPADMINI = IS_IPAD && SCREEN_MAX_LENGTH == 1024

   static let IS_IPAD_PRO =  IS_IPAD && SCREEN_MAX_LENGTH == 1366

}


class HomeViewController: UIViewController,SlideMenuControllerDelegate,CLLocationManagerDelegate,GMSMapViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,ARCarMovementDelegate
{
   
    //MARK: - IBOutlet and Objects
    
    var Latitiude:Double!
    var Longitude:Double!
    var VehicaleLatitiude:Double!
    var VehicaleLongitude:Double!
    var socketVehicaleLatitiude:Double!
    var socketVehicaleLongitude:Double!
    var alert:UIAlertController?
    //Movng car
//    var mapView : GMSMapView! = nil
    var moveMent = ARCarMovement()
    var drivermarker = GMSMarker()
    var  markerDefault = GMSMarker() 
 //var oldPolylineArr = [GMSPolyline]()
    var polylineArray = [GMSPolyline]()
    
    var oldCoordinate : CLLocationCoordinate2D!
    var curCoordinate : CLLocationCoordinate2D!
    var newCoordinate :CLLocationCoordinate2D!
    var startCoordinate :CLLocationCoordinate2D!
    var local2Coordinate :CLLocationCoordinate2D!

    
   //
    @IBOutlet weak var DurationLBl: UILabel!
    let geocoder = CLGeocoder()
    var checkdatabase : Bool!
    var foundRecord : Bool!
      let dbManager = DBManager()
     var datacheckaddressViewArrayOffer = [NSDictionary]()
    var productArray : NSArray = ["hello1","hello2"]
    var imageUrl:String!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var customObject : HomeModal!
    var routeArray = [HomeModal]()
     var RouteDetailArray : NSArray = []
    var VehicleIDStr : String = ""
    //    var customObject : ProductModel!
    //    var productModelArray = [ProductModel]()
    
    var customObjectproduct : HomeProductListModel!
    var ProductListdetailArray = [HomeProductListModel]()
    var  ProductListArray: NSArray = []
    
    var customObjectproductCategory :productCategoryDetailModel!
    var ProductByCategorydetailArray = [productCategoryDetailModel]()
    var  ProductByCategorylistArray: NSArray = []
    var markerRouteArray :[[String  : Any]] = []
    var sourceLocation = CLLocationCoordinate2D()
    
    var checkStatus : Bool!
    var data1  : NSDictionary = [:] as! [String : Any] as NSDictionary
    var customerId : String = " "

@IBOutlet weak var collectionView: UICollectionView!
@IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var currentUserLBL: UILabel!
    @IBOutlet weak var trackvanLBL: UILabel!
    @IBOutlet weak var googlemapoutlet: GMSMapView!
    @IBOutlet weak var imaage1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var selectedItemView: UIView!
    @IBOutlet weak var menuCollectionView: UIView!
    @IBOutlet weak var mainMapView: UIView!
    @IBOutlet weak var trackVanAddress: UILabel!
    @IBOutlet weak var currentUserAddress: UILabel!
    //double Latitiude,Longitude;
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var mapBtn: UIButton!
    @IBOutlet weak var menuBtn: UIButton!
    
    @IBOutlet weak var segmentControl = UISegmentedControl()
    
    
     ///Collection View
     var collectionArray = [String]()
     var widthCOntent :Int = 0
     var widthimage :Int = 0
    let locationManager = CLLocationManager()
    
    //MARK: - viewDidLoad
 
    override func viewDidLoad()
    {
        //SVN
        
        super.viewDidLoad()
        self.title = " TRACKING FRESH"
        profileWebService()
        appDelegate.windowStatus()
        tableView.delegate=self
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
         tableView.register(UINib(nibName: "OfferTableViewCell", bundle: nil), forCellReuseIdentifier: "OfferTableViewCell")
      
        self.collectionView?.delegate=self
        self.collectionView?.dataSource=self
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        var width = UIScreen.main.bounds.width
        //        let height=UIScreen.main.bounds.height
        layout.sectionInset = UIEdgeInsets(top: 15, left: 13, bottom: 15, right: 13)
        width = width - 38
        layout.itemSize = CGSize(width: width / 2, height: 110)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 15
        collectionArray=["tableicon","chairsicon","sofaicon","cupboardicon"]
        self.collectionView!.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
       
        self.setNavigationBarItem()
      
        let Camera = GMSCameraPosition.camera(withLatitude: 19.1579,
                                              longitude: 72.9935,
                                              zoom: 12)
        
        mapView.camera = Camera
        mapView.isMyLocationEnabled = true
        mapView.mapType = .normal
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        mapView.settings.zoomGestures = true
        mapView.settings.rotateGestures = false
        
        mapView.delegate = self
        self.view.addSubview(mapView)
        locationManager.delegate = self
        self.moveMent.delegate = self;
        CallFBT()

//        self.draw(src: sourcelocation, dst: distinationLocation)
        // Do any additional setup after loading the view.
        
        //Segment Control
        
        if (Device.IS_IPHONE_5)
        {
            segmentControl?.frame  = CGRect(x: 0, y: 520 , width: UIScreen.main.bounds.width, height: 48)
        }
        if (Device.IS_IPHONE_6_OR_IS_IPHONE_6s_OR_IS_IPHONE_7_OR_IS_IPHONE_8)
        {
             segmentControl?.frame  = CGRect(x: 0, y: self.mapView.bounds.size.height + 115 , width: UIScreen.main.bounds.width, height: 60)
        }
        if (Device.IS_IPHONE_6P_OR_IS_IPHONE_6sP_OR_IS_IPHONE_7P_OR_IS_IPHONE_8P)
        {
             segmentControl?.frame  = CGRect(x: 0, y: self.mapView.bounds.size.height + 115 , width: UIScreen.main.bounds.width, height: 66)
        }
        if (Device.IS_IPHONE_X)
        {
            segmentControl?.frame  = CGRect(x: 0, y: self.mapView.bounds.size.height + 118 , width: UIScreen.main.bounds.width, height: 68)
        }
        if (Device.IS_IPADMINI)
        {
            segmentControl?.frame  = CGRect(x: 0, y: self.mapView.bounds.size.height + 110 , width: UIScreen.main.bounds.width, height: 60)

        }
        if (Device.IS_IPAD_PRO)
        {
            segmentControl?.frame  = CGRect(x: 0, y: self.mapView.bounds.size.height + 110 , width: UIScreen.main.bounds.width, height: 60)
        }
        
        //Change text color of UISegmentedControl
        segmentControl?.tintColor = UIColor( red: CGFloat(153/255.0), green: CGFloat(205/255.0), blue: CGFloat(72/255.0), alpha: CGFloat(1.0) )
        
        //Change UISegmentedControl background colour
        segmentControl?.backgroundColor = UIColor.white
        
        
        let attr = NSDictionary(object: UIFont(name: "HelveticaNeue-Bold", size: 16.0)!, forKey: NSAttributedStringKey.font as NSCopying)
        
        segmentControl?.setTitleTextAttributes(attr as [NSObject : AnyObject] , for: .normal)
        
        // Add function to handle Value Changed events
       
        segmentControl?.addTarget(self, action: #selector(HomeViewController.segmentedValueChanged(_:)), for: .valueChanged)
        
        self.view.addSubview(segmentControl!)
       
    }
    
    
    //MARK: - viewWillAppear
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.customerId = UserDefaults.standard.value(forKey: "CustmerID") as! String
        appDelegate.socketManger.defaultSocket.connect()
        locationManager.startUpdatingLocation()
        self.outletMange()
        self.ProductByCategorydetailArray.removeAll()
        self.markerRouteArray.removeAll()
        setBadge()
        if self.ProductListdetailArray.count>0 {
            self.ProductListdetailArray.removeAll()
        }
    }
    
    //MARK: - viewWillDisappear
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        appDelegate.socketManger.defaultSocket.disconnect()
        appDelegate.hideHud()

    }
    
    //MARK: - segmentedValueChanged
    
    @objc func segmentedValueChanged(_ sender:UISegmentedControl!)
    {
        print("Selected Segment Index is : \(sender.selectedSegmentIndex)")
        
        if  sender.selectedSegmentIndex == 0
        {
            print("index 0")
            
            print("segment 0 is selected")
            
            self.outletMange()
            
        }
        else if sender.selectedSegmentIndex == 1
        {
            
            print("index 1")
            
            print("segment 1 is selected")
            
            self.menutapped()
            self.collectionView.reloadData()
            
        }
    }
    
    //MARK: - profileWebService
    
    func profileWebService()
    {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.IsReachabilty!
        {
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
                        
                    }
                    
            }, errorBlock: {error in
                                                                    
            })
        }
        else{
         
            //self.view.makeToast("Please check internet connection", duration: 0.5, position: CSToastPositionCenter)
           
            self.checkInternetConnection()
        }
    }
    
    //MARK: - callActionshitWithTimer
    
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
            self.alert?.addAction(UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.destructive, handler:{ (UIAlertAction)in
             // self.CancelAlert()
            }))
            self.present(self.alert!, animated: true, completion:nil)
        }
    }
    
    //MARK: - textFieldHandler
    
    func textFieldHandler(textField: UITextField!)
    {
        if (textField) != nil {
            textField.placeholder = "Please enter your number"
        }
    }
    
    //MARK: - handlePromocode
   
    func handlePromocode(code: String) -> Void
    {
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
    
     //MARK: - SendOTPAPI
    
    func SendOTPAPI(alertText : String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.IsReachabilty! {
                let auth = UserDefaults.standard.value(forKey: "user_auth_token")!
                let token = "\(WebseviceNameConstant.StrJWT)\(auth)"
                let userlocationDict = ["post":["mobileNo":alertText,"id":self.customerId]]
                let headerDict=["Authorization": token]
                
                WebserviceHelper.sharedInstance.callPostDataWithMethod(methodName: "OTP/sendOtp/", requestDict:userlocationDict , headerValue: headerDict, isHud: false, hudView: self.view, successBlock:
                    {  response, responseStr in print(response)
                        print("\(responseStr)");
                        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200{
                        self.alert?.dismiss(animated: true, completion: nil)
                            
                            let numberVerificationViewController: NumberVerificationViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NumberVerificationViewController") as! NumberVerificationViewController
                            numberVerificationViewController.mobileNo = alertText
                            numberVerificationViewController.customerID = self.customerId
                
                self.navigationController?.pushViewController(numberVerificationViewController, animated: true)
               // self.present(numberVerificationViewController, animated: true, completion: nil)

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
    
    //MARK: - mobileNOverify
    
    func mobileNOverify()  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.IsReachabilty! {
            let auth = UserDefaults.standard.value(forKey: "user_auth_token")!
            let token = "\(WebseviceNameConstant.StrJWT)\(auth)"
            let headerDict=["Authorization": token]
            
            WebserviceHelper.sharedInstance.callMobileVerifyGetDataWithMethod(strMethodName:"customer/isMobile/", requestDict: self.customerId, isHud: false, hudView: self.view, value: headerDict, successBlock:
                {  response, responseStr in print(response)
                    print("\(responseStr)");
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200{
                        self.checkStatus = (responseStr["status"] as? Bool)!
                        if  !self.checkStatus!  {
                            self.callActionshitWithTimer()
                        }
                    }
                    else{
                        let userDict=responseStr ["user_msg"] as? String
                        self.view.makeToast(userDict as? String, duration: 0.5, position: CSToastPositionCenter)
                        
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
    
    //MARK: - nearrestRoute
    
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
                            let cordinateDict = locationDict["coordinates"] as! NSArray
                            
                            if cordinateDict.count>0{
                                self.VehicaleLongitude = cordinateDict[0] as! Double
                                self.VehicaleLatitiude = cordinateDict[1] as! Double
                            }else{
                                let locationDestination = CLLocationCoordinate2DMake(self.Latitiude,self.Longitude)
                                self.markerDefault.position = locationDestination
                                self.markerDefault.icon = UIImage(named: "ic_customer_marker")
                                self.markerDefault.infoWindowAnchor = CGPoint(x: 0.5,y :0.2)
                                self.markerDefault.accessibilityLabel = "\(1000)"
                                self.markerDefault.map = self.mapView
                                UserDefaults.standard.set(" ", forKey:"Distance")
                                UserDefaults.standard.synchronize()
                                return
                            }
                            
                            self.VehicaleLongitude = cordinateDict[0] as! Double
                            self.VehicaleLatitiude = cordinateDict[1] as! Double
                            self.drivermarker.position = CLLocationCoordinate2D(latitude:self.VehicaleLatitiude as! CLLocationDegrees, longitude:self.VehicaleLongitude as! CLLocationDegrees)
                             self.drivermarker.icon = UIImage(named: "movingCar")
                            self.drivermarker.map = self.mapView
                            self.drivermarker.title = "TKF Vechile";
                            self.drivermarker.accessibilityLabel = "\(100)"
                            let updatedCamera = GMSCameraUpdate.setTarget(self.drivermarker.position, zoom: 15.0)
                            self.mapView.animate(with: updatedCamera)
                            self.oldCoordinate = CLLocationCoordinate2D(latitude:self.VehicaleLatitiude as! CLLocationDegrees, longitude:self.VehicaleLongitude as! CLLocationDegrees)
                            self.getLocationTime(lat1: self.Latitiude, lon1: self.Longitude, lat2: self.VehicaleLatitiude, lon2: self.VehicaleLongitude)
                            if self.RouteDetailArray.count > 0 {
                                self.routeArray.removeAll()
                            }
                            for i in 0..<(self.RouteDetailArray.count){
                                self.customObject=HomeModal()
                                let dictValue = self.RouteDetailArray[i] as! NSDictionary as! [String : Any]
                                self.customObject.initdata(Dict: dictValue)
                                self.routeArray.append( self.customObject)
                                UserDefaults.standard.set(self.customObject.vehicleId, forKey: "VehicleID")
                                UserDefaults.standard.synchronize()
                                 DispatchQueue.main.async {
                                self.productCategoryMethod(VehicaleID :self.customObject.vehicleId )
                                }
                                self.VehicleIDStr = self.customObject.vehicleId
                            }
                           self.mobileNOverify()
                            self.mapViewWithMarker()
                        }else{
                            let locationDestination = CLLocationCoordinate2DMake(self.Latitiude,self.Longitude)
                            self.markerDefault.position = locationDestination
                            self.markerDefault.icon = UIImage(named: "ic_customer_marker")
                            self.markerDefault.infoWindowAnchor = CGPoint(x: 0.5,y :0.2)
                            self.markerDefault.accessibilityLabel = "\(1000)"
                            self.markerDefault.map = self.mapView
                            self.getLocationAddress(lat: latitiude, long: longitude)
                            UserDefaults.standard.set("", forKey: "VehicleID")
                            UserDefaults.standard.synchronize()
                              self.appDelegate.hideHud()
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
   
    
    
    //MARK: - Moving car
    
    func ARCarMovementMoved(_ Marker: GMSMarker) {
       // self.getPolylineRoute(from: CLLocationCoordinate2D(latitude:Latitiude, longitude:Longitude), to: Marker.position, userVehcleline:"yes")
        drivermarker = Marker;
        drivermarker.map = mapView;
        let updatedCamera = GMSCameraUpdate.setTarget(drivermarker.position, zoom: 14.0)
        mapView.animate(with: updatedCamera)
    }
    
    
    //MARK: - mapViewWithMarker
    
    func mapViewWithMarker()  {
    for i in 0..<(routeArray.count) {
            var Data1:HomeModal
            Data1 = self.routeArray[i]
            let userlocation = Data1.userLatLong
            let userLat = userlocation![1]
            let userLong = userlocation![0]
        sourceLocation = CLLocationCoordinate2DMake(userLat as! CLLocationDegrees, userLong as! CLLocationDegrees)
        self.markerDefault.position = CLLocationCoordinate2D(latitude:Latitiude, longitude:Longitude)
        self.markerDefault.icon = UIImage(named: "ic_customer_marker")
        self.markerDefault.map = mapView
        self.markerDefault.title = "user location";
        self.getPolylineRoute(from: CLLocationCoordinate2D(latitude:Latitiude, longitude:Longitude), to: self.oldCoordinate, userVehcleline:"yes")
        appDelegate.socketManger.defaultSocket.onAny(){
            any in
        if any.event != " "{
            if any.event == "vehiclePosition"{
                print(any.items as NSArray!)
                let vehicleArray = any.items as NSArray!
                let vehicleDict = vehicleArray![0] as! NSDictionary
                let vehiclemainDict = vehicleDict["data"] as! NSDictionary
                let vehicleID = vehiclemainDict["vehicle_id"] as! String
                let geoDict = vehiclemainDict["geo"] as! NSDictionary
                let coordinateArray = geoDict["coordinates"] as! NSArray
                self.socketVehicaleLongitude = coordinateArray[0] as! Double
                self.socketVehicaleLatitiude = coordinateArray[1] as! Double
                if vehicleID == self.VehicleIDStr {
                    
                    self.drivermarker.position = CLLocationCoordinate2D(latitude:self.socketVehicaleLatitiude as! CLLocationDegrees, longitude:self.socketVehicaleLongitude as! CLLocationDegrees)
                    self.newCoordinate = CLLocationCoordinate2D(latitude:self.socketVehicaleLatitiude as! CLLocationDegrees, longitude:self.socketVehicaleLongitude as! CLLocationDegrees)
                    self.getPolylineRoute(from: CLLocationCoordinate2D(latitude:self.Latitiude, longitude:self.Longitude), to: self.newCoordinate, userVehcleline:"yes")
                    self.getLocationTime(lat1: self.Latitiude, lon1: self.Longitude, lat2: self.socketVehicaleLatitiude, lon2: self.socketVehicaleLongitude)
                    let dictLocation = ["lat":self.socketVehicaleLatitiude,"long":self.socketVehicaleLongitude]
                    
                    UserDefaults.standard.set(dictLocation, forKey: "oldVehicle")
                    UserDefaults.standard.synchronize()
                    self.drivermarker.icon = UIImage(named: "movingCar")
                    self.drivermarker.map = self.mapView
                    self.drivermarker.title = "TKF Vechile";
                    self.drivermarker.accessibilityLabel = "\(100)"
                    self.moveMent.ARCarMovement(marker: self.drivermarker, oldCoordinate: self.oldCoordinate, newCoordinate: self.newCoordinate, mapView:self.mapView, bearing: 0)
                    self.oldCoordinate = self.newCoordinate;
                    
                }
                
            }else
            {
                
                let vehicleLocationInfoDict  = UserDefaults.standard.object(forKey: "oldVehicle") as?Dictionary<String,Any>
                if vehicleLocationInfoDict != nil{
                    self.drivermarker.map = nil
                    let lat = vehicleLocationInfoDict!["lat"] as! Double
                    let long = vehicleLocationInfoDict!["long"] as! Double
                    self.drivermarker.position = CLLocationCoordinate2D(latitude:lat, longitude:long)
                    self.getPolylineRoute(from: CLLocationCoordinate2D(latitude:self.Latitiude, longitude:self.Longitude), to: CLLocationCoordinate2D(latitude:lat, longitude:long), userVehcleline:"yes")
                    self.drivermarker.icon = UIImage(named: "movingCar")
                    self.drivermarker.map = self.mapView
                    self.drivermarker.title = "TKF Vechile";
                    self.drivermarker.accessibilityLabel = "\(100)"
                }else{
                    self.drivermarker.map = nil
                    self.drivermarker.position = CLLocationCoordinate2D(latitude:self.VehicaleLatitiude as! CLLocationDegrees, longitude:self.VehicaleLongitude as! CLLocationDegrees)
                    
                    self.drivermarker.icon = UIImage(named: "movingCar")
                    self.drivermarker.map = self.mapView
                    self.drivermarker.title = "TKF Vechile";
                    self.drivermarker.accessibilityLabel = "\(100)"
                }

                
                
            }
        }
    }
        
    //MARK: - For loop
     
    for i in 0..<(Data1.routeArray.count){
            let   dictRoute  = Data1.routeArray[i] as! [String  : Any]
            markerRouteArray.append(dictRoute)
            let geoDict = dictRoute["geo"] as! [String  : Any]
            let coordinateArray  = geoDict["coordinates"] as! NSArray
            let longValueGeo = coordinateArray[0]
            let latValueGeo = coordinateArray[1]
            let locationDestination = CLLocationCoordinate2DMake(latValueGeo as! CLLocationDegrees, longValueGeo as! CLLocationDegrees)
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude:latValueGeo as! CLLocationDegrees, longitude:longValueGeo as! CLLocationDegrees)
            marker.icon = UIImage(named: "ic_locationRed")
            marker.infoWindowAnchor = CGPoint(x: 0.5,y :0.2)
            marker.accessibilityLabel = "\(i)"
            marker.map = mapView
            if i == 0{
                self.getPolylineRoute(from: locationDestination, to: locationDestination, userVehcleline:"no")
                self.local2Coordinate = locationDestination
            }else{
                self.getPolylineRoute(from: self.local2Coordinate, to: locationDestination, userVehcleline: "no")
            }
        
        }
     
      }
    
    }
    
    //MARK: - productCategoryMethod
    
    func productCategoryMethod(VehicaleID : String )
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.IsReachabilty! {
            let auth = UserDefaults.standard.value(forKey: "user_auth_token")!
            let token = "\(WebseviceNameConstant.StrJWT)\(auth)"
            let headerDict=["Authorization": token]
            let dict = ["vehicleId":VehicaleID]
            WebserviceHelper.sharedInstance.callGetDataWithMethod(strMethodName:"productCategory/vehicle/list", requestDict: dict, isHud: false, hudView: self.view, value: headerDict, successBlock:
                {  response, responseStr in print(response)
                    print("\(responseStr)");
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200{
                        if self.ProductListdetailArray.count>0{
                            self.ProductListdetailArray.removeAll()
                        }
                        self.ProductListArray = (responseStr["data"] as! NSArray)
                        for i in 0..<(self.ProductListArray.count)
                        {
                            self.customObjectproduct = HomeProductListModel()
                            let dictValue = self.ProductListArray[i] as! NSDictionary as! [String : Any]
                            self.customObjectproduct.initdata(Dict: dictValue)
                            self.ProductListdetailArray.append( self.customObjectproduct)
                        }
                        let menuCheck = UserDefaults.standard.value(forKey: "menu") as! String
                        if menuCheck == "map"
                       {
//                    appDelegate.flag = ""
//                        UserDefaults.standard.set( appDelegate.flag, forKey: "menu")
//                        UserDefaults.standard.synchronize()
                       }else{
                            appDelegate.hideHud()
                            self.view.updateFocusIfNeeded()
                            self.view.updateConstraints()
                        self.menutapped()
                        
                        self.collectionView.reloadData()
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
         //   self.view.makeToast("Please check internet connection", duration: 0.5, position: CSToastPositionCenter)
            
            self.checkInternetConnection()

        }
        
    }
    
    //MARK: - productCategoryBycategory
  
    func productCategoryBycategory(categoryId : String,vehicleId: String)  {
       
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.IsReachabilty! {
            let auth = UserDefaults.standard.value(forKey: "user_auth_token")!
            let token = "\(WebseviceNameConstant.StrJWT)\(auth)"
            let headerDict=["Authorization": token]
            let dict = ["categoryId":categoryId,"vehicleId":vehicleId]
            WebserviceHelper.sharedInstance.callGetDataWithMethod(strMethodName:"product/byCategory", requestDict: dict, isHud: false, hudView: self.view, value: headerDict, successBlock:
                {  response, responseStr in print(response)
                    print("\(responseStr)");
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200{
                        if self.ProductByCategorydetailArray.count>0 {
                            self.ProductByCategorydetailArray.removeAll()
                        }
                        self.ProductByCategorylistArray = responseStr["data"] as! NSArray
                        for i in 0..<(self.ProductByCategorylistArray.count) {
                            self.customObjectproductCategory = productCategoryDetailModel()
                            let dictValue = self.ProductByCategorylistArray[i] as! NSDictionary as! [String : Any]
                            self.customObjectproductCategory.initdata(Dict: dictValue)
                            self.ProductByCategorydetailArray.append( self.customObjectproductCategory)
                        }
                        self.tableView .reloadData()
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
            //self.view.makeToast("Please check internet connection", duration: 0.5, position: CSToastPositionCenter)
            
            self.checkInternetConnection()

        }
        
    }
    
    //MARK: - outletMange
    
    func outletMange(){
        currentUserLBL.isHidden = false
        trackvanLBL.isHidden = false
        mapView.isHidden = false
        imaage1.isHidden = false
        image2.isHidden = false
        selectedItemView.isHidden = true
        menuCollectionView.isHidden = true
        if self.RouteDetailArray.count != 0{
        let str = UserDefaults.standard.value(forKey: "Distance") as! String
        if str != nil{
        let duration11 = "Duration:"+str+" away"
        self.appDelegate.showCustomLabelONmap(time:duration11)

            }

        }
    }
    
    //MARK: - menutapped
    
    func menutapped(){
        currentUserLBL.isHidden = true
        trackvanLBL.isHidden = true
        mapView.isHidden = true
        imaage1.isHidden = true
        image2.isHidden = true
        selectedItemView.isHidden = true
        menuCollectionView.isHidden = false
        self.appDelegate.hideHud()
    if self.RouteDetailArray.count == 0{
    self.view.makeToast("Sorry! We don't sever on this route currently!!!", duration: 1.5, position: CSToastPositionCenter)
     return
    }
    
  }
    
    //MARK: - selectedItemView1
    
    func selectedItemView1(){
        currentUserLBL.isHidden = true
        trackvanLBL.isHidden = true
        mapView.isHidden = true
        imaage1.isHidden = true
        image2.isHidden = true
        selectedItemView.isHidden = false
        menuCollectionView.isHidden = true
        self.appDelegate.hideHud()

        
    }
    
    //MARK: - CLLocationManagerDelegate
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
                if let location = locations.first {
                    mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 10)
                    Latitiude = location.coordinate.latitude
                    Longitude = location.coordinate.longitude
                      self.getLocationAddress(lat: Latitiude, long: Longitude)
                     locationManager.stopUpdatingLocation()
                self.startCoordinate = CLLocationCoordinate2D(latitude:self.Latitiude as! CLLocationDegrees, longitude:self.Longitude as! CLLocationDegrees)
                 self.latlongCalledMethod(userlat1: Latitiude, userlon1: Longitude)
              self.nearrestRoute(latitiude:location.coordinate.latitude,  longitude :location.coordinate.longitude)
                   
        }
    }

//    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
//        self.markerDefault.icon = UIImage(named: "ic_customer_marker")
//        self.markerDefault.position = position.target
//    }
    
    func getLocationAddress(lat: Double, long : Double)  {

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.IsReachabilty! {
            let latLong = String(lat) + "," + String(long)
            let url : String = "https://maps.googleapis.com/maps/api/geocode/json"
            let postParameters:[String: Any] = [ "latlng": latLong,"sensor":"true","key":"AIzaSyBLJXOi6SbSr84xlOwOqcHtyQdGCnFGJIA"]
            
            WebserviceHelper.sharedInstance.callGoogleAPiAddress(strMethodName:url, requestDict: postParameters, isHud: false, hudView: self.view, value:[:], successBlock:
                {  response, responseStr in print(response)
                    print("\(responseStr)");
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200{
                   let AddressArray = responseStr["results"] as! NSArray
                        let dictAddress = AddressArray[0] as? NSDictionary
                        let fulladdress = dictAddress!["formatted_address"] as! String
                       self.currentUserAddress.text = fulladdress
                    
                    }
            },
                errorBlock: {error in
        //            self.view.makeToast(error.d as String, duration: 0.5, position: CSToastPositionCenter)

            })
        }
        else{
          //  self.view.makeToast("Please check internet connection", duration: 0.5, position: CSToastPositionCenter)
            
            self.checkInternetConnection()

        }

    }

    func getLocationTime(lat1:Double, lon1:Double, lat2:Double, lon2:Double)  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.IsReachabilty! {
            let userlatLong = String(lat1) + "," + String(lon1)
            let vehiclelatLong = String(lat2) + "," + String(lon2)
            let url : String = "https://maps.googleapis.com/maps/api/distancematrix/json"
            let postParameters:[String: Any] = ["origins": userlatLong,"destinations": vehiclelatLong,"mode":"driving","language":"en-EN","sensor":"false","key":"AIzaSyBLJXOi6SbSr84xlOwOqcHtyQdGCnFGJIA"]
            WebserviceHelper.sharedInstance.callGoogleAPiAddress(strMethodName:url, requestDict: postParameters, isHud: false, hudView: self.view, value:[:], successBlock:
                {  response, responseStr in print(response)
                    print("\(responseStr)");
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200{
                        let destination_addresses = responseStr["destination_addresses"] as! NSArray
                        var straddress : String! = " "
                        var orginaddress : String! = " "
                        for i in 0..<(destination_addresses.count)  {
                           let straddress1 =  destination_addresses[i] as! String
                            straddress = straddress1 +  straddress
                        }
                        let origin_addresses = responseStr["origin_addresses"] as! NSArray
                        for i in 0..<(origin_addresses.count)  {
                           let  orginaddress1 = origin_addresses[i] as! String
                           orginaddress = orginaddress1 + orginaddress
                            
                        }
                        self.currentUserAddress.text = orginaddress
                        let rows = responseStr["rows"] as! NSArray
                        let dictelements = rows[0] as! NSDictionary
                        let elementArray = dictelements["elements"] as! NSArray
                        let distanceDict = elementArray[0] as! NSDictionary
                        let distance = distanceDict["distance"] as! NSDictionary
                        let Vehicledistancefromuser = distance["text"] as! String
                        self.trackVanAddress.text = "Vehicle is " +  Vehicledistancefromuser  + " away at "
                        + straddress
                        print(Vehicledistancefromuser)
                        let duration = distanceDict["duration"] as! NSDictionary
                        let timetakenfromVehicleToUser = duration["text"] as! String
                        UserDefaults.standard.set(timetakenfromVehicleToUser, forKey:"Distance")
                        UserDefaults.standard.synchronize()
                        let timestr = "Duration:" + " " + timetakenfromVehicleToUser + " " + "away"
                        self.appDelegate.showCustomLabelONmap(time:timestr)
                        print(timetakenfromVehicleToUser)
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
    
    func draw(src: CLLocationCoordinate2D, dst: CLLocationCoordinate2D){
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(src.latitude),\(src.longitude)&destination=\(dst.latitude),\(dst.longitude)&sensor=false&mode=Driving&key=AIzaSyBLJXOi6SbSr84xlOwOqcHtyQdGCnFGJIA")!
//        AIzaSyAnMmIt4AHmAYyW0qOW9J1nz2DW5tkEAls
//        AIzaSyCUG6aEWlobrSvAwrfBMa_qMbi2b5b3WY8
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                do {
                    if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] {
                        
                        let preRoutes = json["routes"] as! NSArray
                        let routes = preRoutes[0] as! NSDictionary
                        let routeOverviewPolyline:NSDictionary = routes.value(forKey: "overview_polyline") as! NSDictionary
                        let polyString = routeOverviewPolyline.object(forKey: "points") as! String
                        
                        DispatchQueue.main.async(execute: {
                            let path = GMSPath(fromEncodedPath: polyString)
                            let polyline = GMSPolyline(path: path)
                            polyline.strokeWidth = 5.0
                            polyline.strokeColor = UIColor.green
                            polyline.map = self.mapView
                        })
                    }
                    
                } catch {
                    print("parsing error")
                }
            }
        })
        task.resume()
    }
    
    //user_location_name
    func getPolylineRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D,userVehcleline:String){
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url = URL(string: "http://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=driving")!
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }else{
                do {
                    if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]{
                        let routes = json["routes"] as? [Any]
                        if (routes?.count)! > 0 {
                            let routeDict = routes?[0] as! Dictionary<String,Any>
                            var arrLeg = routeDict["legs"] as? [Any]
                            var dictleg = arrLeg?[0] as? Dictionary<String,Any>
                            let duration = dictleg?["duration"] as? Dictionary<String,Any>
                            let distance = dictleg?["distance"] as? Dictionary<String,Any>
                           
                            func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
                                return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
                            }
                            
                            func metersToKiloMeters (meters : Int) -> (Int) {
                                return (meters/1000)
                            }
                          
                            let overview_polyline = routeDict["overview_polyline"] as? [AnyHashable: Any]
                            let polyString = overview_polyline?["points"] as?String
                            DispatchQueue.main.async {
                                self.showPath(polyStr: polyString!,userVehcleline:userVehcleline)

                            }
                        }
                    }
                }catch{
                    print("error in JSONSerialization")
                }
            }
        })
        task.resume()
    }
    //MARK: -
    func showPath(polyStr :String,userVehcleline:String){
        if userVehcleline == "yes" {
           
                let path = GMSPath(fromEncodedPath: polyStr)
                DispatchQueue.main.async
                    {
                        let polyline = GMSPolyline(path: path)
                        //MARK: remove the old polyline from the GoogleMap
                        for root: GMSPolyline in self.polylineArray {
                            if root.userData as! String == "root" {
                                root.map = nil
                            }
                        }
                        polyline.strokeWidth = 5.0
                        polyline.strokeColor = UIColor.blue
                        polyline.userData = "root"
                        polyline.map = self.mapView
                        let bounds = GMSCoordinateBounds(path: path!)
                        self.polylineArray.append(polyline)
                        //self.mapView!.moveCamera(update)
                }
            
            
//            let path = GMSPath(fromEncodedPath: polyStr)
//            let polyline = GMSPolyline(path: path)
//            let polyline1 = polyline
//            if oldPolylineArr.count > 0  {
//                for p in (0 ..< oldPolylineArr.count) {
//                   oldPolylineArr[p].map = nil
//                }
//
//            }else{
//                 oldPolylineArr.append(polyline)
//            }
//
//            polyline1.strokeWidth = 5.0
//            polyline1.strokeColor = UIColor.blue
//            polyline1.map = mapView

        }else{
            let path = GMSPath(fromEncodedPath: polyStr)
            let polyline = GMSPolyline(path: path)
            polyline.strokeWidth = 5.0
            polyline.strokeColor = UIColor.darkGray
             polyline.map = mapView
        }
       // Your map view
        
    }
    
    //MARK: - MainMapBtn_Clicked
    
    @IBAction func MainMapBtn_Clicked(_ sender: UIButton) {
        
       self.outletMange()
        
       
    }
    
    //MARK: - MenuBtnClicked
    
    @IBAction func MenuBtnClicked(_ sender: Any)
    {
       self.menutapped()
        self.collectionView.reloadData()

    }
    
    //MARK: - setBadge
    
    func setBadge(){
        // badge label
        DispatchQueue.main.async {
            // badge label
            self.appDelegate.label = UILabel(frame: CGRect(x: 20, y: 1, width:18, height: 18))
            self.appDelegate.label?.layer.borderColor = UIColor.clear.cgColor
            self.appDelegate.label?.layer.borderWidth = 1
            self.appDelegate.label?.layer.cornerRadius = (self.appDelegate.label?.bounds.size.height)! / 2
            self.appDelegate.label?.textAlignment = .center
            self.appDelegate.label?.layer.masksToBounds = true
            self.appDelegate.label?.font = UIFont(name: "System", size: 3)
            self.appDelegate.label?.textColor = .white
            self.appDelegate.label?.backgroundColor = CommonMethod.hexStringToUIColor(hex:"#8dc33b")
            
            let cartcount =  UserDefaults.standard.integer(forKey: "cartcount")
            DispatchQueue.main.async {
                self.appDelegate.label?.text = String(cartcount)
            }
            // button
            let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            rightButton.setBackgroundImage(UIImage(named: "cart-1"), for: .normal)
            rightButton.addTarget(self, action: #selector(self.rightButtonTouched), for: .touchUpInside)
            rightButton.backgroundColor = UIColor.clear
            rightButton.addSubview(self.appDelegate.label!)
            let rightBarButtomItem = UIBarButtonItem(customView: rightButton)
            self.navigationItem.rightBarButtonItem = rightBarButtomItem
            let rotationAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.y")
            rotationAnimation.toValue = 2 * Double.pi
            rotationAnimation.duration = 2.0
            rotationAnimation.isCumulative = true
            rotationAnimation.speed = 1.5
            rotationAnimation.repeatCount = 2
            self.appDelegate.label?.layer.add(rotationAnimation, forKey: "rotationAnimation")
        }
        
    }
    
    //MARK: - rightButtonTouched
    
    @objc func rightButtonTouched() {
        let storyboard: MyCartViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyCartViewController") as! MyCartViewController
       let nav = UINavigationController(rootViewController: storyboard)
        self.slideMenuController()?.changeMainViewController(nav, close: true)
//        self.navigationController?.pushViewController(storyboard, animated: true)
        
    }
    
    //MARK: - Collection view Delegate & Data Source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        print("collection item\(collectionArray.count)")
        return 1
    }
    
   
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.ProductListdetailArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeCollectionViewCell
      
        var productData:HomeProductListModel
        productData = self.ProductListdetailArray[indexPath.row]
        cell.productImageView.sd_setImage(with: URL(string:(productData.categoryImage)!), placeholderImage: UIImage(named: " "))
        cell.productName.text = productData.categoryName
//        cell.productName.text = "Lays"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        var productData:HomeProductListModel
        productData = self.ProductListdetailArray[indexPath.row]
        self.productCategoryBycategory(categoryId: productData._id!, vehicleId: self.VehicleIDStr)
        self.selectedItemView1()

    }
    
  

    //MARK: - TableView Delegate & Data Source
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ProductByCategorydetailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
          let cell :OfferTableViewCell = tableView.dequeueReusableCell(withIdentifier: "OfferTableViewCell") as! OfferTableViewCell!
        var productDetail:productCategoryDetailModel
        productDetail = self.ProductByCategorydetailArray[indexPath.row]
        
        cell.offerImage.sd_setImage(with: URL(string:(productDetail.productImage)), placeholderImage: UIImage(named: " "))
        cell.offerproductName.text = productDetail.productName
        cell.offerProductQuantity.text = productDetail.quantity + " quantity"
        cell.OfferProuctRate.text =  DeviceSizeConstants.rupee +  productDetail.selling_price
        cell.offerPrice.text =  DeviceSizeConstants.rupee + productDetail.MRP!
        cell.offerCartBtn.tag = indexPath.row
        cell.offerPlusBtn.tag = indexPath.row
        cell.offerMinusBtn.tag = indexPath.row
        // new changs
        
        cell.offerMinusBtn.isHidden = true
        cell.offerPlusBtn.isHidden = true
        cell.offerCartBtn.isHidden = false
        cell.offerQtyIncrease.isHidden = true
        cell.multiplyLbl.isHidden = true
        
      cell.offerCartBtn.addTarget(self, action: #selector(CartBtnClicked(_:)), for:.touchUpInside)
     cell.offerPlusBtn.addTarget(self, action: #selector(offerPlusBtnClicked(_:)), for:.touchUpInside)
     cell.offerMinusBtn.addTarget(self, action: #selector(offerminusBtnClicked(_:)), for:.touchUpInside)
        
       
//        cell.cellImageView.sd_setImage(with: URL(string:imageUrl), placeholderImage: UIImage(named: "chky-1"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 133
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var productDetail:productCategoryDetailModel
        productDetail = self.ProductByCategorydetailArray[indexPath.row]
    let productItemViewController: ProductItemViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductItemViewController") as! ProductItemViewController
        productItemViewController.navTitle = productDetail.productName
       productItemViewController.ProductselectedCategory =  self.ProductByCategorydetailArray[indexPath.row]
        self.navigationController?.pushViewController(productItemViewController, animated: true)
    }
    
    //MARK: - CartBtnClicked
    
    @objc func CartBtnClicked(_ sender : UIButton) {
        var productDetail:productCategoryDetailModel
        productDetail = self.ProductByCategorydetailArray[sender.tag]
        checkdatabase = dbManager.createDatabase()
        datacheckaddressViewArrayOffer = dbManager.loadAddresss() as! [NSDictionary]
        let cell = sender.superview?.superview?.superview as? OfferTableViewCell
        
        if datacheckaddressViewArrayOffer.count == 0  {
            let dict = ["_id":productDetail._id,
                        "productId": productDetail.productId,
                        "quantity":"1",
                        "unitsOfMeasurement": productDetail.unitsOfMeasurement,
                        "productName":productDetail.productName,
                        "unit": productDetail.unit,
                        "productDetails": productDetail.productDetails,
                        "productImage": productDetail.productImage,
                        "brand": productDetail.brand,
                        "selling_price":productDetail.selling_price,
                        "offer":" ",
                        "MRP": productDetail.MRP,
                        "QuantityinStock": productDetail.quantity  ]
            dbManager.insertMovieData(Dict: dict as! [String : String])
            
            let cartcount =  UserDefaults.standard.integer(forKey: "cartcount")
            let incraseCount = cartcount + 1
            appDelegate.label?.text = String(incraseCount)
            
            UserDefaults.standard.set(incraseCount, forKey: "cartcount")
        }else{
            
            datacheckaddressViewArrayOffer = dbManager.loadAddresss() as! [NSDictionary]
            foundRecord = false
            for i in 0..<(datacheckaddressViewArrayOffer.count){
                let dbDict = datacheckaddressViewArrayOffer[i] as! [String : Any]
                let dbproductid = dbDict["productId"] as! String
                let offerproductid = productDetail.productId
                if dbproductid == offerproductid {
                    foundRecord = true
                    self.view.makeToast("Product is already in Cart.", duration: 1.0, position: CSToastPositionCenter)
                }
                
            }
            
            if foundRecord == false{
                var qty: String!
                if datacheckaddressViewArrayOffer.count == 0{
                    qty = "1"
                }else{
                    qty = "1"
                    for i in 0..<(datacheckaddressViewArrayOffer.count){
                        let dbDict = datacheckaddressViewArrayOffer[i] as! [String : Any]
                        let dbproductid = dbDict["productId"] as! String
                        let offerproductid = productDetail.productId
                        if dbproductid == offerproductid {
                            qty = dbDict["quantity"] as! String
                        }
                    }
                    
                }
                
                let dict = ["_id":productDetail._id,
                            "productId": productDetail.productId,
                            "quantity":qty,
                            "unitsOfMeasurement": productDetail.unitsOfMeasurement,
                            "productName":productDetail.productName,
                            "unit": productDetail.unit,
                            "productDetails": productDetail.productDetails,
                            "productImage": productDetail.productImage,
                            "brand": productDetail.brand,
                            "selling_price":productDetail.selling_price,
                            "offer":" ",
                            "MRP": productDetail.MRP,
                            "QuantityinStock": productDetail.quantity]
                dbManager.insertMovieData(Dict: dict as! [String : String])
                let cartcount =  UserDefaults.standard.integer(forKey: "cartcount")
                let incraseCount = cartcount + 1
                UserDefaults.standard.set(incraseCount, forKey: "cartcount")
                appDelegate.label?.text = String(incraseCount)
                
            }
            
        }
        cell?.offerPlusBtn.isHidden = false
        cell?.offerMinusBtn.isHidden = false
        cell?.offerCartBtn.isHidden = true

            if datacheckaddressViewArrayOffer.count == 0{
                cell?.multiplyLbl.isHidden = false
                cell?.offerQtyIncrease.isHidden = false
                cell?.offerQtyIncrease.text = "1"
            }else{
                datacheckaddressViewArrayOffer = dbManager.loadAddresss() as! [NSDictionary]
                for i in 0..<(datacheckaddressViewArrayOffer.count){
                    let dbDict1 = datacheckaddressViewArrayOffer[i] as! [String : Any]
                    let dbproductid = dbDict1["productId"] as! String
                    let offerproductid = productDetail.productId
                    if dbproductid == offerproductid {
                        if dbDict1["quantity"] as? String == "0" {
                            cell?.offerQtyIncrease.text = "1"
                            cell?.multiplyLbl.isHidden = false
                            cell?.offerQtyIncrease.isHidden = false
                        }else{
                            cell?.offerQtyIncrease.text = dbDict1["quantity"] as? String
                            cell?.multiplyLbl.isHidden = false
                            cell?.offerQtyIncrease.isHidden = false
                        }
                       
                        
                    }
                }
            }
            
//        }
    }
    
    //MARK: -  offerPlusBtnClicked
    
    @objc func offerPlusBtnClicked(_ sender : UIButton) {
        print(sender.tag)
        
        let cell = sender.superview?.superview?.superview as? OfferTableViewCell
        var productDetail:productCategoryDetailModel!
        productDetail = self.ProductByCategorydetailArray[sender.tag]
        let qty = cell?.offerQtyIncrease!.text
        if Int(qty!)! < Int(productDetail.quantity)! {
        let addtion = Int(qty!)! + 1
        //cell?.offerQtyIncrease.text = "\(addtion)"
        // UserDefaults.standard.set(addtion, forKey: "CountQty")
        // UserDefaults.standard.synchronize()
        
        checkdatabase=dbManager.createDatabase()
        datacheckaddressViewArrayOffer = dbManager.loadAddresss() as! [NSDictionary]
        
        for i in 0..<(datacheckaddressViewArrayOffer.count){
            let dbDict = datacheckaddressViewArrayOffer[i] as! [String : Any]
            let dbproductid = dbDict["productId"] as! String
            let offerproductid = productDetail.productId
            if dbproductid == offerproductid {
                var updateRecordDatabase1 : Bool = false
                updateRecordDatabase1 = dbManager.updateCart(productID: dbDict["productId"] as! String, quantity:"\(addtion)")
                // }
                
            }
            
        }
        cell?.offerQtyIncrease!.text = String(addtion)
        }else{
            self.view.makeToast("Product quantity Available", duration: 1.0, position: CSToastPositionCenter)
            
        }
    }
    
    //MARK: -  offerminusBtnClicked
    
    @objc func offerminusBtnClicked(_ sender : UIButton) {
        print(sender.tag)
        let cell = sender.superview?.superview?.superview as? OfferTableViewCell
        var productDetail:productCategoryDetailModel!
        productDetail = self.ProductByCategorydetailArray[sender.tag]
        let qty = cell?.offerQtyIncrease!.text
        
        
        let addtion = Int(qty!)! - 1
        if addtion == 0 {
            cell?.multiplyLbl.isHidden = true
            cell?.offerQtyIncrease.text = "1"
            cell?.offerPlusBtn.isHidden = true
            cell?.offerMinusBtn.isHidden = true
            cell?.offerCartBtn.isHidden = false
            cell?.offerQtyIncrease.isHidden = true
            var deleteRecordDatabase : Bool = false
            deleteRecordDatabase = dbManager.deleteRecord(withID:productDetail.productId)
            if(deleteRecordDatabase == true){
                let cartcount =  UserDefaults.standard.integer(forKey: "cartcount")
                let incraseCount = cartcount - 1
                UserDefaults.standard.set(incraseCount, forKey: "cartcount")
                self.appDelegate.label?.text = String(incraseCount)
            }
        }
        else{
            cell?.offerQtyIncrease.text = "\(addtion)"
            /// UserDefaults.standard.set(addtion, forKey: "CountQty")
        }
        datacheckaddressViewArrayOffer = dbManager.loadAddresss() as! [NSDictionary]
        for i in 0..<(datacheckaddressViewArrayOffer.count){
            let dbDict = datacheckaddressViewArrayOffer[i] as! [String : Any]
            let dbproductid = dbDict["productId"] as! String
            let offerproductid = productDetail.productId
            if dbproductid == offerproductid {
                var updateRecordDatabase1 : Bool = false
                updateRecordDatabase1 = dbManager.updateCart(productID: dbDict["productId"] as! String, quantity:"\(addtion)")
                //}
                
            }
            
        }
        cell?.offerQtyIncrease!.text = String(addtion)
        
    }
  
    //MARK: GMSMapViewDelegate
    
    func mapView(_ mapView: GMSMapView!, markerInfoWindow marker: GMSMarker!) -> UIView! {
        let index:Int! = Int(marker.accessibilityLabel!)
        if index == 1000 {
            let loginUserInfoDict  = UserDefaults.standard.object(forKey: "loginUserinfo") as?Dictionary<String,Any>
            marker.title = loginUserInfoDict?["fullname"] as? String
            return nil
        }
        if index == nil {
            let loginUserInfoDict  = UserDefaults.standard.object(forKey: "loginUserinfo") as?Dictionary<String,Any>
            marker.title = loginUserInfoDict?["fullname"] as? String
            return nil
        }
        if index == 100 {
            marker.title = "TKF Vehicle"
            return nil
        }else{
            if markerRouteArray.count > 0{
                let   dictRoute  = markerRouteArray[index]
                let customInfoWindow = Bundle.main.loadNibNamed("CustomInfoWindow", owner: self, options: nil)![0] as! CustomInfoWindow
                customInfoWindow.CustomAddressLbl.text = dictRoute["from_location"] as? String
                let startDateStr =  dictRoute["startTime"] as? String
                let startDate = startDateStr?.components(separatedBy:"T")
                let str = startDate?[1].components(separatedBy:".")
                let datestart = str![0]
                let start = self.datefromate(datefromat: datestart)
                customInfoWindow.CustomarkerStarttime.text = start
                let endDateStr =  dictRoute["endTime"] as? String
                let endDate = endDateStr?.components(separatedBy:"T")
                let s1tr = endDate?[1].components(separatedBy:".")
                let dateend = s1tr![0]
                let end = self.datefromate(datefromat: dateend)
                customInfoWindow.CustomMarkerEndTime.text = end
                return customInfoWindow

            }
        }
        return nil

    }
    
    //MARK: -  datefromate
   
    func datefromate(datefromat: String) -> String {
        let stringFromDate: String!
        let df = DateFormatter()
        df.dateFormat = "HH:mm:ss"
        if let date = df.date(from: datefromat) {
            //df.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone!
            df.dateFormat = "hh:mm a"
             stringFromDate = df.string(from: date)
            return stringFromDate
        }
        return ""

    }
    
    //MARK: -  latlongCalledMethod
 
    func latlongCalledMethod(userlat1:Double, userlon1:Double){
        if self.appDelegate.IsReachabilty! {
            let auth = UserDefaults.standard.value(forKey: "user_auth_token")!
            let token = "\(WebseviceNameConstant.StrJWT)\(auth)"
            let userlocationDict = ["post":["latitude":userlat1,"longitude": userlon1]]
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
         // self.view.makeToast("Please check internet connection", duration: 0.5, position: CSToastPositionCenter)
            
            self.checkInternetConnection()
            
        }
    }
    
    //MARK: -  CallFBT
    
    func CallFBT(){
        if self.appDelegate.IsReachabilty! {
            let auth = UserDefaults.standard.value(forKey: "user_auth_token")!
            let token = "\(WebseviceNameConstant.StrJWT)\(auth)"
            
            let str = UserDefaults.standard.string(forKey: "DeviceKey")
          
            print("devicetoken",str)
            
            let userlocationDict = ["post":["FBT":str]]
            
            
            //covANd6yeX8:APA91bFHg1kk4YkYZlkGiwB8ivOUtiA3UXC9CjdB9Y90jMb-HBaecwA33M_nVC6YOHgqwPEkYErSXx2M9wxLy5l1Z9uyF6simbupu505LdctbeYU30cvRb3ULBu235B6zqcZr9I0yjwF
            //0736b1c8cd418d92fbe8137780b997d2ac5f4f20 102ef46975a74ac423e85b58942683ef338702be3237bc7d90d6c7fb57c696bb
            let headerDict=["Authorization": token]
            WebserviceHelper.sharedInstance.callPutDataWithMethod(strMethodName: "customer/fbt", requestDict: userlocationDict as Dictionary<String, Any>, isHud: true, hudView: self.view, value: headerDict,successBlock: { (success, response) in
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
          // self.view.makeToast("Please check internet connection", duration: 0.5, position: CSToastPositionCenter)
            
            self.checkInternetConnection()
            
        }
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
