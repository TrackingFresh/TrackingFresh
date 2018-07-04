//
//  OrderdetailViewController.swift
//  GoogleFacebookLogin
//
//  Created by V kishore kumar reddy  on 1/30/18.
//  Copyright © 2018 Raju sharma. All rights reserved.
//

import UIKit

class OrderdetailViewController: UIViewController,UITableViewDataSource,UITableViewDelegate
{
  
    // MARK: - IBOutlets & Objects
    
    var  appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var OrderTableView: UITableView!
    var orderDaillArray = [String]()
    var arraycount : Int!
    var detailOrderModelArray : NSArray = []
    var customObject1 : LastOrderModel!
    var grandtotal: Double?
    var recievedDelievery:String!
    var customObject : OrderModal!
    var orderMainModelArray = [OrderModal]()
    var bikerID :String!

    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.title = "Order Review"
         self.customNavigationItem(stringText: "ORDER REVIEW", showbackButon: false)
        OrderTableView.delegate = self
        OrderTableView.dataSource = self
         OrderTableView.register(UINib(nibName: "OrderdetailCell2TableViewCell", bundle: nil), forCellReuseIdentifier: "OrderdetailCell2TableViewCell")
        print(detailOrderModelArray)
        print(customObject1)

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
        grandtotal = 0
        recievedDelievery = "Recieved"
        setBadge()
        
        for i in 0..<(self.detailOrderModelArray.count){
            self.customObject = OrderModal()
            let dictValue = self.detailOrderModelArray[i] as! NSDictionary as! [String : Any]
            self.customObject.initdata(Dict: dictValue)
            self.orderMainModelArray.append( self.customObject)
            
        }
        
         arraycount = self.orderMainModelArray.count + 1
        
        print( self.orderMainModelArray)
        self.OrderTableView.reloadData()

        self.appDelegate.hideHud()

    }
    
    // MARK: - didReceiveMemoryWarning
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableView Delegates and Data Source
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row < arraycount-1{
            return 85
        }else {
            //424 add condition for recieved delivery
            if(bikerID == nil)
            {
                return 442
            }else{
                return 765

            }

        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arraycount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row < arraycount-1 {
            let cell : OrderDetailCell1TableViewCell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailCell1TableViewCell") as! OrderDetailCell1TableViewCell!
            cell.layoutMargins = UIEdgeInsets.zero
            var LastOrderData:OrderModal
            LastOrderData = self.orderMainModelArray[indexPath.row]
            cell.productNameLBL.text = LastOrderData.productName
            cell.productQuantityLBL.text = LastOrderData.quantity + "  quantity"
            cell.productPriceLBL.text = DeviceSizeConstants.rupee + LastOrderData.sub_total
            //grandtotal = grandtotal + LastOrderData.sub_total
            cell.imageview.sd_setImage(with: URL(string:(LastOrderData.productImage)), placeholderImage: UIImage(named: " "))
             cell.viewBorder.layer.borderWidth = 0.1
            cell.viewBorder.layer.masksToBounds = false
            cell.viewBorder.layer.shadowOffset = CGSize(width: 1, height: 1)
            cell.viewBorder.layer.shadowRadius = 2
            cell.viewBorder.layer.shadowOpacity = 0.5
            cell.viewBorder.layer.shadowColor = UIColor.black.cgColor
            return cell
         }else{
            let cell :OrderdetailCell2TableViewCell = tableView.dequeueReusableCell(withIdentifier: "OrderdetailCell2TableViewCell") as! OrderdetailCell2TableViewCell!
            cell.layoutMargins = UIEdgeInsets.zero

               if(bikerID == nil){
                cell.starViewConstraintHeight.constant = 323
               }else{
                cell.starViewConstraintHeight.constant = 0
            }
            cell.setNeedsLayout()
            cell.setNeedsUpdateConstraints()
            cell.orderLBL.text = customObject1.orderNo
        
            let str1 = customObject1.createdAt
            let dateformtedExperieryDate = self.convertDateFormater(date: str1!)
            cell.orderPlaceNumberLBL.text = dateformtedExperieryDate
            let Pick = customObject1.pickUp
            if Pick == "1" {
               cell.orderTypeLBL.text = "PickUp"
            }else{
                cell.orderTypeLBL.text = "Delivery"
            }
            
            cell.orderDeliverLBL.text =  customObject1.delivery_charge
            let totalamt = Int(customObject1.totalprize)
            let deliveramt = Int(customObject1.delivery_charge)
            
           if customObject1.discount == ""{
                cell.couponAmount.text = " - "
            }else {
                
                cell.couponAmount.text =  " - " + DeviceSizeConstants.rupee + customObject1.discount
            }
            cell.grandTotalLBL.text = DeviceSizeConstants.rupee + String(totalamt!)
            cell.paymentStatusLBL.text = customObject1.paymentStatus
            cell.paymentModeLBL.text = customObject1.paymentMode
            cell.deliveryNameLBL.text =  customObject1.dict["fullName"] as? String
            let strflat_No = customObject1.dict["flat_No"] as! String
             let strbuildingName = customObject1.dict["buildingName"] as! String
            let strlandmark = customObject1.dict["landmark"] as! String
            let strcity = customObject1.dict["city"] as! String
            let strstate = customObject1.dict["state"] as! String
            let strpincode = customObject1.dict["pincode"] as! String
            let strmobileNo : String!
            if (customObject1.dict["mobileNo"] as AnyObject).isKind(of: NSNull.self){
               strmobileNo = ""
            }else {
            strmobileNo = customObject1.dict["mobileNo"] as! String
            }
            let FullAddress = strflat_No + " " + strbuildingName +  strlandmark + " \n "  + strcity + "," + strstate + "," + strpincode + "\n " + strmobileNo
            cell.deliveryAddressLBL.text = FullAddress
             cell.AddressView.layer.borderWidth = 0.1
            cell.AddressView.layer.masksToBounds = false
            cell.AddressView.layer.shadowOffset = CGSize(width: -1, height: 1)
            cell.AddressView.layer.shadowRadius = 1
            cell.AddressView.layer.shadowOpacity = 0.5
             cell.AddressView.layer.shadowColor = UIColor.black.cgColor
        
//            if recievedDelievery == "Recieved"{
//                cell.ratingView.isHidden = true
//                cell.starViewConstraintHeight.constant = 0
//
//            }else{
//                cell.ratingView.isHidden = false
//               cell.starViewConstraintHeight.constant = 323
//            }
      
           
            return cell
        
        }
    
    }
    
    
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
    
    @objc func rightButtonTouched() {
        let storyboard: MyCartViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyCartViewController") as! MyCartViewController
        let nav = UINavigationController(rootViewController: storyboard)
        self.slideMenuController()?.changeMainViewController(nav, close: true)
        
    }
    
    // MARK: - CheckVehicleMethod
   
    @IBAction func CheckVehicleMethod(_ sender: Any) {
            let trackOrdervViewController: TrackOrdervViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TrackOrdervViewController") as! TrackOrdervViewController
            self.navigationController?.pushViewController(trackOrdervViewController, animated: true)
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
        
        dateFormatter.dateFormat = "dd-MM-yyyy "
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        let timeStamp = dateFormatter.string(from: date)
        
        return timeStamp
    }

    
}
