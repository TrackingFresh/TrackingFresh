//
//  TrackOrdervViewController.swift
//  GoogleFacebookLogin
//
//  q by V kishore kumar reddy  on 3/8/18.
//  Copyright © 2018 Raju sharma. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SocketIO
class TrackOrdervViewController: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate,ARCarMovementDelegate
{

     // MARK: - IBOutlets & Objects
    
    var drivermarker = GMSMarker()
    var markerDefault =  GMSMarker()
    var polylineArray = [GMSPolyline]()

    var moveMent = ARCarMovement()
    var customObject : LastOrderModel!
    var LastOrderModelArray = [LastOrderModel]()
    var  trackOrderDictComplted : NSDictionary = [:]
    var Latitiude:Double!
    var Longitude:Double!
    var userLatitiude:Double!
    var userLongitude:Double!
    var socketLatitiude:Double!
    var socketLongitude:Double!
    var VehicaleLatitiude:Double!
    var VehicaleLongitude:Double!
    var cordinateDict2 = [NSDictionary]()
    let geocoder = CLGeocoder()
    var markerRouteArray :[[String  : Any]] = []
    var sourceLocation = CLLocationCoordinate2D()
    let locationManager = CLLocationManager()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var oldCoordinate : CLLocationCoordinate2D!
    var vehicleCoordinate : CLLocationCoordinate2D!
    var curCoordinate : CLLocationCoordinate2D!
    var newCoordinate :CLLocationCoordinate2D!
    @IBOutlet weak var trackVanAddress: UILabel!
    @IBOutlet weak var currentUserAddress: UILabel!
    var  AddressListArray: NSArray = []
    var  orderDetailsArray: NSArray = []
    var  bikerArray: NSDictionary = [:]
     var RouteDetailArray1 : NSArray = []
    var RouteDetailArray677 : NSArray = []

    //double Latitiude,Longitude;
    @IBOutlet weak var mapView: GMSMapView!
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customNavigationItem(stringText: "TRACKING FRESH", showbackButon: false)

