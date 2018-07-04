//
//  SettingViewController.swift
//  GoogleFacebookLogin
//
//  Created by V kishore kumar reddy  on 1/16/18.
//  Copyright © 2018 Raju sharma. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,SlideMenuControllerDelegate
{
  
    // MARK: - IBOutlets & Objects
    
    var  AddressListArray: NSArray = []
    @IBOutlet weak var userNameLBL: UILabel!
    @IBOutlet weak var userprofileImg: UIImageView!
    @IBOutlet weak var SettingTableView: UITableView!
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.title = "Settings"
         self.customNavigationItem(stringText: "SETTINGS", showbackButon: false)
        self.setNavigationBarItem()
        SettingTableView.delegate = self
        SettingTableView.dataSource = self
        userprofileImg.layer.borderWidth = 1
        userprofileImg.layer.masksToBounds = false
        userprofileImg.layer.borderColor = UIColor.white.cgColor
        userprofileImg.layer.cornerRadius = userprofileImg.frame.height/2
        userprofileImg.clipsToBounds = true
        SettingTableView.register(UINib(nibName: "AddressTableViewCell", bundle: nil), forCellReuseIdentifier: "AddressTableViewCell")
        SettingTableView.tableFooterView = UIView()
        
        let loginUserInfoDict  = UserDefaults.standard.object(forKey: "loginUserinfo") as?Dictionary<String,Any>
        userNameLBL.text = loginUserInfoDict?["fullname"] as? String
        
        //let googleURl = UserDefaults.standard.value(forKey: "profile_pic")
        
        // var googleURl = NSString()
        
        let googleURl =  UserDefaults.standard.value(forKey: "profile_pic") as? String
        
       // googleURl =  UserDefaults.standard.value(forKey: "profile_pic") as! NSString
        
        if googleURl == nil || (googleURl?.isEqual("<null>"))! || (googleURl?.isEqual("null)"))! || (googleURl?.isEqual(" "))! || (googleURl?.isEqual("NULL"))!
        {
           
            print("If profile image is not save")
            
            let userImage: UIImage = UIImage(named: "userprofile.png")!
                
            userprofileImg.image = userImage
        
        }
         else
        
        {
//            let url = URL(string: googleURl as! String)
//            let data = try? Data(contentsOf: url!)
//
//            if let imageData = data {
//                let image1 = UIImage(data: imageData)
//                self.userprofileImg.image = image1
//            }
//
            self.userprofileImg.sd_setImage(with: URL(string:(googleURl) as! String), placeholderImage: UIImage(named: " "))
        }
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
    
    override  func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.appDelegate.hideHud()
        GetAddress()
    }
    
    // MARK: - GetAddress
    
    func GetAddress()
    {
        
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
                        self.SettingTableView.reloadData()
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
    
    // MARK: - UITableView Delegate & Data Source
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.AddressListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell :AddressTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AddressTableViewCell") as! AddressTableViewCell!
        let AddressDict = self.AddressListArray[indexPath.row] as! NSDictionary
        let checkAddressDefault = AddressDict.value(forKey: "isDefault") as? Int
        if  checkAddressDefault == 1 {
            cell.setDefaultAddressBtn.setTitle("Default Address", for:.normal)
            cell.setDefaultAddressBtn.backgroundColor = CommonMethod.hexStringToUIColor(hex:"#8dc33b")
        }else{
            cell.setDefaultAddressBtn.setTitle("Set as Default Address", for:.normal)
            cell.setDefaultAddressBtn.backgroundColor = UIColor.red
        }
        cell.fullName.text = AddressDict.value(forKey: "fullName") as? String
        if let latestValue =  AddressDict.value(forKey: "mobileNo") as? String {
            cell.mobileNo.text = latestValue
        }
        cell.addresstype.text =  "Address Type: " + (AddressDict.value(forKey: "address_Type") as! String)
        let fullAddressStr = (AddressDict.value(forKey: "flat_No") as! String) + "," + (AddressDict.value(forKey: "buildingName") as! String) + "," + (AddressDict.value(forKey: "landmark") as! String) + "," + (AddressDict.value(forKey: "city") as! String) + "," + (AddressDict.value(forKey: "state") as! String)  + "," + (AddressDict.value(forKey: "pincode") as! String)
        cell.fullAddress.text = fullAddressStr
        cell.deleteBtn.tag = indexPath.row
        cell.editAddressBtn.tag = indexPath.row
        cell.setDefaultAddressBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(AddressDeleteBtnClicked(_:)), for:.touchUpInside)
        cell.editAddressBtn.addTarget(self, action: #selector(EditAddressBtnClicked(_:)), for:.touchUpInside)
        cell.setDefaultAddressBtn.addTarget(self, action: #selector(SetAddressDefaultAddress(_:)), for:.touchUpInside)
        
        return cell
    }
    
    // MARK: - AddressDeleteBtnClicked
    
    @objc func AddressDeleteBtnClicked(_ sender : UIButton) {
        let AddressDict = self.AddressListArray[sender.tag] as! NSDictionary
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.IsReachabilty! {
            let auth = UserDefaults.standard.value(forKey: "user_auth_token")!
            let token = "\(WebseviceNameConstant.StrJWT)\(auth)"
            let headerDict=["Authorization": token]
            
            WebserviceHelper.sharedInstance.callDeleteDataWithMethod(strMethodName:"address/delete/", requestDict: AddressDict.value(forKey: "_id") as? String, isHud: false, hudView: self.view, value: headerDict, successBlock:
                {  response, responseStr in print(response)
                    print("\(responseStr)");
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200{
                        let message = responseStr["message"] as! String
                        if message ==  "removed Successfully!"{
                            self.GetAddress()
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
          //  self.view.makeToast("Please check internet connection", duration: 0.5, position: CSToastPositionCenter)
            
            self.checkInternetConnection()

        }
        
    }
    
    // MARK: - AddNewAddressBtn_Clicked
    
    @IBAction func AddNewAddressBtn_Clicked(_ sender: Any) {
        let storyboard: AddressViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddressViewController") as! AddressViewController
        self.navigationController?.pushViewController(storyboard, animated: true)
    }
    
    // MARK: - EditAddressBtnClicked
    
    @objc func EditAddressBtnClicked(_ sender : UIButton) {
        let AddressDict = self.AddressListArray[sender.tag] as! NSDictionary
        let updateAddressViewController: UpdateAddressViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UpdateAddressViewController") as! UpdateAddressViewController
        updateAddressViewController.adddressDict = AddressDict as! [String : Any]
    present(updateAddressViewController, animated: true, completion: nil)
        
    }
    
    // MARK: - SetAddressDefaultAddress
    
    @objc func SetAddressDefaultAddress(_ sender : UIButton)
    {
        if sender.titleLabel?.text == "Default Address"
        {
            let alertWarning = UIAlertView(title:"TreckFresh", message: "Address already set default.", delegate:nil, cancelButtonTitle:"OK")
            alertWarning.show()
            return
        }
        let AddressDict = self.AddressListArray[sender.tag] as! NSDictionary
        let latitutude  = AddressDict["latitude"] as! Double
        let longitute = AddressDict["longitude"] as! Double
        print(latitutude, longitute)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.IsReachabilty! {
            let auth = UserDefaults.standard.value(forKey: "user_auth_token")!
            let token = "\(WebseviceNameConstant.StrJWT)\(auth)"
            let userlocationDict = ["post":["id":  AddressDict.value(forKey: "_id") as? String,
                                            "fullName": AddressDict.value(forKey:"fullName") as? String,
                                            "email_Id":AddressDict.value(forKey:"email_Id") as? String,
                                            "mobileNo":AddressDict.value(forKey:"fullmobileNoName") as? String,
                                            "flat_No":AddressDict.value(forKey:"flat_No") as? String,
                                            "buildingName":AddressDict.value(forKey:"buildingName") as? String,
                                            "landmark":AddressDict.value(forKey:"landmark") as? String,
                                            "city":AddressDict.value(forKey:"city") as? String,
                                            "state":AddressDict.value(forKey:"state") as? String,
                                            "pincode":AddressDict.value(forKey:"pincode") as? String,
                                            "address_Type":AddressDict.value(forKey:"address_Type") as? String,
                                            "isDefault":"true",
                                            "latitude":"\(latitutude)",
                "longitude":"\(longitute)"]]
            let headerDict=["Authorization": token]
            
            WebserviceHelper.sharedInstance.callPutDataWithMethod(strMethodName: "address/update", requestDict: userlocationDict , isHud: false, hudView: self.view, value: headerDict, successBlock:
                {  response, responseStr in print(response)
                    print("\(responseStr)");
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200{
                        print(response)
                        let dict = responseStr["message"] as! NSString
                        if dict == "Updated Successfully"{
                            self.GetAddress()
                        }
                    }
                    else{
                         let message = responseStr["message"] as! NSString
                        self.view.makeToast(message as String, duration: 0.5, position: CSToastPositionCenter)
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
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
