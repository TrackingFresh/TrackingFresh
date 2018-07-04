//
//  CancelOrderViewController.swift
//  GoogleFacebookLogin
//
//  Created by V kishore kumar reddy  on 3/9/18.
//  Copyright © 2018 Raju sharma. All rights reserved.
//

import UIKit

// MARK: - testProtocol

protocol testProtocol
{
    func testDelegate()
}
class CancelOrderViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{

    // MARK: - IBOutlets & Objects
    
    @IBOutlet weak var customView: UIView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var delegate: testProtocol?
    var OrderID : String!
    var cancelReasion : String!
    var SelectedReason : String!
    //var cancelReasion = String()
    var  CancelResionListArray: NSArray = []
    
    @IBOutlet var CanelResionTableView: UITableView!
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(cancelReasion)
        CanelResionTableView.delegate = self
        CanelResionTableView.dataSource = self
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
//        self.view.addGestureRecognizer(tap)
        self.view.backgroundColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.5)
        // Do any additional setup after loading the view.
        CancelOrder()
    }
    
    // MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.appDelegate.hideHud()
        
    }
    
    // MARK: - handleTap
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
//        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - CommonCancelResignBtn_Clicked
   
    @IBAction func CommonCancelResignBtn_Clicked(_ sender: UIButton) {
        cancelReasion = (sender.titleLabel?.text)!
        print(cancelReasion )
    }
    
    // MARK: - SubmitBtnClicked
    
    @IBAction func SubmitBtnClicked(_ sender: Any) {
       
        if self.appDelegate.IsReachabilty! {
            let auth = UserDefaults.standard.value(forKey: "user_auth_token")!
            let token = "\(WebseviceNameConstant.StrJWT)\(auth)"
            let userlocationDict = ["post":["id":OrderID,"status":"Cancelled","reason":SelectedReason]]
            //            let userlocationDict = ["id":orderId,"status": "Pending","payment_Mode":"COD","payment_Status":"Pending"]

            let headerDict=["Authorization": token]

            WebserviceHelper.sharedInstance.callPutDataWithMethod(strMethodName: "order/update", requestDict: userlocationDict as Dictionary<String, Any>, isHud: true, hudView: self.view, value: headerDict,successBlock: { (success, response) in
                print("\(response)");
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200{
                     let message = response ["message" ] as? NSString
                     self.view.makeToast(message! as String, duration: 0.5, position: CSToastPositionCenter)
                    self.delegate?.testDelegate()
                    self.dismiss(animated: true, completion: nil)
                    
                }
                else{
                    let message = response ["message" ] as? NSString
                    self.view.makeToast(message! as String, duration: 0.5, position: CSToastPositionCenter)
                    self.delegate?.testDelegate()
                self.dismiss(animated: true, completion: nil)
                    
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
    
    // MARK: - CancelOrder
    
    func CancelOrder()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.IsReachabilty! {
            let auth = UserDefaults.standard.value(forKey: "user_auth_token")!
            let token = "\(WebseviceNameConstant.StrJWT)\(auth)"
            let headerDict=["Authorization": token]
            let resonStr = "reason=" + cancelReasion
            print(resonStr)
            
            WebserviceHelper.sharedInstance.callMobileVerifyGetDataWithMethod(strMethodName:"order/reason?", requestDict:resonStr as! String, isHud: false, hudView: self.view, value: headerDict, successBlock:
                {  response, responseStr in print(response)
                    print("\(responseStr)");
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200{
                        self.CancelResionListArray = (responseStr["data"] as! NSArray)
                        self.CanelResionTableView.reloadData()
                    }
                    else{
                    }
            },
               errorBlock: {error in
               //self.view.makeToast(error.d as String, duration: 0.5, position: CSToastPositionCenter)
                                                                    
            })
        }
        else{
          //  self.view.makeToast("Please check internet connection", duration: 0.5, position: CSToastPositionCenter)
            
            self.checkInternetConnection()

        }
        
    }
    
    // MARK: - UITableView Delegate & Data Source
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.CancelResionListArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell :CancelOrderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CancelOrderTableViewCell") as! CancelOrderTableViewCell!
        let regionDict = self.CancelResionListArray[indexPath.row] as! NSDictionary
        cell.resonLbl.text = regionDict["reason"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let regionDict = self.CancelResionListArray[indexPath.row] as! NSDictionary
            SelectedReason = regionDict["reason"] as? String
        
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
