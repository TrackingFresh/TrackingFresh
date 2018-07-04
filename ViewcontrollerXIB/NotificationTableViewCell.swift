//
//  NotificationTableViewCell.swift
//  GoogleFacebookLogin
//
//  Created by V kishore kumar reddy  on 1/19/18.
//  Copyright © 2018 Raju sharma. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var notificationLBL: UILabel!
    @IBOutlet weak var notificationDateLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        notificationView.layer.cornerRadius = 5
        notificationView.layer.borderWidth = 0.1
        notificationView.layer.masksToBounds = false
        notificationView.layer.shadowOffset = CGSize(width: 1, height: 1)
        notificationView.layer.shadowRadius = 2
        notificationView.layer.shadowOpacity = 0.5
        notificationView.layer.shadowColor = UIColor.black.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
