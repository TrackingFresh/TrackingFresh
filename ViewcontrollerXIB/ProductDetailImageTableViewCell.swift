//
//  ProductDetailImageTableViewCell.swift
//  GoogleFacebookLogin
//
//  Created by V kishore kumar reddy  on 1/25/18.
//  Copyright © 2018 Raju sharma. All rights reserved.
//

import UIKit

class ProductDetailImageTableViewCell: UITableViewCell {
 @IBOutlet weak var imageScroller: ImageScroller!
    @IBOutlet weak var detailImageVIew: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
