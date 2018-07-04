//
//  ConfirmOrderViewController.swift
//  GoogleFacebookLogin
//
//  Created by V kishore kumar reddy  on 2/23/18.
//  Copyright © 2018 Raju sharma. All rights reserved.
//

import UIKit

class ConfirmOrderViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource
{
    
    // MARK: - IBOutlets & Objects
    
    @IBOutlet weak var finalTotalPriceLbl: UILabel!
    @IBOutlet weak var DeliverChargeLbl: UILabel!
    @IBOutlet weak var orderStatusLbl: UILabel!
    @IBOutlet weak var ConfirmOrderTabaleView: UITableView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var totalprice : Int = 0
    var TotalProductPrize : String?
    var alert:UIAlertController?
    let dbManager = DBManager()
    var checkdatabase : Bool!
    var datacheckaddressViewArrayCart = [NSDictionary]()
    var finalCartArray = [NSDictionary]()
    var addCartArray = [NSDictionary]()
var  OrderCartListArray: NSArray = []
    
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ConfirmOrderTabaleView.dataSource = self
        ConfirmOrderTabaleView.delegate = self
       
         self.customNavigationItem(stringText: "CONFIRM ORDER", showbackButon: false)
        
        ConfirmOrderTabaleView.tableFooterView = UIView()
        
