//
//  ReferEarnViewController.swift
//  GoogleFacebookLogin
//
//  Created by V kishore kumar reddy  on 1/16/18.
//  Copyright © 2018 Raju sharma. All rights reserved.
//

import UIKit

class ReferEarnViewController: UIViewController ,SlideMenuControllerDelegate
{

    // MARK: - IBOutlets & Objects
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var refferalcodelbl: UILabel!
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.title = "Invite Friends"
         self.customNavigationItem(stringText: "INVITE FRIENDS", showbackButon: false)
        // Do any additional setup after loading the view.
    }
    
    // MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.appDelegate.hideHud()
        self.setNavigationBarItem()
        refferalcodelbl.text = UserDefaults.standard.value(forKey: "Refferalcode") as? String
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
      
        setBadge()
    }
    
    // MARK: - ShareBtn_Clicked
    
    @IBAction func ShareBtn_Clicked(_ sender: Any) {
        activityControllerPOP()
    }
    
    // MARK: - activityControllerPOP
    
    func activityControllerPOP() {
        
        let appendStrTxt = "Tracking Fresh Invite  ,\n"+"Refferal Code -" + refferalcodelbl.text!
        
        let activityViewController = UIActivityViewController(activityItems: [appendStrTxt], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true) {
            
        }
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
    
    // MARK: - setBadge
    
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
    
    // MARK: - rightButtonTouched
    
    @objc func rightButtonTouched() {
        let storyboard: MyCartViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyCartViewController") as! MyCartViewController
        let nav = UINavigationController(rootViewController: storyboard)
        self.slideMenuController()?.changeMainViewController(nav, close: true)
        
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
