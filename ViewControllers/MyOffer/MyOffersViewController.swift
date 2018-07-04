//
//  MyOffersViewController.swift
//  GoogleFacebookLogin
//
//  Created by V kishore kumar reddy  on 1/16/18.
//  Copyright © 2018 Raju sharma. All rights reserved.
//

import UIKit

class MyOffersViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate,SlideMenuControllerDelegate
{
    
    // MARK: - IBOutlets & Objects
    
    @IBOutlet weak var MyofferTableView: UITableView!
    
    var customObjectOfferproductCategory :OfferListModel!
    var ProductOfferdetailArray = [OfferListModel]()
     var checkdatabase : Bool!
    var foundRecord : Bool!
  
    let dbManager = DBManager()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var  ProductOfferlistArray: NSArray = []
    var datacheckaddressViewArrayOffer = [NSDictionary]()
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
       // self.title = "Offers"
       self.customNavigationItem(stringText: "OFFERS", showbackButon: false)

        // Do any additional setup after loading the view.
        MyofferTableView.delegate = self
        MyofferTableView.dataSource = self
        MyofferTableView.register(UINib(nibName: "OfferTableViewCell", bundle: nil), forCellReuseIdentifier: "OfferTableViewCell")

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
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.appDelegate.hideHud()
        self.setNavigationBarItem()
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        checkdatabase=dbManager.createDatabase()
     datacheckaddressViewArrayOffer = dbManager.loadAddresss() as! [NSDictionary]
        self.getOfferdetails()
        setBadge()
    }
    
    // MARK: - getOfferdetails
    
    func getOfferdetails()  {
   
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.IsReachabilty! {
            
            let auth = UserDefaults.standard.value(forKey: "user_auth_token")!
            let token = "\(WebseviceNameConstant.StrJWT)\(auth)"
            let vehicleID = UserDefaults.standard.value(forKey: "VehicleID")! as! String
            if vehicleID == ""{

                return
            }
            let headerDict=["Authorization": token]
            let dict = ["vehicleId":vehicleID]
            WebserviceHelper.sharedInstance.callGetDataWithMethod(strMethodName:"productRate/offer", requestDict: dict, isHud: false, hudView: self.view, value: headerDict, successBlock:
                {  response, responseStr in print(response)
                    print("\(responseStr)");
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200{
                        self.ProductOfferlistArray = responseStr["data"] as! NSArray
                        self.ProductOfferdetailArray.removeAll()
                        for i in 0..<(self.ProductOfferlistArray.count)
                        {
                            self.customObjectOfferproductCategory = OfferListModel()
                            let dictValue = self.ProductOfferlistArray[i] as! NSDictionary as! [String : Any]
                            self.customObjectOfferproductCategory.initdata(Dict: dictValue)
                            self.ProductOfferdetailArray.append( self.customObjectOfferproductCategory)
                            appDelegate.cartQuntityArray.add(dictValue)
                        }
                        print(appDelegate.cartQuntityArray)
                        self.MyofferTableView .reloadData()
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
        return 125
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ProductOfferdetailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell :OfferTableViewCell = tableView.dequeueReusableCell(withIdentifier: "OfferTableViewCell") as! OfferTableViewCell!
        var productDetail:OfferListModel
        productDetail = self.ProductOfferdetailArray[indexPath.row]
        
        cell.offerImage.sd_setImage(with: URL(string:(productDetail.productImage)), placeholderImage: UIImage(named: " "))
        cell.offerproductName.text = productDetail.productName
        cell.offerProductQuantity.text =  productDetail.quantity + " quantity"
        cell.OfferProuctRate.text =  DeviceSizeConstants.rupee + productDetail.selling_price
       
        cell.offerPrice.text =  DeviceSizeConstants.rupee + productDetail.MRP
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var productDetail:OfferListModel
          productDetail = self.ProductOfferdetailArray[indexPath.row]
        let productItemViewController: ProductItemViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductItemViewController") as! ProductItemViewController
        productItemViewController.navTitle = productDetail.productName
        productItemViewController.offerdetail = "OfferDetail"
        productItemViewController.OfferProductselectedCategory =  self.ProductOfferdetailArray[indexPath.row]
        self.navigationController?.pushViewController(productItemViewController, animated: true)
    }
    
    // MARK: - CartBtnClicked
  
    @objc func CartBtnClicked(_ sender : UIButton) {
        var productDetail:OfferListModel
        productDetail = self.ProductOfferdetailArray[sender.tag]
        checkdatabase=dbManager.createDatabase()
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
                        "QuantityinStock": productDetail.quantity ]
        dbManager.insertMovieData(Dict: dict as! [String : String])
            let cartcount =  UserDefaults.standard.integer(forKey: "cartcount")
            let incraseCount = cartcount + 1
            DispatchQueue.main.async {
                self.appDelegate.label?.text = String(incraseCount)
            }
        UserDefaults.standard.set(incraseCount, forKey: "cartcount")
            
         self.setBadge()
        }else{
            datacheckaddressViewArrayOffer = dbManager.loadAddresss() as! [NSDictionary]
            foundRecord = false
            for i in 0..<(datacheckaddressViewArrayOffer.count){
                let dbDict = datacheckaddressViewArrayOffer[i] as! [String : Any]
                let dbproductid = dbDict["productId"] as! String
                let offerproductid = productDetail.productId
                if dbproductid == offerproductid {
                    self.view.makeToast("Product is already in Cart.", duration: 1.0, position: CSToastPositionCenter)
                foundRecord = true
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
                            "QuantityinStock": productDetail.quantity ]
                dbManager.insertMovieData(Dict: dict as! [String : String])
                let cartcount =  UserDefaults.standard.integer(forKey: "cartcount")
                let incraseCount = cartcount + 1
                UserDefaults.standard.set(incraseCount, forKey: "cartcount")
                DispatchQueue.main.async {
                    self.appDelegate.label?.text = String(incraseCount)
                }
                //label?.text = String(incraseCount)

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
                        
                        if dbDict1["quantity"] as? String == "0"
                        {
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
  
       // }
    }
    
    // MARK: - offerPlusBtnClicked
    
    @objc func offerPlusBtnClicked(_ sender : UIButton) {
        print(sender.tag)
        
        let cell = sender.superview?.superview?.superview as? OfferTableViewCell
        var productDetail:OfferListModel!
        productDetail = self.ProductOfferdetailArray[sender.tag]
        let qty = cell?.offerQtyIncrease!.text
        if Int(qty!)! < Int(productDetail.quantity)! {
            let addtion = Int(qty!)! + 1
           // cell?.offerQtyIncrease.text = "\(addtion)"
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
    
    // MARK: - offerminusBtnClicked
    
    @objc func offerminusBtnClicked(_ sender : UIButton) {
        print(sender.tag)
        let cell = sender.superview?.superview?.superview as? OfferTableViewCell
        var productDetail:OfferListModel!
        productDetail = self.ProductOfferdetailArray[sender.tag]
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
