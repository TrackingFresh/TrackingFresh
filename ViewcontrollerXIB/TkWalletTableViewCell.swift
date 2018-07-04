//
//  TkWalletTableViewCell.swift
//  GoogleFacebookLogin
//
//  Created by V kishore kumar reddy  on 2/3/18.
//  Copyright © 2018 Raju sharma. All rights reserved.
//

import UIKit

class TkWalletTableViewCell: UITableViewCell {

    @IBOutlet weak var TkWalletAmount: UILabel!
    @IBOutlet weak var TKWalletDateTime: UILabel!
    @IBOutlet weak var TkWalletType: UILabel!
    @IBOutlet weak var TkWalletImg: UIImageView!
    @IBOutlet weak var tkView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tkView.layer.cornerRadius = 5
        tkView.layer.borderWidth = 0.1
        tkView.layer.masksToBounds = false
        tkView.layer.shadowOffset = CGSize(width: 1, height: 1)
        tkView.layer.shadowRadius = 2
        tkView.layer.shadowOpacity = 0.5
        tkView.layer.shadowColor = UIColor.black.cgColor
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
