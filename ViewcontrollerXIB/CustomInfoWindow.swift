//
//  CustomInfoWindow.swift
//  CustomInfoWindow
//
//  Created by Malek T. on 12/13/15.
//  Copyright © 2015 Medigarage Studios LTD. All rights reserved.
//

import UIKit

class CustomInfoWindow: UIView {

    @IBOutlet weak var CustomAddressLbl: UILabel!
    @IBOutlet weak var CustomMarkerView: UIView!
    
    @IBOutlet weak var CustomMarkerEndTime: UILabel!
    
    @IBOutlet weak var CustomarkerStarttime: UILabel!
    
   
    
 
    override func draw(_ rect: CGRect) {
        CustomMarkerView.layer.borderWidth = 1
        CustomMarkerView.layer.borderColor = UIColor.lightGray.cgColor
        CustomMarkerView.layer.masksToBounds = false
        CustomMarkerView.layer.cornerRadius = 8.0
        
    }
    

}