        let Camera = GMSCameraPosition.camera(withLatitude: 19.0760,
                                              longitude: 72.8777,
                                              zoom: 14)
        mapView.camera = Camera
        mapView.isMyLocationEnabled = true
        mapView.mapType = .normal
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        mapView.settings.zoomGestures = true
        mapView.delegate = self
        self.view.addSubview(mapView)
        locationManager.delegate = self
        self.moveMent.delegate = self;

    }
    
    // MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.socketManger.defaultSocket.connect()
        locationManager.startUpdatingLocation()
        self.appDelegate.hideHud()
        TraceOrder()

    }
    
     // MARK: - viewWillDisappear
    
        override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
            self.appDelegate.hideHud()
        appDelegate.socketManger.defaultSocket.disconnect()
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
      createMenuView()
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
    
    
    // MARK: - nearrestRoute
    
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
                        self.RouteDetailArray1 = responseStr ["data" ] as! NSArray
                        if self.RouteDetailArray1.count>0{
                            let dict = self.RouteDetailArray1[0] as! NSDictionary
                            let distDict = dict["dist"] as! NSDictionary
                            let locationDict = distDict["location"] as! NSDictionary
                            self.RouteDetailArray677 = locationDict["coordinates"] as! NSArray
                            print(self.RouteDetailArray677)
                            if self.RouteDetailArray677.count>0{
                                self.VehicaleLongitude = self.RouteDetailArray677[0] as! Double
                                self.VehicaleLatitiude = self.RouteDetailArray677[1] as! Double
                            }else{
                              
                                return
                            }
                            
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
    
    // MARK: - TraceOrder
    
    func TraceOrder()  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.IsReachabilty! {
            let auth = UserDefaults.standard.value(forKey: "user_auth_token")!
            let token = "\(WebseviceNameConstant.StrJWT)\(auth)"
            let headerDict=["Authorization": token]
             let OrderID =   UserDefaults.standard.value(forKey: "OrderId")!
          
            WebserviceHelper.sharedInstance.callMobileVerifyGetDataWithMethod(strMethodName:"order/", requestDict: OrderID as? String, isHud: false, hudView: self.view, value: headerDict, successBlock:
                {  response, responseStr in print(response)
                    print("\(responseStr)");
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200{
                        let dictData = responseStr["data"]as! NSDictionary
                        if dictData != nil{
                            let addressDic = dictData["address"]as! NSDictionary
                            let geodict = addressDic["geo"] as! NSDictionary
                            let cordinateDict = geodict["coordinates"] as! NSArray
                            self.userLongitude = cordinateDict[0] as! Double
                            self.userLatitiude = cordinateDict[1] as! Double
                            
                            
                            
                            self.nearrestRoute(latitiude: self.userLatitiude, longitude: self.userLongitude)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now()+3.0, execute: {
                           
                                self.orderDetailsArray = dictData["orders"] as! NSArray
                                let VehicleIdStr =  dictData["vehicleId"]as! NSString
                                print(VehicleIdStr)
                                self.customObject=LastOrderModel()
                                let dictValue = dictData as! [String : Any]
                                self.customObject.initdata(Dict: dictValue)
                                self.LastOrderModelArray.append( self.customObject)
                                // let Camera = GMSCameraPosition.camera(withLatitude: self.VehicaleLatitiude as! CLLocationDegrees,longitude: self.VehicaleLongitude as! CLLocationDegrees,zoom: 14)
                                //  self.mapView.camera = Camera
                                self.oldCoordinate = CLLocationCoordinate2D(latitude:self.userLatitiude as! CLLocationDegrees, longitude:self.userLongitude as! CLLocationDegrees)
//                                let Camera = GMSCameraPosition.camera(withLatitude: self.userLatitiude as! CLLocationDegrees,longitude: self.userLongitude as! CLLocationDegrees,
//                                                                      zoom: 16)
//                                self.mapView.camera = Camera
                               // mapView.isMyLocationEnabled = true
                                
                                let marker = GMSMarker()
                                let loginUserInfoDict  = UserDefaults.standard.object(forKey: "loginUserinfo") as?Dictionary<String,Any>
                                
                                marker.title = loginUserInfoDict?["fullname"] as? String
                                marker.position =  self.oldCoordinate
                                marker.icon = UIImage(named: "ic_customer_marker")
                                marker.infoWindowAnchor = CGPoint(x: 0.5,y :0.2)
                                marker.map = self.mapView
                                
                                if self.RouteDetailArray677.count > 0{
                                    self.vehicleCoordinate = CLLocationCoordinate2D(latitude:self.VehicaleLatitiude as! CLLocationDegrees, longitude:self.VehicaleLongitude as! CLLocationDegrees)
                                    let Camera = GMSCameraPosition.camera(withLatitude: self.VehicaleLatitiude as! CLLocationDegrees,longitude: self.VehicaleLongitude as! CLLocationDegrees,
                                                                          zoom: 15)
                                    self.mapView.camera = Camera
                                    self.markerDefault.position = self.vehicleCoordinate
                                    self.markerDefault.icon = UIImage(named: "movingCar")
                                    self.self.markerDefault.map = self.mapView
                                    self.markerDefault.title = "TKF Vechile";
                                    self.markerDefault.accessibilityLabel = "\(100)"
                                    
                                }else{
                                    self.getLocationTime(lat1:  self.userLatitiude, lon1: self.userLongitude, lat2: self.userLatitiude, lon2: self.userLongitude, flag:"YES")
                                    self.view.makeToast("Vechile is not on route!.", duration: 0.5, position: CSToastPositionCenter)
                                  return
                                }
                                self.getLocationTime(lat1:  self.userLatitiude, lon1: self.userLongitude, lat2: self.VehicaleLatitiude, lon2: self.VehicaleLongitude, flag:"NO")
                                self.getPolylineRoute(from: self.oldCoordinate, to: self.vehicleCoordinate )
                                if dictData["biker"] != nil {
                                    self.markerDefault.position = CLLocationCoordinate2D(latitude:self.VehicaleLatitiude as! CLLocationDegrees, longitude:self.VehicaleLongitude as! CLLocationDegrees)
                                    self.drivermarker.icon = UIImage(named: "ic_bike")
                                    self.drivermarker.map = self.mapView
                                    self.drivermarker.title = "TKF Vechile";
                                    self.bikerArray = dictData["biker"] as! NSDictionary
                                }else{
                                    self.markerDefault.position = self.vehicleCoordinate
                                    self.markerDefault.icon = UIImage(named: "movingCar")
                                    self.self.markerDefault.map = self.mapView
                                    self.markerDefault.title = "TKF Vechile";
                                    self.markerDefault.accessibilityLabel = "\(100)"
                                }
                                appDelegate.socketManger.defaultSocket.onAny(){
                                    any in
                                    if any.event != " "{
                                        if self.bikerArray.count > 0 {
                                            let bikerId = self.bikerArray["_id"] as! String
                                            if any.event == "bikerPosition"{
                                                self.markerDefault.map = nil
                                                print(any.items as NSArray!)
                                                let vehicleArray = any.items as NSArray!
                                                let vehicleDict = vehicleArray![0] as! NSDictionary
                                                let vehiclemainDict = vehicleDict["data"] as! NSDictionary
                                                let vehicleID = vehiclemainDict["biker_id"] as! String
                                                let geoDict = vehiclemainDict["geo"] as! NSDictionary
                                                let coordinateArray = geoDict["coordinates"] as! NSArray
                                                self.socketLongitude = coordinateArray[0] as! Double
                                                self.socketLatitiude = coordinateArray[1] as! Double
                                                print(vehicleID)
                                                if bikerId == vehicleID   {
                                                    self.drivermarker.position = CLLocationCoordinate2D(latitude:self.socketLatitiude as! CLLocationDegrees, longitude:self.socketLongitude as! CLLocationDegrees)
                                                    self.newCoordinate = CLLocationCoordinate2D(latitude:self.socketLatitiude as! CLLocationDegrees, longitude: self.socketLongitude as! CLLocationDegrees)
                                                    
                                                    self.getPolylineRoute(from: self.newCoordinate, to: self.oldCoordinate )
                                                    
                                                    let dictLocation = ["lat":self.socketLatitiude,"long":self.socketLongitude ]
                                                    UserDefaults.standard.set(dictLocation, forKey: "trackVehicle")
                                                    UserDefaults.standard.synchronize()
                                                    self.drivermarker.icon = UIImage(named: "ic_bike")
                                                    self.drivermarker.map = self.mapView
                                                    self.drivermarker.title = "TKF Vechile";
                                                    self.moveMent.ARCarMovement(marker: self.drivermarker, oldCoordinate: self.oldCoordinate, newCoordinate: self.newCoordinate, mapView:self.mapView, bearing: 0)
                                                    self.oldCoordinate = self.newCoordinate;
                                                    self.getLocationTime(lat1:  self.userLatitiude, lon1: self.userLongitude, lat2:self.socketLatitiude, lon2: self.socketLongitude, flag:"NO")
                                                }
                                            }
                                            
                                        }else{
                                            if any.event == "vehiclePosition"{
                                                self.markerDefault.map = nil
                                                print(any.items as NSArray!)
                                                let vehicleArray = any.items as NSArray!
                                                let vehicleDict = vehicleArray![0] as! NSDictionary
                                                let vehiclemainDict = vehicleDict["data"] as! NSDictionary
                                                let vehicleID = vehiclemainDict["vehicle_id"] as! String
                                                let geoDict = vehiclemainDict["geo"] as! NSDictionary
                                                let coordinateArray = geoDict["coordinates"] as! NSArray
                                                self.socketLongitude = coordinateArray[0] as! Double
                                                self.socketLatitiude = coordinateArray[1] as! Double
                                                let dictLocation = ["lat":self.socketLatitiude,"long":self.socketLongitude ]
                                                UserDefaults.standard.set(dictLocation, forKey: "trackVehicle")
                                                UserDefaults.standard.synchronize()
                                                print(vehicleID)
                                                if vehicleID == VehicleIdStr as! String  {
                                                    self.drivermarker.position = CLLocationCoordinate2D(latitude:self.socketLatitiude as! CLLocationDegrees, longitude:self.socketLongitude as! CLLocationDegrees)
                                                    self.newCoordinate = CLLocationCoordinate2D(latitude:self.socketLatitiude as! CLLocationDegrees, longitude: self.socketLongitude as! CLLocationDegrees)
                                                    
                                                    self.getPolylineRoute(from: self.newCoordinate, to: self.oldCoordinate )
                                                    
                                                    self.drivermarker.icon = UIImage(named: "movingCar")
                                                    self.drivermarker.map = self.mapView
                                                    self.drivermarker.title = "TKF Vechile";
                                                    //                                        self.drivermarker.accessibilityLabel = "\(1000)
                                                    self.moveMent.ARCarMovement(marker: self.drivermarker, oldCoordinate: self.oldCoordinate, newCoordinate: self.newCoordinate, mapView:self.mapView, bearing: 0)
                                                    self.oldCoordinate = self.newCoordinate;
                                                    self.getLocationTime(lat1:  self.userLatitiude, lon1: self.userLongitude, lat2:self.socketLatitiude, lon2: self.socketLongitude, flag:"NO")
                                                }
                                                
                                            }else {
//                                                self.drivermarker.map = nil
//                                                let vehicleLocationInfoDict  = UserDefaults.standard.object(forKey: "trackVehicle") as?Dictionary<String,Any>
//                                                if vehicleLocationInfoDict != nil{
//                                                    let lat = vehicleLocationInfoDict!["lat"] as! Double
//                                                    let long = vehicleLocationInfoDict!["long"] as! Double
//                                                    self.markerDefault.position = CLLocationCoordinate2D(latitude:lat, longitude:long)
//                                                    self.getPolylineRoute(from: CLLocationCoordinate2D(latitude:lat, longitude:long), to: self.vehicleCoordinate )
//
//                                                    self.markerDefault.icon = UIImage(named: "movingCar")
//                                                    self.self.markerDefault.map = self.mapView
//                                                    self.markerDefault.title = "TKF Vechile";
//                                                    self.markerDefault.accessibilityLabel = "\(100)"
//                                                }else{
//                                                    self.markerDefault.position = CLLocationCoordinate2D(latitude:self.VehicaleLatitiude as! CLLocationDegrees, longitude:self.VehicaleLongitude as! CLLocationDegrees)
//
//                                                    self.markerDefault.icon = UIImage(named: "movingCar")
//                                                    self.self.markerDefault.map = self.mapView
//                                                    self.markerDefault.title = "TKF Vechile";
//                                                    self.markerDefault.accessibilityLabel = "\(100)"
//                                                }
                                                
                                            }
                                            
                                        }
                                        
                                    }
                                }
                            
                            })
                            
                        }
                        
                        
                        
                       
                }
                    else{
                        let userDict=responseStr ["user_msg" ] as! String
                        self.view.makeToast(userDict as String, duration: 0.5, position: CSToastPositionCenter)
                        
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
    
    // MARK: - getPolylineRoute
    
    //user_location_name
    func getPolylineRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D){
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
                                self.showPath(polyStr: polyString!)
                                
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
    
    
    //MARK: -  showPath
    
    func showPath(polyStr :String){
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
        }
        
        
    }
    
    //MARK: -  getLocationTime
    
    func getLocationTime(lat1:Double, lon1:Double, lat2:Double, lon2:Double, flag:String)  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.IsReachabilty! {
            let userlatLong = String(lat1) + "," + String(lon1)
            let vehiclelatLong = String(lat2) + "," + String(lon2)
            let url : String = "https://maps.googleapis.com/maps/api/distancematrix/json"
            let postParameters:[String: Any] = ["origins": userlatLong,"destinations": vehiclelatLong,"mode":"driving","language":"en-EN","sensor":"false","key":"AIzaSyBfJthYTvzihxZ6iD0rZS6IcgY1_wof2ow"]
                                        
            
            WebserviceHelper.sharedInstance.callGoogleAPiAddress(strMethodName:url, requestDict: postParameters, isHud: false, hudView: self.view, value:[:], successBlock:
                {  response, responseStr in print(response)
                    print("\(responseStr)");
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200{
                        let destination_addresses = responseStr["destination_addresses"] as! NSArray
                        var straddress : String! = " "
                        var orginaddress : String! = " "
                        DispatchQueue.main.async() {
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
                            let status = distanceDict["status"] as! String
                            if flag == "NO"
                            {
                                if status != "ZERO_RESULTS"{
                                    let distance = distanceDict["distance"] as! NSDictionary
                                    let Vehicledistancefromuser = distance["text"] as! String
                                    self.trackVanAddress.text = " Vehicle is " +  Vehicledistancefromuser  +  straddress
                                    print(Vehicledistancefromuser)
                                    let duration = distanceDict["duration"] as! NSDictionary
                                    let timetakenfromVehicleToUser = duration["text"] as! String
                                    let timestr = "Duration:" + " " + timetakenfromVehicleToUser + " " + "away"
                                    self.appDelegate.showCustomLabelONmap(time:timestr)
                                    print(timetakenfromVehicleToUser)
                                }
                            }else{
                                 self.appDelegate.hideHud()
                                self.trackVanAddress.text = ""
                            }
                            
                            
                        }
                       
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
    
     //MARK: -  VieworderBtn_Clicked
  
      @IBAction func VieworderBtn_Clicked(_ sender: Any) {
        let orderdetailViewController: OrderdetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderdetailViewController") as! OrderdetailViewController
        var LastOrderData:LastOrderModel
        LastOrderData = self.LastOrderModelArray[0]
        orderdetailViewController.detailOrderModelArray = LastOrderData.OrderrArray as! [LastOrderModel] as NSArray
        orderdetailViewController.customObject1 = self.LastOrderModelArray[0]
        self.navigationController?.pushViewController(orderdetailViewController, animated: true)
    }
    
    //MARK: -  HomeBtn_Clicked
    
    @IBAction func HomeBtn_Clicked(_ sender: Any) {
        self.createMenuView()
    }
    
    //MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        if let location = locations.first {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 10)
            Latitiude = location.coordinate.latitude
            Longitude = location.coordinate.longitude
            latlongCalledMethod(userlat1: Latitiude, userlon1: Longitude)
            let distination = CLLocation(latitude:location.coordinate.latitude, longitude:location.coordinate.longitude)
            locationManager.stopUpdatingLocation()
        }
    }
    
    //MARK: -  ARCarMovementMoved
    
    func ARCarMovementMoved(_ Marker: GMSMarker) {
        drivermarker = Marker;
        drivermarker.map = mapView;
        let updatedCamera = GMSCameraUpdate.setTarget(drivermarker.position, zoom: 15.0)
        mapView.animate(with: updatedCamera)
    }
    
    //MARK: -  latlongCalledMethod

    func latlongCalledMethod(userlat1:Double, userlon1:Double){
        if self.appDelegate.IsReachabilty! {
            let auth = UserDefaults.standard.value(forKey: "user_auth_token")!
            let token = "\(WebseviceNameConstant.StrJWT)\(auth)"
            let userlocationDict = ["post":["latitude":"","longitude": ""]]
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
    
    //MARK: -  checkInternetConnection
    
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