        ConfirmOrderTabaleView.register(UINib(nibName: "ConfirmOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "ConfirmOrderTableViewCell")
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
    
    // MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkdatabase=dbManager.createDatabase()
        datacheckaddressViewArrayCart = dbManager.loadAddresss() as! [NSDictionary]
        print(datacheckaddressViewArrayCart.count)
        self.appDelegate.hideHud()
        if finalCartArray.count>0 {
            finalCartArray.removeAll()
        }
        
        for i in 0..<(datacheckaddressViewArrayCart.count){
            let dbDict1 = datacheckaddressViewArrayCart[i] as! [String : Any]
            let dict = ["productId":dbDict1["productId"],
                        "productName": dbDict1["productName"],
                        "quantity":dbDict1["quantity"],
                        "price": dbDict1["selling_price"],
                        "productImage":dbDict1["productImage"],
                         ]
            finalCartArray.append(dict as NSDictionary)
    }
        getFare();
    }
 
    // MARK: - getFare
    
    func getFare(){
        if self.appDelegate.IsReachabilty! {
                let auth = UserDefaults.standard.value(forKey: "user_auth_token")!
                let vehicleID = UserDefaults.standard.value(forKey: "VehicleID")! as! String
             if vehicleID == ""{
                return
            }
                let token = "\(WebseviceNameConstant.StrJWT)\(auth)"
                let userlocationDict = ["post":["orders": finalCartArray,"vehicleId":vehicleID]]
                let headerDict=["Authorization": token]

                WebserviceHelper.sharedInstance.callPostDataWithMethod(methodName: "order/getfare", requestDict: userlocationDict , headerValue: headerDict, isHud: false, hudView: self.view, successBlock:
                    {  response, responseStr in print(response)
                        print("\(responseStr)");
                        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200{
                            print(response)
                            let dict = responseStr["data"] as! NSDictionary
                            self.OrderCartListArray = (dict["orders"] as! NSArray) as! [NSDictionary] as NSArray
                            let delivery = dict["delivery_charge"] as! Int
                            self.totalprice = dict["total_price"] as! Int
                            self.TotalProductPrize = String(self.totalprice)
                            self.DeliverChargeLbl.text =  DeviceSizeConstants.rupee + String(delivery)
                            self.finalTotalPriceLbl.text =  DeviceSizeConstants.rupee + String(self.totalprice)
                            self.ConfirmOrderTabaleView.reloadData()
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
           // self.view.makeToast("Please check internet connection", duration: 0.5, position: CSToastPositionCenter)
            
            self.checkInternetConnection()

        }
    }
    
    // MARK: - didReceiveMemoryWarning

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableView Delegates & Data Source
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.OrderCartListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell :ConfirmOrderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ConfirmOrderTableViewCell") as! ConfirmOrderTableViewCell!
          let dbDict1 = OrderCartListArray[indexPath.row] as! [String : Any]
        let SubTotal = dbDict1["sub_total"] as! Int
        let price = dbDict1["price"] as! Int
        cell.ProductName.text = dbDict1["productName"] as? String
        cell.ProductQty.text = dbDict1["quantity"] as! String  + " quantity"
        cell.ProductTotalPrize.text = DeviceSizeConstants.rupee + String(SubTotal)
        cell.ProductPrize.text =  DeviceSizeConstants.rupee + String(price)
        cell.ProductImage.sd_setImage(with: URL(string:(dbDict1["productImage"] as? String)!), placeholderImage: UIImage(named: " "))
        
        return cell
    }
    
    // MARK: - callActionshitWithTimer
    
    func callActionshitWithTimer(){
        DispatchQueue.main.async() {
            
            if(self.alert != nil){
                let when = DispatchTime.now() + 5
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
           
            self.present(self.alert!, animated: true, completion:nil)
        }
    
    }
    
    
    // MARK: - textFieldHandler
    
    func textFieldHandler(textField: UITextField!)
    {
        if (textField) != nil {
            textField.placeholder = "Please enter your number"
        }
    }
    
    // MARK: - handlePromocode
    
    func handlePromocode(code: String) -> Void {
        
        if code == ""  {
            self.view.makeToast("Please enter your number", duration: 0.5, position: CSToastPositionCenter)
            self.alert?.dismiss(animated: false, completion: nil)
            callActionshitWithTimer()
        }else{
            self.alert?.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    // MARK: - ConfirmOrderBtn_Clicked
    
    @IBAction func ConfirmOrderBtn_Clicked(_ sender: Any) {
        let paymentViewController: PaymentViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
        paymentViewController.totalPrize = self.TotalProductPrize!
        paymentViewController.finalOrderPrize = String(self.totalprice)
        for i in 0..<(datacheckaddressViewArrayCart.count){
            let dbDict1 = datacheckaddressViewArrayCart[i] as! [String : Any]
            let dict1 = ["productId":dbDict1["productId"],
                         "productName": dbDict1["productName"],
                         "quantity":dbDict1["quantity"],
                         "price": dbDict1["selling_price"],
                         "active": "Y",
                         "productCategory": "Amul",
                         "_id":dbDict1["_id"],
                         "unitsOfMeasurement":dbDict1["unitsOfMeasurement"],
                         "productCategoryId": "59804c37c4992b718f8c16e2",
                         "productDescription": "Fresh cow",
                         "productDetails":dbDict1["productDetails"],
                         "unit":dbDict1["unit"],
                         "unitsOfMeasurementId": "5980699dc4992b718f8c16ff",
                         "productImage":dbDict1["productImage"],
                         "brand":dbDict1["brand"],
                         "availableQuantity": "20",
                         "MRP":dbDict1["MRP"],
                         ]
            addCartArray.append(dict1 as NSDictionary)
        }
        paymentViewController.datacheckaddressViewArrayCart = addCartArray
        self.navigationController?.pushViewController(paymentViewController, animated: true)
       // callActionshitWithTimer()
        
       
//
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        if appDelegate.IsReachabilty! {
//            let auth = UserDefaults.standard.value(forKey: "user_auth_token")!
//            let vehicleID = UserDefaults.standard.value(forKey: "VehicleID")!
//            let token = "\(WebseviceNameConstant.StrJWT)\(auth)"
//            let userlocationDict = ["post":["orders": addCartArray,"total_price":self.finalTotalPriceLbl.text as Any,"pickUp":UserDefaults.standard.bool(forKey: "isCheck"),"vehicleId":vehicleID]]
//            let headerDict=["Authorization": token]
//            WebserviceHelper.sharedInstance.callPostDataWithMethod(methodName: "order/add", requestDict: userlocationDict , headerValue: headerDict, isHud: false, hudView: self.view, successBlock:
//                {  response, responseStr in print(response)
//                    print("\(responseStr)");
//                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200{
//                        let messageResponse = responseStr["message"]  as! [String : Any]
//                        let orderIdReponse = messageResponse["_id"] as? String
//                        UserDefaults.standard.set(orderIdReponse, forKey: "OrderId")
//                        UserDefaults.standard.synchronize()
//                        let paymentViewController: PaymentViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
//                        paymentViewController.orderPlacedDict = messageResponse as NSDictionary
//                        paymentViewController.totalPrize = self.TotalProductPrize!
//                        paymentViewController.finalOrderPrize = String(self.totalprice)
//                        paymentViewController.orderId = orderIdReponse as! String
//                        self.navigationController?.pushViewController(paymentViewController, animated: true)
//                    }
//                    else{
//                        let message = responseStr ["message" ] as? NSString
//                        print(message ?? 0);
//                        self.view.makeToast(message! as String, duration: 0.5, position: CSToastPositionCenter)
//                    }
//            },
//                                                                   errorBlock: {error in
//
//            })
//
//        }
//        else{
//            self.view.makeToast("Please check internet connection", duration: 0.5, position: CSToastPositionCenter)
//
//        }
//
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
