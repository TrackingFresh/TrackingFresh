//
//  InviteFriendViewController.swift
//  GoogleFacebookLogin
//
//  Created by V kishore kumar reddy  on 1/19/18.
//  Copyright © 2018 Raju sharma. All rights reserved.
//

import UIKit

class InviteFriendViewController: UIViewController
{
    // MARK: - IBOutlets & Objects
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - didReceiveMemoryWarning
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.appDelegate.hideHud()
        
        //self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
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
