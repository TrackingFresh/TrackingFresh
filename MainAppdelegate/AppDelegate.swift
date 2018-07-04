//
//  AppDelegate.swift
//  GoogleFacebookLogin
//
//  Created by webwerks on 1/16/18.
//  Copyright © 2018 webwerks. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit
import FBSDKCoreKit
import SystemConfiguration
import GoogleMaps
import SDLoader
import SocketIO
import Fabric
import Crashlytics
import NVActivityIndicatorView
import UserNotifications
import UserNotificationsUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,GIDSignInDelegate,MessagingDelegate,UNUserNotificationCenterDelegate {
 var label :UILabel?
    var backgroundView : UIView?
    var timeTableLBL : UILabel?
    var v: UIView?
    var window: UIWindow?
    var IsReachabilty: Bool?
    var flag: String?
    var firebaseModel:FirebaseModel? = nil
    var firebaseRef:DatabaseReference!
    var cartCount :Int = 0
    var socketManger = SocketManager(socketURL: URL(string: "http://35.154.11.54")!, config: [.log(true), .compress])
  let sdLoader = SDLoader()
    var  cartQuntityArray: NSMutableArray = []
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        flag = "map"
        let str  = UserDefaults.standard.removeObject(forKey: "menu")
        UserDefaults.standard.synchronize()
        UserDefaults.standard.set(flag, forKey: "menu")
        UserDefaults.standard.synchronize()
       
        if #available(iOS 10.0, *)
        {
                    // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
                    
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else
        {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
            

        UIApplication.shared.registerForRemoteNotifications()
        
        application.registerForRemoteNotifications()
        
        socketManger.defaultSocket.connect()
        IsReachabilty = self.checkReachability()
        GMSServices.provideAPIKey("AIzaSyBLJXOi6SbSr84xlOwOqcHtyQdGCnFGJIA")
        GIDSignIn.sharedInstance().clientID = "452023475744-gqht4ilu529ftmsblr06sm6665n50083.apps.googleusercontent.com"
        // FBLogin
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        self.navigationbarSetup()
        Fabric.with([Crashlytics.self])
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
       
        Messaging.messaging().delegate = self
        
        
        //get UserProfileModel
        let loginCheck = UserDefaults.standard.string(forKey: "doneLogin")
        if (loginCheck == "logoutSucessFully" || loginCheck == nil) {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let signInViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            let nvc: UINavigationController = UINavigationController(rootViewController: signInViewController)
            appDelegate.window?.rootViewController = nvc
            appDelegate.window?.makeKeyAndVisible()
            
        }else{
            let activityData = ActivityData.init(size: CGSize(width:100, height: 100), message: "Waiting...", messageFont: UIFont(name: "HelveticaNeue-bold", size: 14.0)!, messageSpacing: 3.0, type: .ballPulse, color: UIColor.green, padding: 0.0, displayTimeThreshold: 0, minimumDisplayTime: 0, backgroundColor: UIColor.white, textColor: UIColor.black)
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
            NVActivityIndicatorPresenter.sharedInstance.setMessage("Checking for vehicle...")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                self.createMenuView()
            }

        }
        
        window?.backgroundColor = self.hexStringToUIColor(hex:"8dc33b")

    self.getUserData()
        firebaseRef = Database.database().reference()
        // FBLogin
        let cartcount =  UserDefaults.standard.integer(forKey: "cartcount")
        if cartcount == 0 {
            UserDefaults.standard.set(0, forKey: "cartcount")
             UserDefaults.standard.synchronize()
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication)
    {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        
    }

    func applicationWillEnterForeground(_ application: UIApplication)
    {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication)
    {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        UIApplication.shared.applicationIconBadgeNumber = 0
    
    }

    func applicationWillTerminate(_ application: UIApplication)
    {
        UserDefaults.standard.removeObject(forKey: "menu")
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent: UNNotification,
                                withCompletionHandler: @escaping (UNNotificationPresentationOptions)->()) {
        withCompletionHandler([.alert, .sound, .badge])
    }
    
 /*   func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive: UNNotificationResponse,
                                withCompletionHandler: @escaping ()->()) {
        withCompletionHandler()
    }
 
 */
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        print("handling notification")
        if let notification = response.notification.request.content.userInfo as? [String:AnyObject] {
            let message = parseRemoteNotification(notification: notification)
            print(message as Any)
        }
        completionHandler()
    }
    
    private func parseRemoteNotification(notification:[String:AnyObject]) -> String? {
        if let identifier = notification["identifier"] as? String {
            return identifier
        }
        
        return nil
    }
    
    
    // MARK: - Google SignIn and facebook
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation) {
            return GIDSignIn.sharedInstance().handle(url,sourceApplication: sourceApplication,annotation: annotation)
        } else {
            
            let handle = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: [UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: [UIApplicationOpenURLOptionsKey.annotation])
            
            if (handle) {
                return handle
            }
            
            // If the SDK did not handle the incoming URL, check it for app link data
            let parsedUrl : BFURL! = BFURL.init(inboundURL: url, sourceApplication: sourceApplication)
            if (parsedUrl.appLinkData != nil) {
                let targetUrl = parsedUrl.targetURL
                print(targetUrl ?? "")
                return true
            }
            return handle
        }
}

     func checkReachability()->Bool{
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    
    func navigationbarSetup()
    {
        
        let attrs = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-BOLD", size: 15)!
        ]
        UINavigationBar.appearance().titleTextAttributes = attrs
        UINavigationBar.appearance().barTintColor =  UIColor(hex:"#8dc33b")  //UIColor(hex:"#8dc33b")
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar().shadowImage = UIImage(named: "")
        
    }
    
    func showHudtest()
    {
        sdLoader.spinner?.lineWidth = 5
        sdLoader.spinner?.spacing = 0.0
        sdLoader.spinner?.sectorColor = UIColor.green.cgColor
        sdLoader.spinner?.textColor = UIColor.cyan
        sdLoader.spinner?.animationType = AnimationType.anticlockwise
        sdLoader.startAnimating(atView: self.window!)
    }
    
    func showHudHide()
    {
        sdLoader.stopAnimation()
    }
    
    func getUserData() -> Void
    {
        if UserDefaults.standard.data(forKey: "UserProfile_Model") == nil
        {
            let emptyDict: NSDictionary = NSDictionary()
            let userData:FirebaseModel = FirebaseModel.init(userDict: emptyDict)
            let archivedData = NSKeyedArchiver.archivedData(withRootObject: userData)
            UserDefaults.standard.set(archivedData, forKey: "UserProfile_Model")
            self.firebaseModel = userData
        }
        else if let data = UserDefaults.standard.object(forKey: "UserProfile_Model")
        {
            let unArchivedData = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as! FirebaseModel
            self.firebaseModel = unArchivedData
            print(self.firebaseModel!)
        }
        UserDefaults.standard.synchronize()
    }
    
    func setUserData() -> Void
    {
        
        let archivedData = NSKeyedArchiver.archivedData(withRootObject: self.firebaseModel!)
        UserDefaults.standard.set(archivedData, forKey: "UserProfile_Model")
        UserDefaults.standard.synchronize()
        DispatchQueue.global().async
            {
            // if CommonMethod.checkReachability() {
            self.updateFireBaseData()
            //}
            }
    }
    
    func updateFireBaseData() -> Void
    {
        let infoDict = self.firebaseModel?.getModelData()
        let userId = infoDict?["uId"] as! String
        if userId.count>0
        {
            print(infoDict as Any)
            self.firebaseRef?.child(userId).setValue(infoDict)
        }
    }
    
    func application(application: UIApplication,  didReceiveRemoteNotification userInfo: [NSObject : AnyObject],  fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void)
    {
        
        print("Recived: \(userInfo)")
        
        completionHandler(.newData)
        
    }
    
        // firebase Iclouds push notification
        func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
            let token = Messaging.messaging().fcmToken
            print("Firebase registration token: \(String(describing: token))")
            
            let currentToken=UserDefaults.standard.string(forKey: token!)
            
            if currentToken != fcmToken.description { // Here you were comparing  String and NSData ?? :S
                let dataString = fcmToken.description
                UserDefaults.standard.setValue(dataString, forKey:"DeviceKey")
                UserDefaults.standard.synchronize()
            }
            
        }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken as Data
        
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
       
        print("token: \(token)")
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError)
    {
         print("failed to register for remote notifications with with error: \(error)")
    }
    
    // google  delegate
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if error == nil
        {
            return
        }
        
        guard let authentication = user.authentication else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,accessToken: authentication.accessToken)
        print(credential)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
    }
    
    func appDelegate () -> AppDelegate
    {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    fileprivate func createMenuView()
    {
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
  
    func showCustomLabelONmap(time:String!){
        if (backgroundView != nil){
            backgroundView?.layer.removeAllAnimations()
            self.window?.viewWithTag(100)?.removeFromSuperview()
            backgroundView = nil

//            let subViewArray = self.window?.subviews
//            for obj: Any in subViewArray! {
//                (obj as AnyObject).removeFromSuperview()
//            }
    
        }
        let screenSize = UIScreen.main.bounds
        backgroundView = UIView(frame: CGRect(x: 7, y: screenSize.size.height-100, width: screenSize.size.width/2 + 30 , height:40))
        backgroundView?.tag = 100
        timeTableLBL?.isHidden = false
        timeTableLBL = UILabel(frame: CGRect(x: 7, y:0, width: screenSize.size.width/2 + 30, height: 45))
        timeTableLBL?.backgroundColor = UIColor.clear
        timeTableLBL?.textAlignment = .left
        timeTableLBL?.text = time
        timeTableLBL?.font = label?.font.withSize(18)
        timeTableLBL?.textColor = UIColor.black
        backgroundView?.addSubview(timeTableLBL!)
        backgroundView?.backgroundColor = UIColor.white
        window?.addSubview(backgroundView!)
//        UIApplication.shared.keyWindow?.addSubview(backgroundView!)
    }
    func hideHud(){
        DispatchQueue.main.async() {
            self.backgroundView?.layer.removeAllAnimations()
            self.window?.viewWithTag(100)?.removeFromSuperview()
            self.backgroundView = nil
            self.timeTableLBL?.isHidden = true
//            let subViewArray = self.window?.subviews
//            for obj: Any in subViewArray! {
//                (obj as AnyObject).removeFromSuperview()
//            }
    
        }
    }
    
    func hexStringToUIColor (hex:String) -> UIColor
    {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func windowStatus() {
        v = UIView(frame: CGRect(x: (window?.frame.origin.x)!, y: (window?.frame.origin.y)!, width: (window?.frame.width)!, height:20))
        v?.tag = 100
        v?.backgroundColor = self.hexStringToUIColor(hex: "8dc33b")
        window?.addSubview(v!);
        window?.backgroundColor=self.hexStringToUIColor(hex: "8dc33b")
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
}
