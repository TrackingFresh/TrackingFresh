//
//  lastOrderTableViewCell.swift
//  GoogleFacebookLogin
//
//  Created by V kishore kumar reddy  on 1/19/18.
//  Copyright © 2018 Raju sharma. All rights reserved.
//

import UIKit

class lastOrderTableViewCell: UITableViewCell {

 
    @IBOutlet weak var RepeatOrderBtn: UIButton!
    @IBOutlet weak var OrderStatus: UIButton!
    @IBOutlet weak var OrderNo: UILabel!
    @IBOutlet weak var CancelReasonValue: UILabel!
    @IBOutlet weak var CancelReasonLbl: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var bigRepeatOrderBtn: UIButton!

    @IBOutlet weak var OrderCreateAt: UILabel!
    @IBOutlet weak var TotalPrice: UILabel!
    @IBOutlet weak var RepeatCancelView: UIView!
    @IBOutlet weak var LastOrderView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        LastOrderView.layer.cornerRadius = 5

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
