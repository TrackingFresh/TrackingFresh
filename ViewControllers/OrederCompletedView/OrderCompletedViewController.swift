//
//  OrderCompletedViewController.swift
//  GoogleFacebookLogin
//
//  Created by V kishore kumar reddy  on 3/8/18.
//  Copyright © 2018 Raju sharma. All rights reserved.
//

import UIKit

class OrderCompletedViewController: UIViewController
{
    //MARK: -  IBOutlets & Objects
    
    var  CompltedorderDict: NSDictionary = [:]
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var trackordernolbl: UILabel!
 
    //MARK: -  viewDidLoad
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
         self.customNavigationItem(stringText: "ORDER PLACED", showbackButon: false)
    print(CompltedorderDict)
        let orderno = CompltedorderDict["orderNo"] as! String
        trackordernolbl.text =  "Order No :" + orderno
        // Do any additional setup after loading the view.
    }
    
    //MARK: -  didReceiveMemoryWarning
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: -  viewWillAppear
    
    override func  viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.appDelegate.hideHud()

    }
    
    //MARK: -  customNavigationItem
    
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
    
    //MARK: -  backAction
    
    @objc func backAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: -  TrackOrderBtn_Clicked
    
    @IBAction func TrackOrderBtn_Clicked(_ sender: Any) {
        let trackOrdervViewController: TrackOrdervViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TrackOrdervViewController") as! TrackOrdervViewController
        trackOrdervViewController.trackOrderDictComplted = self.CompltedorderDict
        self.navigationController?.pushViewController(trackOrdervViewController, animated: true)
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
