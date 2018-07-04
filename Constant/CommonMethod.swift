

import UIKit
import SystemConfiguration
var  appDelegate = UIApplication.shared.delegate as! AppDelegate


class CommonMethod: NSObject {

    class  func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    class  func attributedString (stringText:String , checkBool: Bool) -> NSMutableAttributedString {
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string:stringText)
        if checkBool == false {
            myMutableString.setAttributes([NSAttributedStringKey.font : UIFont(name: "ProximaNova-Semibold", size: CGFloat(14.0))!
                , NSAttributedStringKey.foregroundColor : hexStringToUIColor(hex: "868686") ], range: NSRange(location:0,length:2))
        }
        else{
            myMutableString.setAttributes([NSAttributedStringKey.font : UIFont(name: "ProximaNova-Semibold", size: CGFloat(15.0))!
                , NSAttributedStringKey.foregroundColor : hexStringToUIColor(hex: "4B76AC") ], range: NSRange(location:15,length:10))
        }
        
        return myMutableString
    }
    
    
    
    class  func customNavigationItem (stringText:String)-> UIView  {
        
        let conainView : UIView = UIView.init(frame: CGRect(x: 100, y: 0, width: 180, height: 40))
        let label : UILabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
        label.text = stringText
        label.backgroundColor = UIColor.red
        label.textAlignment = NSTextAlignment.center
        conainView.addSubview(label)
        let imageview :UIImageView = UIImageView.init(frame: CGRect(x: 5, y: 10, width: 20, height: 20))
        imageview.image = UIImage(named: "back")
        imageview.contentMode = UIViewContentMode.scaleAspectFill
        conainView.addSubview(imageview)
        conainView.backgroundColor = UIColor.yellow
        return conainView
    }
    
    class  func validationResponse(stringdata:Any) -> String! {
        
        if  (stringdata as AnyObject).isKind(of: NSNull.self) {
            return ""
        }
        if (stringdata as AnyObject).isEqual(" ")
        {
            return ""
        }
        else if (stringdata as AnyObject).isEqual(nil){
            return ""
        }
        else {
            return stringdata as? String
        }
    }
    
    class func printTimestamp()->String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        let updatedString = formatter.string(from: date)
        return updatedString
    }
    
    
    class func printTimestampOfferChrismas()->String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd"
        let updatedString = formatter.string(from: date)
        return updatedString
    }
    
    
    class func mixpanelDateFormat()->String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation:"UTC")
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss a"
        let updatedString = formatter.string(from: date)
        return updatedString
    }
    
    class func getDiffBetweenTwoDates(strdate1:String,strdate2:String)->String{
        
        let userCalendar = Calendar.current
        let requestedComponent: Set<Calendar.Component> = [.month,.day,.hour,.minute,.second,.nanosecond]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        let dateObj1 = dateFormatter.date(from: strdate1)
        let dateObj2 = dateFormatter.date(from: strdate2)
        let timeDifference = userCalendar.dateComponents(requestedComponent, from: dateObj1!, to: dateObj2!)
        let diff = "\(timeDifference.day ?? 0)"
        return diff
    }
    
    
    
    
    
    
    class func getTimeSlot()-> String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        let result = Int(formatter.string(from: date))
        if ( result! >= 0 && result! < 12 ) {
            return "1"
        }
        else if ( result! >= 12 && result! < 19 ) {
            return "2"
        }
        else if ( result! >= 19 && result! <= 23 ) {
            return "3"
        }else{
            return "1"
        }
        
    }
    
    class func getYearSlot()-> String{
        if UserDefaults.standard.string(forKey: "InstallDate") == nil {
            UserDefaults.standard.set(CommonMethod.printTimestamp(), forKey: "InstallDate")
        }
        let installDate : String = UserDefaults.standard.string(forKey: "InstallDate")!
        let currentDate : String = self.printTimestamp()
        let diffDate : String = self.getDiffBetweenTwoDates(strdate1: installDate, strdate2: currentDate)
        let diff = Int(diffDate)! + 1
        return "\(diff)"
    }
    
    class func getFeaturedYearSlot()-> String{
        if UserDefaults.standard.string(forKey: "lastOpenDate") == nil {
            UserDefaults.standard.set(CommonMethod.printTimestamp(), forKey: "lastOpenDate")
        }

        let installDate : String = UserDefaults.standard.string(forKey: "lastOpenDate")!
        let currentDate : String = self.printTimestamp()
        let diffDate : String = self.getDiffBetweenTwoDates(strdate1: installDate, strdate2: currentDate)
        let diff = Int(diffDate)! + 1
        return "\(diff)"
    }
    
    class func getoffsetSlot()-> String{
        if UserDefaults.standard.string(forKey: "InstallDate") == nil {
            UserDefaults.standard.set(CommonMethod.printTimestamp(), forKey: "InstallDate")
        }

        let installDate : String = UserDefaults.standard.string(forKey: "InstallDate")!
        let currentDate : String = self.printTimestamp()
        let diffDate : String = self.getDiffBetweenTwoDates(strdate1: installDate, strdate2: currentDate)
        let diff = Int(diffDate)!
        return "\(diff)"
        
    }
    
    class func getHourmethod()-> String{
        
        let date = NSDate()
        let calendar = NSCalendar.current
        print(calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date as Date))
        let unitFlags = Set<Calendar.Component>([.hour, .year, .minute])
        _ = calendar.dateComponents(unitFlags, from: date as Date)
        _ = calendar.component(.hour, from: date as Date)
        let minutes = calendar.component(.minute, from: date as Date)
        _ = calendar.component(.second, from: date as Date)
        return "\(minutes)"
    }
    
   class func validateEmail(testStr:String) -> Bool {
        print("\(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
   class func myMobileNumberValidate(number:String) -> Bool
   {
        let numberRegEx="[0-9]{10}"
        let phoneTest = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        return phoneTest.evaluate(with: number)
    }
    
   class func passwordValidate(number:String) -> Bool
   {
        let numberRegEx="[0-9]{6}"
        let phoneTest = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        return phoneTest.evaluate(with: number)
    }
    
}
