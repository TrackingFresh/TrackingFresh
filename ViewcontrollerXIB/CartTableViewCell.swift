//
//  CartTableViewCell.swift
//  GoogleFacebookLogin
//
//  Created by V kishore kumar reddy  on 1/19/18.
//  Copyright © 2018 Raju sharma. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var cartPlusBtn: UIButton!
    @IBOutlet weak var cartMinusBtn: UIButton!
    @IBOutlet weak var cartTotalAmt: UILabel!
    @IBOutlet weak var cartProductQtyIncrease: UILabel!
    @IBOutlet weak var cartProductRate: UILabel!
    @IBOutlet weak var CartProductQuantity: UILabel!
    @IBOutlet weak var cartProductName: UILabel!
    @IBOutlet weak var cartImage: UIImageView!
    @IBOutlet weak var cartView: UIView!
    
    @IBOutlet weak var DeleteBtn: UIButton!
    @IBOutlet weak var multiplyLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
// Initialization code
        cartView.layer.cornerRadius = 5
        cartPlusBtn.layer.cornerRadius = 5
        cartPlusBtn.clipsToBounds = true
        cartMinusBtn.layer.cornerRadius = 5
        cartMinusBtn.clipsToBounds = true
        cartView.layer.borderWidth = 0.1
        cartView.layer.masksToBounds = false
        cartView.layer.shadowOffset = CGSize(width: 1, height: 1)
        cartView.layer.shadowRadius = 2
        cartView.layer.shadowOpacity = 0.5
        cartView.layer.shadowColor = UIColor.black.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
