//
//  ProductItemViewController.swift
//  GoogleFacebookLogin
//
//  Created by V kishore kumar reddy  on 1/25/18.
//  Copyright © 2018 Raju sharma. All rights reserved.
//

import UIKit
private var timer: Timer?
class ProductItemViewController: UIViewController,UITableViewDataSource,UITableViewDelegate
{
    // MARK: - IBOutlets & Objects
 
    let cellReuseIdentifier = "cell"
 var ProductselectedCategory :productCategoryDetailModel!
    var OfferProductselectedCategory :OfferListModel!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var navTitle = String()
    var offerdetail = String()

    @IBOutlet weak var tableView: UITableView!
    var scrollView: UIScrollView!
    var datacheckaddressViewArray = [NSDictionary]()

    var checkdatabase : Bool!
    var foundRecord : Bool!
    let dbManager = DBManager()
    var datacheckaddressViewArrayOffer = [NSDictionary]()
    
    var customObjectproductCategory :productCategoryDetailModel!
    var ProductByCategorydetailArray = [productCategoryDetailModel]()
    
    
    var offerObjectproductCategory : OfferListModel!
    var offerByCategorydetailArray = [OfferListModel]()
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        //self.title = "Product"
        self.customNavigationItem(stringText: navTitle, showbackButon: false)
        
