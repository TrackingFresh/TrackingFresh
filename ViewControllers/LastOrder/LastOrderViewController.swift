//
//  LastOrderViewController.swift
//  GoogleFacebookLogin
//
//  Created by V kishore kumar reddy  on 1/16/18.
//  Copyright © 2018 Raju sharma. All rights reserved.
//

import UIKit

class LastOrderViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,SlideMenuControllerDelegate,testProtocol
{

    // MARK: - IBOutlets & Objects
    
    @IBOutlet weak var LastOrderTableView: UITableView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    var customObject : LastOrderModel!
    var LastOrderModelArray = [LastOrderModel]()
    var checkdatabase : Bool!
     let dbManager = DBManager()
    var OrderListArray : NSArray = []
    var  ProductListListArray: NSArray = []
    
    // MARK: - viewDidLoad
 
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.title = "Last Order"
        self.customNavigationItem(stringText: "LAST ORDER", showbackButon: false)
        
        self.setNavigationBarItem()
        // Do any additional setup after loading the view.
        LastOrderTableView.delegate = self
        LastOrderTableView.dataSource = self
        LastOrderTableView.register(UINib(nibName: "lastOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "LastOrderCell")
        LastOrderTableView.layoutMargins = UIEdgeInsets.zero
        LastOrderTableView.separatorInset = UIEdgeInsets.zero
        LastOrderTableView.tableFooterView = UIView()
        setBadge()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool)
    {
       
        super.viewWillAppear(animated)
       
            self .getLastOrder()
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
    
    // MARK: - testDelegate
    
    func testDelegate()
    {
       getLastOrder()
    }
    
    // MARK: - backAction
    
    @objc func backAction()
    {
         self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - getLastOrder
  
    func getLastOrder()  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.IsReachabilty! {
        
            let auth = UserDefaults.standard.value(forKey: "user_auth_token")!
            let token = "\(WebseviceNameConstant.StrJWT)\(auth)"
            let headerDict=["Authorization": token]
            let dict = ["userId":UserDefaults.standard.value(forKey: "CustmerID")!]

            WebserviceHelper.sharedInstance.callGetDataWithMethod(strMethodName:"order/orderList", requestDict: dict, isHud: false, hudView: self.view, value: headerDict, successBlock:
                {  response, responseStr in print(response)
                    print("\(responseStr)");
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200{
                        if self.LastOrderModelArray.count > 0  {
                            self.LastOrderModelArray.removeAll()
                        }
                        self.OrderListArray = (responseStr["data"] as! NSArray)
                        for i in 0..<(self.OrderListArray.count){
                            self.customObject=LastOrderModel()
                            let dictValue = self.OrderListArray[i] as! NSDictionary as! [String : Any]
                            self.customObject.initdata(Dict: dictValue)
                            self.LastOrderModelArray.append( self.customObject)
                        }
                        self.LastOrderTableView.reloadData()
                    }
                    else{
//                        let userDict=responseStr ["user_msg" ] as! String
//                        Alertviewclass.showalertMethod("Error", strBody:"\(userDict)!" as NSString, delegate: nil)
                    }
            },
            errorBlock: {error in
//            Alertviewclass.showalertMethod("Error", strBody: "Enter value !", delegate: nil)
            })
        }
        else{
            // self.view.makeToast("Please check internet connection", duration: 0.5, position: CSToastPositionCenter)
            
            
            self.checkInternetConnection()

        }
        
    }
    
    // MARK: - didReceiveMemoryWarning
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableView Delegate & Data Source
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 165
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.OrderListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell :lastOrderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "LastOrderCell") as! lastOrderTableViewCell!
         cell.layoutMargins = UIEdgeInsets.zero
        var LastOrderData:LastOrderModel
        LastOrderData = self.LastOrderModelArray[indexPath.row]
        cell.OrderNo.text = "#" + LastOrderData.orderNo
        cell.TotalPrice.text = DeviceSizeConstants.rupee + LastOrderData.total_price
        let DateStr = LastOrderData.createdAt
        let fullDate = DateStr?.components(separatedBy:"T")
        cell.OrderCreateAt.text = fullDate?[0]
        let OrderStatus = LastOrderData.status
        if OrderStatus == "Pending" {
            cell.bigRepeatOrderBtn.isHidden = true
            cell.CancelReasonLbl.isHidden = true
            cell.CancelReasonValue.isHidden = true
            cell.OrderStatus.backgroundColor = UIColor(hex:"f7c000")
             cell.cancelBtn.isHidden = false
            cell.cancelBtn.backgroundColor = UIColor(hex:"e44a30")
            cell.OrderStatus.setTitle(OrderStatus, for: .normal)
            cell.RepeatCancelView.isHidden = false
            cell.RepeatOrderBtn.isHidden = false

        }
        else if OrderStatus == "Accepted" {
            cell.bigRepeatOrderBtn.isHidden = true
            cell.CancelReasonLbl.isHidden = true
            cell.CancelReasonValue.isHidden = true
            cell.OrderStatus.backgroundColor = UIColor(hex:"8dc33b")
            cell.cancelBtn.backgroundColor = UIColor(hex:"e44a30")
            cell.cancelBtn.isHidden = false
            cell.OrderStatus.setTitle(OrderStatus, for: .normal)
            cell.RepeatCancelView.isHidden = false
            cell.RepeatOrderBtn.isHidden = false


        } else if OrderStatus == "Delivered"{
            cell.bigRepeatOrderBtn.isHidden = false
            cell.CancelReasonLbl.isHidden = true
            cell.CancelReasonValue.isHidden = true
             cell.cancelBtn.isHidden = true
            cell.OrderStatus.backgroundColor = UIColor(hex:"8dc33b")
            cell.OrderStatus.setTitle(OrderStatus, for: .normal)
            cell.RepeatCancelView.isHidden = true
            cell.RepeatOrderBtn.isHidden = true


        }
        else if OrderStatus == "Rejected"{
            cell.bigRepeatOrderBtn.isHidden = true
            cell.CancelReasonLbl.isHidden = true
            cell.CancelReasonValue.isHidden = true
            cell.cancelBtn.isHidden = true
            cell.OrderStatus.backgroundColor = UIColor(hex:"e44a30")
            cell.OrderStatus.setTitle(OrderStatus, for: .normal)
            cell.RepeatCancelView.isHidden = false
            cell.RepeatOrderBtn.isHidden = false

        }
        else if OrderStatus == "Cancelled" {
            cell.CancelReasonLbl.isHidden = false
            cell.CancelReasonValue.isHidden = false
            cell.CancelReasonValue.text =  LastOrderData.Cancelreason
            cell.RepeatOrderBtn.isHidden = true
            cell.bigRepeatOrderBtn.isHidden = false
            cell.cancelBtn.isHidden = true
            cell.OrderStatus.backgroundColor = UIColor(hex:"e44a30")
            cell.OrderStatus.setTitle(OrderStatus, for: .normal)
            cell.RepeatCancelView.isHidden = true
        }
        
        
        cell.LastOrderView.layer.borderWidth = 0.1
        cell.LastOrderView.layer.masksToBounds = false
        cell.LastOrderView.layer.shadowOffset = CGSize(width: 1, height: 1)
        cell.LastOrderView.layer.shadowRadius = 2
        cell.LastOrderView.layer.shadowOpacity = 0.5
        cell.LastOrderView.layer.shadowColor = UIColor.black.cgColor
        cell.RepeatOrderBtn.tag = indexPath.row
        cell.cancelBtn.tag =  indexPath.row
        cell.bigRepeatOrderBtn.tag = indexPath.row
        cell.RepeatOrderBtn.addTarget(self, action: #selector(RepeatOrderBtnClicked(_:)), for:.touchUpInside)
          cell.bigRepeatOrderBtn.addTarget(self, action: #selector(RepeatOrderBtnClicked(_:)), for:.touchUpInside)
        cell.cancelBtn.addTarget(self, action: #selector(CancalBtnClicked(_:)), for:.touchUpInside)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        let orderdetailViewController: OrderdetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderdetailViewController") as! OrderdetailViewController
         var bikerid: String? = nil
        let bikerDict = self.OrderListArray[indexPath.row] as! NSDictionary
        if bikerDict["bikerId"] != nil {
            bikerid = bikerDict["bikerId"] as? String
        }
        var LastOrderData:LastOrderModel
        LastOrderData = self.LastOrderModelArray[indexPath.row]
        let orderid = LastOrderData.ID
        UserDefaults.standard.set(orderid, forKey: "OrderId")
        UserDefaults.standard.synchronize()
        orderdetailViewController.detailOrderModelArray = LastOrderData.OrderrArray as! [LastOrderModel] as NSArray
        
        orderdetailViewController.bikerID = bikerid
        orderdetailViewController.customObject1 = self.LastOrderModelArray[indexPath.row]
        self.navigationController?.pushViewController(orderdetailViewController, animated: true)
    }
    
    // MARK: - CancalBtnClicked
    
    @objc func CancalBtnClicked(_ sender : UIButton)
    {
        var LastOrderData:LastOrderModel
        LastOrderData = self.LastOrderModelArray[sender.tag]
       let cancelOrderViewController: CancelOrderViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CancelOrderViewController") as! CancelOrderViewController
        cancelOrderViewController.cancelReasion = "cancel"
        cancelOrderViewController.OrderID = LastOrderData.ID
        //self.present(cancelOrderViewController, animated: true, completion: nil)
        self.present(cancelOrderViewController, animated: true, completion: nil)
//        self.presentViewController(cancelOrderViewController, animated: true, completion: nil)

    }
    
     // MARK: - RepeatOrderBtnClicked
    
     @objc func RepeatOrderBtnClicked(_ sender : UIButton) {
        
        let titlename = sender.titleLabel?.text
        if titlename == "CANCEL" {
            CancalBtnClicked(sender)
        }else{
            checkdatabase=dbManager.createDatabase()
            var result : Bool = false
            result = dbManager.deleteAllRecord()
            if result == true {
                var LastOrderData:LastOrderModel
                LastOrderData = self.LastOrderModelArray[sender.tag]
                let  vehicaleIdStr = LastOrderData.vehicleId
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                if appDelegate.IsReachabilty! {
                    let auth = UserDefaults.standard.value(forKey: "user_auth_token")!
                    let token = "\(WebseviceNameConstant.StrJWT)\(auth)"
                    let userlocationDict = ["post":["products": LastOrderData.OrderrArray,"vehicleId":vehicaleIdStr!]]
                    let headerDict=["Authorization": token]
                    
                    WebserviceHelper.sharedInstance.callPostDataWithMethod(methodName: "vehicleStock/repeatOrder", requestDict: userlocationDict , headerValue: headerDict, isHud: false, hudView: self.view, successBlock:
                        {  response, responseStr in print(response)
                            print("\(responseStr)");
                            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200{
                                print(response)
                                let dict = responseStr["data"] as! NSDictionary
                                self.ProductListListArray = (dict["products"] as! NSArray) as! [NSDictionary] as NSArray
                                if self.ProductListListArray.count > 0 {
                                    for i in 0..<(self.ProductListListArray.count)
                                    {
                                        let ProductDict = self.ProductListListArray[i] as! NSDictionary
                                        let dict = ["_id":ProductDict["_id"] as! String,
                                                    "productId": ProductDict["productId"] as! String,
                                                    "quantity":String(ProductDict["quantity"] as! Int),
                                                    "unitsOfMeasurement": ProductDict["unitsOfMeasurement"] as! String,
                                                    "productName":ProductDict["productName"] as! String,
                                                    "unit": String(ProductDict["unit"]as! Int),
                                                    "productDetails":ProductDict["productDetails"] as! String,
                                                    "productImage": ProductDict["productImage"] as! String,
                                                    "brand": ProductDict["brand"] as! String,
                                                    "selling_price": String(ProductDict["selling_price"] as! Int),
                                                    "offer":" av",
                                                    "MRP": String(ProductDict["MRP"]as! Int),
                                                    "QuantityinStock": String(ProductDict["availableQuantity"]as! Int)
                                        ]
                                        self.checkdatabase = self.dbManager.createDatabase()
                                        self.dbManager.insertMovieData(Dict: dict as! [String : String] )
                                        //                                    let cartcount =  UserDefaults.standard.integer(forKey: "cartcount")
                                        //                                    let incraseCount = cartcount + 1
                                        //                                    UserDefaults.standard.set(incraseCount, forKey: "cartcount")
                                        let storyboard: MyCartViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyCartViewController") as! MyCartViewController
                                        let nav = UINavigationController(rootViewController: storyboard)
                                        self.slideMenuController()?.changeMainViewController(nav, close: true)
                                    }
                                }else{
                                    var alert:UIAlertController?
                                    alert = UIAlertController(title: "Tracking Fresh", message: "Sorry..Currently no products for the order are availble in vehicle!", preferredStyle:
                                        UIAlertControllerStyle.alert)
                                    alert?.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler:{ (UIAlertAction)in
                                        // self.CancelAlert()
                                    }))
                                    self.present(alert!, animated: true, completion:nil)
                                }
                                
                            }
                            else{
                                //                            let message = responseStr ["message" ] as? NSString
                                //                            print(message ?? 0);
                                //                           self.view.makeToast(message! as String, duration: 0.5, position: CSToastPositionCenter)
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
    
    // MARK: - setBadge
    
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
    
    // MARK: - rightButtonTouched
    
    @objc func rightButtonTouched()
    {
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
    
    
}
