//
//  ProductItemTableViewCell.swift
//  GoogleFacebookLogin
//
//  Created by V kishore kumar reddy  on 1/25/18.
//  Copyright © 2018 Raju sharma. All rights reserved.
//

import UIKit

class ProductItemTableViewCell: UITableViewCell {
@IBOutlet weak var offerimage: UIImageView!
    @IBOutlet weak var checkOutBTN: UIButton!
    @IBOutlet weak var goCartBTN: UIButton!
    @IBOutlet weak var disclaimerLBL: UILabel!
    @IBOutlet weak var manufractureExpireLBL: UILabel!
    @IBOutlet weak var manufactureDateLBL: UILabel!
    @IBOutlet weak var detailLBL: UILabel!
    @IBOutlet weak var descriptionLBL: UILabel!
    @IBOutlet weak var addtoCartBTN: UIButton!
    @IBOutlet weak var addFavoriteBTN: UIButton!
    @IBOutlet weak var priceQuntityMrp2LBL: UILabel!
    @IBOutlet weak var priceQuantityMrpLBL: UILabel!
    @IBOutlet weak var priceQuntityLBL: UILabel!
    
    @IBOutlet weak var categoryNameLBL: UILabel!
    
    @IBOutlet weak var qcCertificateLBL: UILabel!
    
    @IBOutlet weak var batchNumberLBL: UILabel!
  @IBOutlet weak var PlusBtn: UIButton!
      @IBOutlet weak var MinusBtn: UIButton!
 @IBOutlet weak var incrementqunatitylbl: UILabel!
     @IBOutlet weak var QtyIncreaseView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
