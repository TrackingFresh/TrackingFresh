//
//  TkWalletPaidAmountViewController.swift
//  GoogleFacebookLogin
//
//  Created by V kishore kumar reddy  on 2/3/18.
//  Copyright © 2018 Raju sharma. All rights reserved.
//

import UIKit

class TkWalletPaidAmountViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{

    // MARK: - IBOutlets & Objects
    
    @IBOutlet weak var TkPaidAmountTableView: UITableView!
  
    // MARK: - viewDidLoad
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        TkPaidAmountTableView.delegate = self
        TkPaidAmountTableView.dataSource = self
        TkPaidAmountTableView.register(UINib(nibName: "TkWalletTableViewCell", bundle: nil), forCellReuseIdentifier: "TkWalletTableViewCell")

        // Do any additional setup after loading the view.
    }
    
    // MARK: - didReceiveMemoryWarning

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableView Delegates & Data Source
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell :TkWalletTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TkWalletTableViewCell") as! TkWalletTableViewCell!
        
        return cell
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
