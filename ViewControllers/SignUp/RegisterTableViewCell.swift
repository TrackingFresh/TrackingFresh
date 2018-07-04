//
//  RegisterTableViewCell.swift
//  GoogleFacebookLogin
//
//  Created by V kishore kumar reddy  on 1/22/18.
//  Copyright © 2018 Raju sharma. All rights reserved.
//

import UIKit

class RegisterTableViewCell: UITableViewCell {
    @IBOutlet weak var RefferalCodeTxt: UITextField!
    @IBOutlet weak var LastNameTxt: UITextField!
    
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var LocationTxt: UITextField!
    @IBOutlet weak var EmailIdTxt: UITextField!
    @IBOutlet weak var MobileNoTxt: UITextField!
    @IBOutlet weak var FirstNameTxt: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
