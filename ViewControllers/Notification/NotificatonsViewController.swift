//
//  NotificatonsViewController.swift
//  GoogleFacebookLogin
//
//  Created by V kishore kumar reddy  on 1/16/18.
//  Copyright © 2018 Raju sharma. All rights reserved.
//

import UIKit

class NotificatonsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,SlideMenuControllerDelegate
{
    
     // MARK: - IBOutlets & Objects
    
    @IBOutlet weak var NotificationTableView: UITableView!
    var  NotificationListArray: NSArray = []
    var currentDate :String?
    var previousDate : String?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
       // self.title = "Notification"
        self.customNavigationItem(stringText: "NOTIFICATION", showbackButon: false)
        self.setNavigationBarItem()
        NotificationTableView.delegate = self
        NotificationTableView.dataSource = self
        NotificationTableView.rowHeight = UITableViewAutomaticDimension
        NotificationTableView.estimatedRowHeight = 95
        NotificationTableView.register(UINib(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationCell")
       currentDate =  self.printTimestamp()

        GetNotifictionsdata()
     setBadge()
    }
    
    // MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.appDelegate.hideHud()
    
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
    
    @objc func backAction()
    {
         self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - didReceiveMemoryWarning
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - GetNotifictionsdata
    
    func GetNotifictionsdata()
    {
            if appDelegate.IsReachabilty! {
            let auth = UserDefaults.standard.value(forKey: "user_auth_token")!
            let token = "\(WebseviceNameConstant.StrJWT)\(auth)"
            let headerDict=["Authorization": token]
            WebserviceHelper.sharedInstance.callGetDataWithMethod(strMethodName:"customer/pushNotifications", requestDict: [:], isHud: false, hudView: self.view, value: headerDict, successBlock:
                {  response, responseStr in print(response)
                    print("\(responseStr)");
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200{
                        self.NotificationListArray = (responseStr["data"] as! NSArray)
                        self.NotificationTableView.reloadData()
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
           //  self.view.makeToast("Please check internet connection", duration: 0.5, position: CSToastPositionCenter)
            
            self.checkInternetConnection()

        }
        
    }
    
    // MARK: - UITableView Delegates & Data Source
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.NotificationListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell :NotificationTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "NotificationCell") as! NotificationTableViewCell?)!
        let NotificationDict = self.NotificationListArray[indexPath.row] as! NSDictionary
        cell.notificationLBL.text = NotificationDict.value(forKey: "message") as? String
        
        cell.notificationDateLbl.text = (NotificationDict.value(forKey: "createdAt") as! String)
        let str = NotificationDict.value(forKey: "createdAt") as! String
        let index = str.index(of: "T")!
        let newStr = str.substring(to: index)
        print(newStr)
        let diffDate : String = self.getDiffBetweenTwoDates(strdate1:newStr, strdate2: currentDate!)
        if Int(diffDate)! < 7 {
            cell.notificationDateLbl.text =  diffDate + " days ago "
//            let dateformted = self.formatTimestamp(Date1: newStr)
//            cell.notificationDateLbl.text =  dateformted
            
            
        }else
        {
            let dateformted = self.formatTimestamp(Date1: newStr)
            cell.notificationDateLbl.text =  dateformted
        }
        
       
        return cell
    }
    
    // MARK: - formatTimestamp
    
    func formatTimestamp(Date1: String)->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date12: Date? = dateFormatter.date(from: Date1)
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "MMM dd,yyyy"
        print(dateFormatter1.string(from: date12!))
        return  dateFormatter1.string(from: date12!)
    }
    
    // MARK: - printTimestamp
    
    func printTimestamp()->String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let updatedString = formatter.string(from: date)
        return updatedString
    }
    
    // MARK: - getDiffBetweenTwoDates
    
    func getDiffBetweenTwoDates(strdate1:String,strdate2:String)->String{
        let userCalendar = Calendar.current
        let requestedComponent: Set<Calendar.Component> = [.month,.day,.hour,.minute,.second,.nanosecond]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateObj1 = dateFormatter.date(from: strdate1)
        let dateObj2 = dateFormatter.date(from: strdate2)
        let timeDifference = userCalendar.dateComponents(requestedComponent, from: dateObj1!, to: dateObj2!)
        let diff = "\(timeDifference.day ?? 0)"
        return diff
    }
    
    // MARK: - setBadge
    
    func setBadge(){
        DispatchQueue.main.async
        {
            // badge label
            self.appDelegate.label = UILabel(frame: CGRect(x: 20, y: 1, width:18, height: 18))
            self.appDelegate.label?.layer.borderColor = UIColor.clear.cgColor
            self.appDelegate.label?.layer.borderWidth = 2
            self.appDelegate.label?.layer.cornerRadius = (self.appDelegate.label?.bounds.size.height)! / 2
            self.appDelegate.label?.textAlignment = .center
            self.appDelegate.label?.layer.masksToBounds = true
            self.appDelegate.label?.font = UIFont(name: "System", size: 3)
            self.appDelegate.label?.textColor = .white
            let cartcount =  UserDefaults.standard.integer(forKey: "cartcount")
            self.appDelegate.label?.text = String(cartcount)
            self.appDelegate.label?.backgroundColor = CommonMethod.hexStringToUIColor(hex:"#8dc33b")
            
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
    
    // MARK: - rightButtonTouched
    
    @objc func rightButtonTouched() {
        let storyboard: MyCartViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyCartViewController") as! MyCartViewController
        let nav = UINavigationController(rootViewController: storyboard)
        self.slideMenuController()?.changeMainViewController(nav, close: true)
        
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
    
     // MARK: - timeAgoSinceDate
    
    func timeAgoSinceDate(_ date:Date, numericDates:Bool = false) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = Date()
        let earliest = now < date ? now : date
        let latest = (earliest == now) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest,  to: latest)
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1)
        {
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2)
        {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3)
        {
            return "\(components.second!) seconds ago"
        } else
        {
            return "Just now"
        }
        
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


extension Date
{
    func timestampString() -> String?
    {
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .full
            formatter.maximumUnitCount = 1
            formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
            
            guard let timeString = formatter.string(from: self, to: Date()) else {
                return nil
    }
            
            let formatString = NSLocalizedString("%@ ago", comment: "")
            return String(format: formatString, timeString)
    }
}



