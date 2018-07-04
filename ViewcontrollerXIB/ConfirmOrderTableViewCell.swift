//
//  ConfirmOrderTableViewCell.swift
//  GoogleFacebookLogin
//
//  Created by V kishore kumar reddy  on 2/23/18.
//  Copyright © 2018 Raju sharma. All rights reserved.
//

import UIKit

class ConfirmOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var ProductTotalPrize: UILabel!
    @IBOutlet weak var ProductPrize: UILabel!
    @IBOutlet weak var ProductQty: UILabel!
    @IBOutlet weak var ProductName: UILabel!
    @IBOutlet weak var ProductImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
