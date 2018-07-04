

import UIKit

class CustomtextField: UITextField {

    override public func draw(_ rect: CGRect) {
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 6.0
        self.layer.borderColor = CommonMethod.hexStringToUIColor(hex:"FFFFFF").cgColor
        self.textColor = CommonMethod.hexStringToUIColor(hex:"FFFFFF")
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedStringKey.foregroundColor : CommonMethod.hexStringToUIColor(hex:"FFFFFF")])
        self.leftView = leftView
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width, height: bounds.height)
    }

}