        tableView.delegate=self
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.register(ProductItemTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        setBadge()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.appDelegate.hideHud()
        setBadge()
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
        
        self.appDelegate.flag = "menu"
        UserDefaults.standard.set(self.appDelegate.flag, forKey: "menu")
        UserDefaults.standard.synchronize()
        
    }
    
   
    // MARK: -UITableView Delegate and Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        if indexPath.row  == 0 {
            return 168
        }
        else{
     return 550

        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      if offerdetail == "OfferDetail"   {
        if indexPath.row == 0 {
            let cell:ProductDetailImageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailImageTableViewCell") as! ProductDetailImageTableViewCell!
            
            cell.imageScroller.delegate = self as? ImageScrollerDelegate
            cell.imageScroller.isAutoScrollEnabled = true
            cell.imageScroller.scrollTimeInterval = 2.0 //time interval
            cell.imageScroller.scrollView.bounces = false
            var Imagearray = [String]()
            Imagearray.append(self.OfferProductselectedCategory.productImage)
            print(Imagearray)
            cell.imageScroller.setupScrollerWithImages(images:Imagearray as NSArray, offer: "Offer")
            return cell
        }
        else{
            let cell:ProductItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProductItemTableViewCell") as! ProductItemTableViewCell!
            
            var image1 : UIImage = UIImage(named: "offericon")!
//            let offerstr = self.OfferProductselectedCategory.quantity
//            if offerstr == "1"
//            {
                cell.offerimage.image = image1
            //}
            cell.priceQuntityLBL.text = self.OfferProductselectedCategory.quantity + " quantity"
            cell.priceQuantityMrpLBL.text = self.OfferProductselectedCategory.MRP
            cell.priceQuntityMrp2LBL.text =  DeviceSizeConstants.rupee + self.OfferProductselectedCategory.selling_price
//            cell.descriptionLBL.text = self.OfferProductselectedCategory.productDetails + "\n" + self.OfferProductselectedCategory.productDescription + ","
            cell.categoryNameLBL.text = self.OfferProductselectedCategory.productName
            //cell.manufactureDateLBL.text = self.ProductselectedCategory.mfgDate
           // cell.manufractureExpireLBL.text = self.ProductselectedCategory.expDate
            cell.manufactureDateLBL.text = "-"
            cell.manufractureExpireLBL.text = "-"
//            cell.qcCertificateLBL.text = self.OfferProductselectedCategory.qc
//            cell.batchNumberLBL.text = self.OfferProductselectedCategory.batchNo
            cell.PlusBtn.tag = indexPath.row
            cell.MinusBtn.tag = indexPath.row
            cell.addtoCartBTN.tag = indexPath.row
            cell.QtyIncreaseView.isHidden = true
            
            cell.addtoCartBTN.addTarget(self, action: #selector(CartBtnClicked(_:)), for:.touchUpInside)
            cell.PlusBtn.addTarget(self, action: #selector(offerPlusBtnClicked(_:)), for:.touchUpInside)
            cell.MinusBtn.addTarget(self, action: #selector(offerminusBtnClicked(_:)), for:.touchUpInside)
            cell.goCartBTN.addTarget(self, action: #selector(CartMoveClicked (_:)), for:.touchUpInside)
            cell.checkOutBTN.addTarget(self, action: #selector(checkOutBTNClicked(_:)), for:.touchUpInside)
            
            return cell
        }
        
      ///////
      }else{
        if indexPath.row == 0 {
            let cell:ProductDetailImageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailImageTableViewCell") as! ProductDetailImageTableViewCell!
            
            cell.imageScroller.delegate = self as? ImageScrollerDelegate
            cell.imageScroller.isAutoScrollEnabled = true
            cell.imageScroller.scrollTimeInterval = 2.0 //time interval
            cell.imageScroller.scrollView.bounces = false
            print( self.ProductselectedCategory.productImages)
//            cell.imageScroller.setupScrollerWithImages(images: self.ProductselectedCategory.productImages )
            cell.imageScroller.setupScrollerWithImages(images:self.ProductselectedCategory.productImages as NSArray, offer: "no")

            
            return cell
        }
        else{
            let cell:ProductItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProductItemTableViewCell") as! ProductItemTableViewCell!
            
                 let offerstr = self.ProductselectedCategory.offer
               if offerstr == "1"{
                cell.offerimage.isHidden = false
                let image1 : UIImage = UIImage(named: "offericon")!
                cell.offerimage.image = image1
               }else{
                cell.offerimage.isHidden = true
            }
            cell.priceQuntityLBL.text = self.ProductselectedCategory.quantity + " quantity"
            cell.priceQuantityMrpLBL.text = self.ProductselectedCategory.MRP
            cell.priceQuntityMrp2LBL.text = DeviceSizeConstants.rupee + self.ProductselectedCategory.selling_price
            cell.descriptionLBL.text = self.ProductselectedCategory.productDetails + "\n" + self.ProductselectedCategory.productDescription + ","
            cell.categoryNameLBL.text = self.ProductselectedCategory.productName
            
            
            let str = self.ProductselectedCategory.mfgDate
            if str == ""{
              cell.manufactureDateLBL.text = "-"
            }else{
                let dateformtedManufacDate = self.convertDateFormater(date: str!)
                cell.manufactureDateLBL.text = dateformtedManufacDate
            }
            let str1 = self.ProductselectedCategory.expDate

            if str1 == ""{
                cell.manufractureExpireLBL.text = "-"
            }else{
                let dateformtedExperieryDate = self.convertDateFormater(date: str1!)
                cell.manufractureExpireLBL.text = dateformtedExperieryDate
            }
            
            
            cell.qcCertificateLBL.text = self.ProductselectedCategory.qc != nil ? self.ProductselectedCategory.qc : "-"
            cell.batchNumberLBL.text =  self.ProductselectedCategory.batchNo != nil ?  self.ProductselectedCategory.batchNo : "-"
            cell.PlusBtn.tag = indexPath.row
            cell.MinusBtn.tag = indexPath.row
            cell.addtoCartBTN.tag = indexPath.row
            cell.QtyIncreaseView.isHidden = true
            
            cell.addtoCartBTN.addTarget(self, action: #selector(CartBtnClicked(_:)), for:.touchUpInside)
            cell.PlusBtn.addTarget(self, action: #selector(offerPlusBtnClicked(_:)), for:.touchUpInside)
            cell.MinusBtn.addTarget(self, action: #selector(offerminusBtnClicked(_:)), for:.touchUpInside)
            cell.goCartBTN.addTarget(self, action: #selector(CartMoveClicked (_:)), for:.touchUpInside)
            cell.checkOutBTN.addTarget(self, action: #selector(checkOutBTNClicked(_:)), for:.touchUpInside)
            
            return cell
        }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
 
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    // MARK: - didReceiveMemoryWarning
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - CartMoveClicked
    
     @objc func CartMoveClicked(_ sender : UIButton) {
        let storyboard: MyCartViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyCartViewController") as! MyCartViewController
        let nav = UINavigationController(rootViewController: storyboard)
        self.slideMenuController()?.changeMainViewController(nav, close: true)
    }
    
    // MARK: - checkOutBTNClicked
    
    @objc func checkOutBTNClicked(_ sender : UIButton) {
        checkdatabase=dbManager.createDatabase()
        datacheckaddressViewArray = dbManager.loadAddresss() as! [NSDictionary]
        if datacheckaddressViewArray.count == 0{
            let alertWarning = UIAlertView(title:"TreckFresh", message: "No Items in Cart!", delegate:nil, cancelButtonTitle:"OK")
            alertWarning.show()
            return
        }
        let storyboard: DeliveryViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DeliveryViewController") as! DeliveryViewController
        self.navigationController?.pushViewController(storyboard, animated: true)
        
    
    }
    
    // MARK: -  convertDateFormater
    
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

    // MARK: -  CartBtnClicked
    
    @objc func CartBtnClicked(_ sender : UIButton) {
        if offerdetail == "OfferDetail"   {
            //let productIdSelected : String!
            // productIdSelected = self.ProductselectedCategory.productId
            checkdatabase = dbManager.createDatabase()
            datacheckaddressViewArrayOffer = dbManager.loadAddresss() as! [NSDictionary]
            let cell = sender.superview?.superview?.superview as? ProductItemTableViewCell
            
            if datacheckaddressViewArrayOffer.count == 0  {
                let dict = ["_id":OfferProductselectedCategory._id,
                            "productId": self.OfferProductselectedCategory.productId,
                            "quantity":"1",
                            "unitsOfMeasurement": self.OfferProductselectedCategory.unitsOfMeasurement,
                            "productName":self.OfferProductselectedCategory.productName,
                            "unit": self.OfferProductselectedCategory.unit,
                            "productDetails": self.OfferProductselectedCategory.productDetails,
                            "productImage": self.OfferProductselectedCategory.productImage,
                            "brand": self.OfferProductselectedCategory.brand,
                            "selling_price":self.OfferProductselectedCategory.selling_price,
                            "offer":" ",
                            "MRP": self.OfferProductselectedCategory.MRP,
                "QuantityinStock": self.OfferProductselectedCategory.quantity]
                dbManager.insertMovieData(Dict: dict as! [String : String])
                
                let cartcount =  UserDefaults.standard.integer(forKey: "cartcount")
                let incraseCount = cartcount + 1
                UserDefaults.standard.set(incraseCount, forKey: "cartcount")
                appDelegate.label?.text = String(incraseCount)
            }else{
                datacheckaddressViewArrayOffer = dbManager.loadAddresss() as! [NSDictionary]
                foundRecord = false
                for i in 0..<(datacheckaddressViewArrayOffer.count){
                    let dbDict = datacheckaddressViewArrayOffer[i] as! [String : Any]
                    let dbproductid = dbDict["productId"] as! String
                    let offerproductid = self.OfferProductselectedCategory.productId
                    if dbproductid == offerproductid {
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
                            let offerproductid = self.OfferProductselectedCategory.productId
                            if dbproductid == offerproductid {
                                qty = dbDict["quantity"] as! String
                            }
                        }
                        
                    }
                    
                    let dict = ["_id":self.OfferProductselectedCategory._id,
                                "productId": self.OfferProductselectedCategory.productId,
                                "quantity":qty,
                                "unitsOfMeasurement": self.OfferProductselectedCategory.unitsOfMeasurement,
                                "productName":self.OfferProductselectedCategory.productName,
                                "unit": self.OfferProductselectedCategory.unit,
                                "productDetails": self.OfferProductselectedCategory.productDetails,
                                "productImage": self.OfferProductselectedCategory.productImage,
                                "brand": self.OfferProductselectedCategory.brand,
                                "selling_price":self.OfferProductselectedCategory.selling_price,
                                "offer":" ",
                                "MRP": self.OfferProductselectedCategory.MRP ,
                                "QuantityinStock": self.OfferProductselectedCategory.quantity]
                    dbManager.insertMovieData(Dict: dict as! [String : String])
                    let cartcount =  UserDefaults.standard.integer(forKey: "cartcount")
                    let incraseCount = cartcount + 1
                    UserDefaults.standard.set(incraseCount, forKey: "cartcount")
                    DispatchQueue.main.async {
                        self.appDelegate.label?.text = String(incraseCount)
                    }
                    
                }
                
            }
            cell?.QtyIncreaseView.isHidden = false
            //cell?.MinusBtn.isHidden = false
            cell?.addtoCartBTN.isHidden = true
            
            if datacheckaddressViewArrayOffer.count == 0{
                
                cell?.incrementqunatitylbl.text = "1"
            }else{
                datacheckaddressViewArrayOffer = dbManager.loadAddresss() as! [NSDictionary]
                for i in 0..<(datacheckaddressViewArrayOffer.count){
                    let dbDict1 = datacheckaddressViewArrayOffer[i] as! [String : Any]
                    let dbproductid = dbDict1["productId"] as! String
                    let offerproductid = self.OfferProductselectedCategory.productId
                    if dbproductid == offerproductid {
                        if dbDict1["quantity"] as? String == "0"
                        {
                            cell?.incrementqunatitylbl.text = "1"
                        }else{
                            cell?.incrementqunatitylbl.text = dbDict1["quantity"] as? String                    }
                        
                    }
                }
            }
        }else{
        let productIdSelected : String!
       // productIdSelected = self.ProductselectedCategory.productId
        checkdatabase = dbManager.createDatabase()
        datacheckaddressViewArrayOffer = dbManager.loadAddresss() as! [NSDictionary]
        let cell = sender.superview?.superview?.superview as? ProductItemTableViewCell
    
        if datacheckaddressViewArrayOffer.count == 0  {
            let dict = ["_id":ProductselectedCategory._id,
                        "productId": self.ProductselectedCategory.productId,
                        "quantity":"1",
                        "unitsOfMeasurement": self.ProductselectedCategory.unitsOfMeasurement,
                        "productName":self.ProductselectedCategory.productName,
                        "unit": self.ProductselectedCategory.unit,
                        "productDetails": self.ProductselectedCategory.productDetails,
                        "productImage": self.ProductselectedCategory.productImage,
                        "brand": self.ProductselectedCategory.brand,
                        "selling_price":self.ProductselectedCategory.selling_price,
                        "offer":" ",
                        "MRP": self.ProductselectedCategory.MRP,
                        "QuantityinStock": self.ProductselectedCategory.quantity]
            dbManager.insertMovieData(Dict: dict as! [String : String])
            
            let cartcount =  UserDefaults.standard.integer(forKey: "cartcount")
            let incraseCount = cartcount + 1
            UserDefaults.standard.set(incraseCount, forKey: "cartcount")
            appDelegate.label?.text = String(incraseCount)
        }else{
            datacheckaddressViewArrayOffer = dbManager.loadAddresss() as! [NSDictionary]
            foundRecord = false
            for i in 0..<(datacheckaddressViewArrayOffer.count){
                let dbDict = datacheckaddressViewArrayOffer[i] as! [String : Any]
                let dbproductid = dbDict["productId"] as! String
                let offerproductid = self.ProductselectedCategory.productId
                if dbproductid == offerproductid {
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
                        let offerproductid = self.ProductselectedCategory.productId
                        if dbproductid == offerproductid {
                            qty = dbDict["quantity"] as! String
                        }
                    }
                    
                }
                
                let dict = ["_id":self.ProductselectedCategory._id,
                            "productId": self.ProductselectedCategory.productId,
                            "quantity":qty,
                            "unitsOfMeasurement": self.ProductselectedCategory.unitsOfMeasurement,
                            "productName":self.ProductselectedCategory.productName,
                            "unit": self.ProductselectedCategory.unit,
                            "productDetails": self.ProductselectedCategory.productDetails,
                            "productImage": self.ProductselectedCategory.productImage,
                            "brand": self.ProductselectedCategory.brand,
                            "selling_price":self.ProductselectedCategory.selling_price,
                            "offer":" ",
                            "MRP": self.ProductselectedCategory.MRP,
                             "QuantityinStock": self.ProductselectedCategory.quantity]
                dbManager.insertMovieData(Dict: dict as! [String : String])
                let cartcount =  UserDefaults.standard.integer(forKey: "cartcount")
                let incraseCount = cartcount + 1
                UserDefaults.standard.set(incraseCount, forKey: "cartcount")
                DispatchQueue.main.async {
                    self.appDelegate.label?.text = String(incraseCount)
                }
                
            }
            
        }
        cell?.QtyIncreaseView.isHidden = false
        //cell?.MinusBtn.isHidden = false
        cell?.addtoCartBTN.isHidden = true
       
        if datacheckaddressViewArrayOffer.count == 0{
       
            cell?.incrementqunatitylbl.text = "1"
        }else{
            datacheckaddressViewArrayOffer = dbManager.loadAddresss() as! [NSDictionary]
            for i in 0..<(datacheckaddressViewArrayOffer.count){
                let dbDict1 = datacheckaddressViewArrayOffer[i] as! [String : Any]
                let dbproductid = dbDict1["productId"] as! String
                let offerproductid = self.ProductselectedCategory.productId
                if dbproductid == offerproductid {
                    if dbDict1["quantity"] as? String == "0"
                    {
                        cell?.incrementqunatitylbl.text = "1"
                    }else{
                        cell?.incrementqunatitylbl.text = dbDict1["quantity"] as? String                    }
                    
                }
            }
        }
        }
    }
    
    // MARK: -  offerPlusBtnClicked
    
    @objc func offerPlusBtnClicked(_ sender : UIButton) {
        print(sender.tag)
        if offerdetail == "OfferDetail" {
            let cell = sender.superview?.superview?.superview?.superview as? ProductItemTableViewCell
            
            let qty = cell?.incrementqunatitylbl!.text
            if Int(qty!)! < Int(self.OfferProductselectedCategory.quantity)! {
                let addtion = Int(qty!)! + 1
                
                
                checkdatabase=dbManager.createDatabase()
                datacheckaddressViewArrayOffer = dbManager.loadAddresss() as! [NSDictionary]
                
                for i in 0..<(datacheckaddressViewArrayOffer.count){
                    let dbDict = datacheckaddressViewArrayOffer[i] as! [String : Any]
                    let dbproductid = dbDict["productId"] as! String
                    let offerproductid = self.OfferProductselectedCategory.productId
                    if dbproductid == offerproductid {
                        
                        var updateRecordDatabase1 : Bool = false
                        updateRecordDatabase1 = dbManager.updateCart(productID: dbDict["productId"] as! String, quantity:"\(addtion)")
                        // }
                        
                    }
                    
                }
                cell?.incrementqunatitylbl!.text = String(addtion)
            }else{
                self.view.makeToast("Product quantity Available", duration: 1.0, position: CSToastPositionCenter)
                
            }}else{
                let cell = sender.superview?.superview?.superview?.superview as? ProductItemTableViewCell
                
                let qty = cell?.incrementqunatitylbl!.text
                if Int(qty!)! < Int(self.ProductselectedCategory.quantity)! {
                    let addtion = Int(qty!)! + 1
                    
                    
                    checkdatabase=dbManager.createDatabase()
                    datacheckaddressViewArrayOffer = dbManager.loadAddresss() as! [NSDictionary]
                    
                    for i in 0..<(datacheckaddressViewArrayOffer.count){
                        let dbDict = datacheckaddressViewArrayOffer[i] as! [String : Any]
                        let dbproductid = dbDict["productId"] as! String
                        let offerproductid = self.ProductselectedCategory.productId
                        if dbproductid == offerproductid {
                            
                            var updateRecordDatabase1 : Bool = false
                            updateRecordDatabase1 = dbManager.updateCart(productID: dbDict["productId"] as! String, quantity:"\(addtion)")
                            // }
                            
                        }
                        
                    }
                    cell?.incrementqunatitylbl!.text = String(addtion)
                }else{
                    self.view.makeToast("Product quantity Available", duration: 1.0, position: CSToastPositionCenter)
                    
                }

            }
        
        
    }
    
    // MARK: -  offerminusBtnClicked
    
    @objc func offerminusBtnClicked(_ sender : UIButton) {
        print(sender.tag)
        
        if offerdetail == "OfferDetail"
        {
            let cell = sender.superview?.superview?.superview?.superview as? ProductItemTableViewCell
            datacheckaddressViewArrayOffer = dbManager.loadAddresss() as! [NSDictionary]
            // self.ProductselectedCategory.quantity
            //        let dbDict = datacheckaddressViewArrayOffer[sender.tag]
            //var productDetail:productCategoryDetailModel!
            // productDetail = self.ProductByCategorydetailArray[sender.tag]
            let qty = cell?.incrementqunatitylbl!.text
            
            
            let addtion = Int(qty!)! - 1
            if addtion == 0 {
                cell?.incrementqunatitylbl.text = "1"
                cell?.QtyIncreaseView.isHidden = true
                // cell?.MinusBtn.isHidden = true
                cell?.addtoCartBTN.isHidden = false
                var deleteRecordDatabase : Bool = false
                deleteRecordDatabase = dbManager.deleteRecord(withID:self.OfferProductselectedCategory.productId)
                if(deleteRecordDatabase == true){
                    let cartcount =  UserDefaults.standard.integer(forKey: "cartcount")
                    let incraseCount = cartcount - 1
                    UserDefaults.standard.set(incraseCount, forKey: "cartcount")
                    appDelegate.label?.text = String(incraseCount)
                }
            }
            else{
                cell?.incrementqunatitylbl.text = "\(addtion)"
            }
            datacheckaddressViewArrayOffer = dbManager.loadAddresss() as! [NSDictionary]
            for i in 0..<(datacheckaddressViewArrayOffer.count){
                let dbDict = datacheckaddressViewArrayOffer[i] as! [String : Any]
                let dbproductid = dbDict["productId"] as! String
                let offerproductid = self.OfferProductselectedCategory.productId
                if dbproductid == offerproductid {
                    var updateRecordDatabase1 : Bool = false
                    updateRecordDatabase1 = dbManager.updateCart(productID: dbDict["productId"] as! String, quantity:"\(addtion)")
                    //}
                    
                }
                
            }
            cell?.incrementqunatitylbl!.text = String(addtion)
        }else{
        let cell = sender.superview?.superview?.superview?.superview as? ProductItemTableViewCell
        datacheckaddressViewArrayOffer = dbManager.loadAddresss() as! [NSDictionary]
       // self.ProductselectedCategory.quantity
//        let dbDict = datacheckaddressViewArrayOffer[sender.tag]
        //var productDetail:productCategoryDetailModel!
       // productDetail = self.ProductByCategorydetailArray[sender.tag]
        let qty = cell?.incrementqunatitylbl!.text
        
        
        let addtion = Int(qty!)! - 1
        if addtion == 0 {
            cell?.incrementqunatitylbl.text = "1"
            cell?.QtyIncreaseView.isHidden = true
           // cell?.MinusBtn.isHidden = true
            cell?.addtoCartBTN.isHidden = false
            var deleteRecordDatabase : Bool = false
            deleteRecordDatabase = dbManager.deleteRecord(withID:self.ProductselectedCategory.productId)
            if(deleteRecordDatabase == true){
                let cartcount =  UserDefaults.standard.integer(forKey: "cartcount")
                let incraseCount = cartcount - 1
                UserDefaults.standard.set(incraseCount, forKey: "cartcount")
                appDelegate.label?.text = String(incraseCount)
            }
        }
        else{
            cell?.incrementqunatitylbl.text = "\(addtion)"
        }
        datacheckaddressViewArrayOffer = dbManager.loadAddresss() as! [NSDictionary]
        for i in 0..<(datacheckaddressViewArrayOffer.count){
            let dbDict = datacheckaddressViewArrayOffer[i] as! [String : Any]
            let dbproductid = dbDict["productId"] as! String
            let offerproductid = self.ProductselectedCategory.productId
            if dbproductid == offerproductid {
                var updateRecordDatabase1 : Bool = false
                updateRecordDatabase1 = dbManager.updateCart(productID: dbDict["productId"] as! String, quantity:"\(addtion)")
                //}
                
            }
            
        }
        cell?.incrementqunatitylbl!.text = String(addtion)
        }
    }
    
    // MARK: -  setBadge
    
    func setBadge(){
        DispatchQueue.main.async {
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
    
    // MARK: -  rightButtonTouched
    
    @objc func rightButtonTouched() {
        let storyboard: MyCartViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyCartViewController") as! MyCartViewController
        let nav = UINavigationController(rootViewController: storyboard)
        self.slideMenuController()?.changeMainViewController(nav, close: true)
    }
    @objc func handleMyFunction() {
  
        
    }
  

}
