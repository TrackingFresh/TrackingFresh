

import Foundation

class PrayersTable
{
    var prayer: String = ""
    var title: String = ""
    var date : String = ""
    var strID : String = ""
    var subtext : String = ""
    var day_of_year : String = ""
    var time : String = ""
    var is_favourite : String = ""
    var prayer_id : String = ""
    
    init(userDict: NSDictionary)
    {
        self.prayer = userDict.value(forKey: "prayer") as? String ?? ""
        self.title = userDict.value(forKey: "title") as? String ?? ""
        self.date = userDict.value(forKey: "date") as? String ?? ""
        self.strID = userDict.value(forKey: "id") as? String ?? ""
        self.subtext = userDict.value(forKey: "subtext") as? String ?? ""
        self.day_of_year = userDict.value(forKey: "day_of_year") as? String ?? ""
        self.time = userDict.value(forKey: "time") as? String ?? ""
        self.is_favourite = userDict.value(forKey: "is_favourite") as? String ?? ""
        let prayerId = "\(userDict.value(forKey:"prayer_id") ?? 0)"
        self.prayer_id = prayerId

    }
}


//for dict in PrayersArray!  {
//    let prayerGuideModel = PrayersTable.init(userDict: dict as NSDictionary)
//    ModelData.arrPrayersTable.append(prayerGuideModel)
//}

