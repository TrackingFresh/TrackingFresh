//
//  HomeCollectionViewCell.swift
//  GoogleFacebookLogin
//
//  Created by V kishore kumar reddy  on 1/25/18.
//  Copyright © 2018 Raju sharma. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var homeViewCell: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productName: UILabel!
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        homeViewCell.layer.cornerRadius = 5
        homeViewCell.layer.borderWidth = 0.1
        homeViewCell.layer.masksToBounds = false
        homeViewCell.layer.shadowOffset = CGSize(width: 1, height: 1)
        homeViewCell.layer.shadowRadius = 2
        homeViewCell.layer.shadowOpacity = 0.5
        homeViewCell.layer.shadowColor = UIColor.black.cgColor
    }
    
}
