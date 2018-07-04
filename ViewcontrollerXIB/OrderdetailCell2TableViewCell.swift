//
//  OrderdetailCell2TableViewCell.swift
//  GoogleFacebookLogin
//
//  Created by V kishore kumar reddy  on 1/31/18.
//  Copyright © 2018 Raju sharma. All rights reserved.
//

import UIKit

class OrderdetailCell2TableViewCell: UITableViewCell {

    @IBOutlet weak var starViewConstraintHeight: NSLayoutConstraint!
   
    @IBOutlet weak var submitBTN: UIButton!
    @IBOutlet weak var feedbackTXT: UITextField!
    @IBOutlet weak var starRatingView: CosmosView!
    @IBOutlet weak var callBTN: UIButton!
    @IBOutlet weak var supportBTN: UIButton!
    @IBOutlet weak var deliveryOrderUserNameLBL: UILabel!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var deliveryAddressLBL: UILabel!
    @IBOutlet weak var deliveryNameLBL: UILabel!
    @IBOutlet weak var paymentModeLBL: UILabel!
    @IBOutlet weak var paymentStatusLBL: UILabel!
    @IBOutlet weak var grandTotalLBL: UILabel!
    @IBOutlet weak var deliveryChargeLBL: UILabel!
    @IBOutlet weak var orderTypeLBL: UILabel!
    @IBOutlet weak var orderDeliverLBL: UILabel!
    @IBOutlet weak var orderPlaceNumberLBL: UILabel!
    @IBOutlet weak var orderLBL: UILabel!
    @IBOutlet weak var AddressView: UIView!
    @IBOutlet weak var couponLbl: UILabel!
    @IBOutlet weak var couponAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
