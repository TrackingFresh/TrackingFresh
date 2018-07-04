//
//  TkCashViewController.swift
//  GoogleFacebookLogin
//
//  Created by V kishore kumar reddy  on 1/16/18.
//  Copyright © 2018 Raju sharma. All rights reserved.
//

import UIKit

class TkCashViewController: UIViewController,SlideMenuControllerDelegate,UITableViewDelegate,UITableViewDataSource
{
  
    // MARK: - IBOutlets & Objects
    
    @IBOutlet weak var RecievedBtn: UIButton!
    @IBOutlet weak var PaidBtn: UIButton!
    @IBOutlet weak var Allbtn: UIButton!
    @IBOutlet weak var TkWalletTableView: UITableView!
     var  walletListArray: NSMutableArray = []
    var  PaidwalletListArray: NSArray = []
    var  RecievedwalletListArray: NSArray = []
    var selectedwalletoption :String = " "
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.title = "Wallet"
         self.customNavigationItem(stringText: "WALLET", showbackButon: false)
        TkWalletTableView.delegate = self
        TkWalletTableView.dataSource = self
        TkWalletTableView.register(UINib(nibName: "TkWalletTableViewCell", bundle: nil), forCellReuseIdentifier: "TkWalletTableViewCell")
           Allbtn.setTitleColor(CommonMethod.hexStringToUIColor(hex:"#8dc33b"), for: .normal)
         PaidBtn.setTitleColor(CommonMethod.hexStringToUIColor(hex:"#FFFFFF"), for: .normal)
         RecievedBtn.setTitleColor(CommonMethod.hexStringToUIColor(hex:"#FFFFFF"), for: .normal)

        // Do any additional setup after loading the view.
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

    // MARK: - didReceiveMemoryWarning
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.appDelegate.hideHud()
        self.setNavigationBarItem()
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        GetWallet()

    }
    
    // MARK: - GetWallet
    
    func GetWallet()  {
        if appDelegate.IsReachabilty! {
            let auth = UserDefaults.standard.value(forKey: "user_auth_token")!
            let token = "\(WebseviceNameConstant.StrJWT)\(auth)"
            let headerDict=["Authorization": token]
            WebserviceHelper.sharedInstance.callGetDataWithMethod(strMethodName:"userWallet/", requestDict: [:], isHud: false, hudView: self.view, value: headerDict, successBlock:
                {  response, responseStr in print(response)
                    print("\(responseStr)");
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200{
                        let getnsArray = responseStr["data"] as! NSArray
                        self.walletListArray = NSMutableArray(array: getnsArray)
                        self.TkWalletTableView.reloadData()
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
    
    // MARK: - WalletMAount
    
    func WalletMAount()  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.IsReachabilty! {
            let auth = UserDefaults.standard.value(forKey: "user_auth_token")!
            let token = "\(WebseviceNameConstant.StrJWT)\(auth)"
            let headerDict=["Authorization": token]
            let selectedStr = "operation=" + selectedwalletoption
            WebserviceHelper.sharedInstance.callMobileVerifyGetDataWithMethod(strMethodName:"userWallet/?", requestDict: selectedStr, isHud: false, hudView: self.view, value: headerDict, successBlock:
                {  response, responseStr in print(response)
                    print("\(responseStr)");
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200{
                        let paidArray = responseStr["data"] as! NSArray
                         self.walletListArray = NSMutableArray(array: paidArray)
                        self.TkWalletTableView.reloadData()

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
         //   self.view.makeToast("Please check internet connection", duration: 0.5, position: CSToastPositionCenter)
            
            self.checkInternetConnection()

        }
        
    }
    
    // MARK: - RecievedBtn_Clicked

    @IBAction func RecievedBtn_Clicked(_ sender: Any) {
        Allbtn.setTitleColor(CommonMethod.hexStringToUIColor(hex:"#FFFFFF"), for: .normal)
        PaidBtn.setTitleColor(CommonMethod.hexStringToUIColor(hex:"#FFFFFF"), for: .normal)
        RecievedBtn.setTitleColor(CommonMethod.hexStringToUIColor(hex:"#8dc33b"), for: .normal)
       selectedwalletoption = "add"
        WalletMAount()
        
    }
    
    // MARK: - AllBtn_Clicked
    
    @IBAction func AllBtn_Clicked(_ sender: Any) {
        Allbtn.setTitleColor(CommonMethod.hexStringToUIColor(hex:"#8dc33b"), for: .normal)
        PaidBtn.setTitleColor(CommonMethod.hexStringToUIColor(hex:"#FFFFFF"), for: .normal)
        RecievedBtn.setTitleColor(CommonMethod.hexStringToUIColor(hex:"#FFFFFF"), for: .normal)
        GetWallet()
    }
    
    // MARK: - PaidBtn_Clicked
    
    @IBAction func PaidBtn_Clicked(_ sender: Any) {
        Allbtn.setTitleColor(CommonMethod.hexStringToUIColor(hex:"#FFFFFF"), for: .normal)
        PaidBtn.setTitleColor(CommonMethod.hexStringToUIColor(hex:"#8dc33b"), for: .normal)
        RecievedBtn.setTitleColor(CommonMethod.hexStringToUIColor(hex:"#FFFFFF"), for: .normal)
         selectedwalletoption = "minus"
        if self.walletListArray.count > 0 {
            self.walletListArray.removeAllObjects()
        }
       
        WalletMAount()
    }
    
     // MARK: - UITableView Delegates & Data Source
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.walletListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell :TkWalletTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TkWalletTableViewCell") as! TkWalletTableViewCell!
        let WalletDict = walletListArray[indexPath.row] as! NSDictionary
        if  WalletDict != nil {
            cell.TkWalletType.text = WalletDict["source"] as? String
            let sourcetype = WalletDict["operation"] as? String
             let sourcetAmount = WalletDict["sourceAmount"] as! Int
            cell.TkWalletAmount.text = sourcetype! + "\(sourcetAmount)" + " " + DeviceSizeConstants.rupee
            let str = WalletDict["createdAt"] as! String
            let dateformted = self.convertDateFormater(date: str)
            print(dateformted)
            cell.TKWalletDateTime.text = dateformted
            if sourcetype == "+"{
                let image2 : UIImage = UIImage(named: "ic_wallet_add")!
                cell.TkWalletImg.image = image2
            }else{
                let image1 : UIImage = UIImage(named: "ic_wallet_minus")!
                cell.TkWalletImg.image = image1
            }
            
           
        }
        
        
        
        return cell
    }
    
    // MARK: - convertDateFormater
    
    func convertDateFormater(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        
        guard let date = dateFormatter.date(from: date) else {
            assert(false, "no date from string")
            return ""
        }
        
        dateFormatter.dateFormat = "dd-MMM-yyyy hh.mm"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        let timeStamp = dateFormatter.string(from: date)
        
        return timeStamp
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
    
    // MARK: - formatTime
    
    func formatTime(Date1: String)->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let date12: Date? = dateFormatter.date(from: Date1)
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "MMM dd,yyyy"
        print(dateFormatter1.string(from: date12!))
        return  dateFormatter1.string(from: date12!)
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
