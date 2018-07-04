//
//  AddressTableViewCell.swift
//  GoogleFacebookLogin
//
//  Created by V kishore kumar reddy  on 1/20/18.
//  Copyright © 2018 Raju sharma. All rights reserved.
//

import UIKit

class AddressTableViewCell: UITableViewCell {
    @IBOutlet var setDefaultAddressBtn: UIButton!
    @IBOutlet var editAddressBtn: UIButton!
    @IBOutlet var deleteBtn: UIButton!
    @IBOutlet var fullAddress: UILabel!
    @IBOutlet var fullName: UILabel!
    @IBOutlet var mobileNo: UILabel!
    @IBOutlet var addresstype: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
