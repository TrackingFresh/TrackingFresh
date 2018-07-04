//
//  LoginViewController.swift
//  GoogleFacebookLogin
//
//  Created by V kishore kumar reddy  on 1/17/18.
//  Copyright © 2018 Raju sharma. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController
{

    // MARK: - IBOutlets & Objects
    
    @IBOutlet weak var TrackTopHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var SignUpHeightContstraints: NSLayoutConstraint!
    @IBOutlet weak var LabelDescHeightConstraints: NSLayoutConstraint!
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
    }

    // MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.appDelegate.hideHud()
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        //self.setUpContraint()
    }
    
    // MARK: - setUpContraint
    
    func setUpContraint(){
        if DeviceSizeConstants.IS_IPHONE5 {
            SignUpHeightContstraints.constant = 100
            TrackTopHeightConstraints.constant = 62
            LabelDescHeightConstraints.constant = 45
        }else if DeviceSizeConstants.IS_IPHONE6{
            SignUpHeightContstraints.constant = 140
            TrackTopHeightConstraints.constant = 130
            LabelDescHeightConstraints.constant = 65
            
        }else if DeviceSizeConstants.IS_IPHONE6PLUS {
            SignUpHeightContstraints.constant = 140
            TrackTopHeightConstraints.constant = 130
            LabelDescHeightConstraints.constant = 65
            
        }else if DeviceSizeConstants.IS_IPHONE7{
            SignUpHeightContstraints.constant = 140
            TrackTopHeightConstraints.constant = 130
            LabelDescHeightConstraints.constant = 65
            
        }else if DeviceSizeConstants.IS_IPHONEX{
            SignUpHeightContstraints.constant = 140
            TrackTopHeightConstraints.constant = 130
            LabelDescHeightConstraints.constant = 65
            
        }
        
    }
    
    // MARK: - didReceiveMemoryWarning
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - SignUpBtn_Clicked
 
    @IBAction func SignUpBtn_Clicked(_ sender: Any) {
        
        let storyboard: RegisterViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
       
        self.navigationController?.pushViewController(storyboard, animated: true)
    }
    
    // MARK: - SignInBtn_Clicked
    
    @IBAction func SignInBtn_Clicked(_ sender: Any) {
        
        let storyboard: SignInViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
       // var producData:ProductModel
//        producData = self.productModelArray[indexPath.row]
//        storyboard.productdetailCategoryID=producData.idProduct
//        storyboard.ratingStar = producData.rating
        self.navigationController?.pushViewController(storyboard, animated: true)
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
