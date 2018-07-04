//
//  OrderDetailCell1TableViewCell.swift
//  GoogleFacebookLogin
//
//  Created by V kishore kumar reddy  on 1/31/18.
//  Copyright © 2018 Raju sharma. All rights reserved.
//

import UIKit

class OrderDetailCell1TableViewCell: UITableViewCell {

    @IBOutlet weak var productPriceLBL: UILabel!
    @IBOutlet weak var productQuantityLBL: UILabel!
    @IBOutlet weak var productNameLBL: UILabel!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var viewBorder: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
