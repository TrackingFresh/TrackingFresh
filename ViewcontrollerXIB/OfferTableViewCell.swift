//
//  OfferTableViewCell.swift
//  GoogleFacebookLogin
//
//  Created by V kishore kumar reddy  on 1/20/18.
//  Copyright © 2018 Raju sharma. All rights reserved.
//

import UIKit

class OfferTableViewCell: UITableViewCell {

    @IBOutlet weak var multiplyLbl: UILabel!
    @IBOutlet weak var offerCartBtn: UIButton!
    @IBOutlet weak var offerPlusBtn: UIButton!
    @IBOutlet weak var offerMinusBtn: UIButton!
    @IBOutlet weak var offerQtyIncrease: UILabel!
    @IBOutlet weak var OfferProuctRate: UILabel!
    @IBOutlet weak var offerPrice: UILabel!
    @IBOutlet weak var offerProductQuantity: UILabel!
    @IBOutlet weak var offerproductName: UILabel!
    @IBOutlet weak var offerImage: UIImageView!
    @IBOutlet weak var offerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        
        offerView.layer.cornerRadius = 5
        offerPlusBtn.layer.cornerRadius = 5
        offerPlusBtn.clipsToBounds = true
        offerMinusBtn.layer.cornerRadius = 5
        offerMinusBtn.clipsToBounds = true
        offerCartBtn.layer.cornerRadius = 5
        offerCartBtn.clipsToBounds = true
        
        offerView.layer.borderWidth = 0.1
        offerView.layer.masksToBounds = false
        offerView.layer.shadowOffset = CGSize(width: 1, height: 1)
        offerView.layer.shadowRadius = 2
        offerView.layer.shadowOpacity = 0.5
        offerView.layer.shadowColor = UIColor.black.cgColor
        offerPlusBtn.isHidden = true
         offerMinusBtn.isHidden = true
        offerCartBtn.isHidden = false
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
