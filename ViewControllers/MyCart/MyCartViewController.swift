 //
//  MyCartViewController.swift
//  GoogleFacebookLogin
//
//  Created by V kishore kumar reddy  on 1/16/18.
//  Copyright © 2018 Raju sharma. All rights reserved.
//

import UIKit


class MyCartViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,SlideMenuControllerDelegate
{

    // MARK: - IBOutlets & Objects

    @IBOutlet weak var MyCartTableView: UITableView!
    var datacheckaddressViewArray = [NSDictionary]()
    let dbManager = DBManager()
    var checkdatabase : Bool!
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var datacheckaddressViewArrayOffer = [NSDictionary]()
    
    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
       // self.title = "My Cart"
        self.customNavigationItem(stringText: "MY CART", showbackButon: false)
    
        MyCartTableView.delegate = self
        MyCartTableView.dataSource = self
        MyCartTableView.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "CartTableViewCell")
        
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
        self.appDelegate.hideHud()
        self.setNavigationBarItem()
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        datacheckaddressViewArray.removeAll()
        checkdatabase=dbManager.createDatabase()
        datacheckaddressViewArray = dbManager.loadAddresss() as! [NSDictionary]
        print(datacheckaddressViewArray.count)
        
        if datacheckaddressViewArray.count == 0 {
            let alertWarning = UIAlertView(title:"TreckFresh", message: "No Items in Cart!", delegate:nil, cancelButtonTitle:"OK")
            alertWarning.show()
            
        }
        self.MyCartTableView.reloadData()
        setBadge()

     
    }
    
    // MARK: - didReceiveMemoryWarning
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableView Delegates & Data Source
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 131
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datacheckaddressViewArray.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell :CartTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell") as! CartTableViewCell!
        let dict = datacheckaddressViewArray[indexPath.row] as! [String : Any]
        let sellingPrise = dict["selling_price"] as! String
        cell.cartProductQtyIncrease.text = dict["quantity"] as? String
        cell.cartProductRate.text = DeviceSizeConstants.rupee + String(sellingPrise)
        cell.cartProductQtyIncrease.text = dict["quantity"] as? String
        let sellingRate  = dict["selling_price"] as? String
        let qty1 = dict["quantity"] as? String
        let MultiplySellingPrise =  Int(sellingRate!)! * Int(qty1!)!
        cell.cartTotalAmt!.text = DeviceSizeConstants.rupee + String(MultiplySellingPrise)
        cell.cartProductName.text = dict["productName"] as? String
        cell.cartMinusBtn.isHidden = false
        cell.cartPlusBtn.isHidden = false
        cell.cartPlusBtn.tag = indexPath.row
        cell.cartMinusBtn.tag = indexPath.row
        cell.DeleteBtn.tag = indexPath.row
        cell.cartMinusBtn.addTarget(self, action: #selector(cartMinusBtn(_:)), for:.touchUpInside)
        cell.cartPlusBtn.addTarget(self, action: #selector(cartPlusBtn(_:)), for:.touchUpInside)
         cell.DeleteBtn.addTarget(self, action: #selector(cartDeleteBtn(_:)), for:.touchUpInside)
        
        cell.cartImage.sd_setImage(with: URL(string:(dict["productImage"] as? String)!), placeholderImage: UIImage(named: " "))
        return cell
    }
    
     // MARK: - cartDeleteBtn
    
     @objc func cartDeleteBtn(_ sender : UIButton) {
     let dict = datacheckaddressViewArray[sender.tag] as! [String : Any]
     let offerproductid = dict["productId"] as! String
     var deleteRecordDatabase : Bool = false
   deleteRecordDatabase = dbManager.deleteRecord(withID:offerproductid)
    if(deleteRecordDatabase == true){
    datacheckaddressViewArray.removeAll()
    datacheckaddressViewArray = dbManager.loadAddresss() as! [NSDictionary]
    self.MyCartTableView.reloadData()
        let cartcount =  UserDefaults.standard.integer(forKey: "cartcount")
        let incraseCount = cartcount - 1
        UserDefaults.standard.set(incraseCount, forKey: "cartcount")
        appDelegate.label?.text = String(incraseCount)
        
    }
   
    }
    
    // MARK: - cartMinusBtn
   
    @objc func cartMinusBtn(_ sender : UIButton) {
        let addtion :Int!
        let cell = sender.superview?.superview?.superview as? CartTableViewCell
        let dict = datacheckaddressViewArray[sender.tag] as! [String : Any]
        let sellingRate  = dict["selling_price"] as? String
        let qty = cell?.cartProductQtyIncrease!.text
        addtion = Int(qty!)! - 1
        if addtion == 0  {
            let ProductId = dict["productId"] as! String
            
           // let offerproductid1 = dict["productId"] as! String
            var deleteRecordDatabase : Bool = false
            deleteRecordDatabase = dbManager.deleteRecord(withID:ProductId)
            if(deleteRecordDatabase == true){
                datacheckaddressViewArray.removeAll()
                datacheckaddressViewArray = dbManager.loadAddresss() as! [NSDictionary]
                self.MyCartTableView.reloadData()
                let cartcount =  UserDefaults.standard.integer(forKey: "cartcount")
                let incraseCount = cartcount - 1
                UserDefaults.standard.set(incraseCount, forKey: "cartcount")
                appDelegate.label?.text =  DeviceSizeConstants.rupee + String(incraseCount)
            }
        }
        checkdatabase=dbManager.createDatabase()
        datacheckaddressViewArrayOffer = dbManager.loadAddresss() as! [NSDictionary]
        for i in 0..<(datacheckaddressViewArrayOffer.count){
            let dbDict = datacheckaddressViewArrayOffer[i] as! [String : Any]
            let dbproductid = dbDict["productId"] as! String
            let offerproductid = dict["productId"] as! String
            if dbproductid == offerproductid {
                var updateRecordDatabase : Bool = false
                updateRecordDatabase = dbManager.updateCart(productID: dict["productId"] as! String, quantity:"\(addtion!)")
//                }
                
            }
            
        }
            cell?.cartProductQtyIncrease!.text = String(addtion)
        let MultiplySellingPrise =  Int(sellingRate!)! * addtion!
        cell?.cartTotalAmt!.text = DeviceSizeConstants.rupee + String(MultiplySellingPrise)
    }
    
    // MARK: - cartPlusBtn
    
    @objc func cartPlusBtn(_ sender : UIButton) {
        let addtion :Int!
        let cell = sender.superview?.superview?.superview as? CartTableViewCell
        let dict = datacheckaddressViewArray[sender.tag] as! [String : Any]
         let sellingRate  = dict["selling_price"] as? String
        let qty = cell?.cartProductQtyIncrease!.text
        let qtystock = dict["QuantityinStock"] as! String
        
        if Int(qty!)! < Int(qtystock)!{
            
          addtion = Int(qty!)! + 1
        checkdatabase=dbManager.createDatabase()
        datacheckaddressViewArrayOffer = dbManager.loadAddresss() as! [NSDictionary]
        for i in 0..<(datacheckaddressViewArrayOffer.count){
            let dbDict = datacheckaddressViewArrayOffer[i] as! [String : Any]
            let dbproductid = dbDict["productId"] as! String
            let offerproductid = dict["productId"] as! String
            if dbproductid == offerproductid {
                var updateRecordDatabase1 : Bool = false
                    updateRecordDatabase1 = dbManager.updateCart(productID: dict["productId"] as! String, quantity:"\(addtion!)")
//                }
                
            }
            
        }
        cell?.cartProductQtyIncrease!.text = String(addtion)
        let MultiplySellingPrise =  Int(sellingRate!)! * addtion!
        cell?.cartTotalAmt!.text = DeviceSizeConstants.rupee + String(MultiplySellingPrise)
        }
        else{
            self.view.makeToast("Product quantity Available", duration: 1.0, position: CSToastPositionCenter)

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
            
            DispatchQueue.main.async {
                self.appDelegate.label?.text = String(self.datacheckaddressViewArray.count)
                UserDefaults.standard.set(self.datacheckaddressViewArray.count, forKey: "cartcount")
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
    
    // MARK: - CheckOUTBtn_Clicked
    
    @IBAction func CheckOUTBtn_Clicked(_ sender: Any) {
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
    

}
