//
//  CommonFunctions.swift
//  GrocList
//
//  Created by Jatesh Kumar on 31/03/2021.
//

import Foundation

class CommonFunctions {
    static let shared = CommonFunctions()
    
    /****FORMAT DATE & TIME**/
    func setTimeDateFormat (data: String) -> [String: String] {
        let getFormatter = DateFormatter()
        getFormatter.calendar = Calendar(identifier: .iso8601)
        getFormatter.locale = Locale(identifier: "es")
        getFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss zzzzz"
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        timeFormatter.dateFormat = "hh:mm a"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        if let dateTime = getFormatter.date(from: data) {
            let time = timeFormatter.string(from: dateTime)
            let date = dateFormatter.string(from: dateTime)
            return ["time": time, "date": date]
        } else {
            return ["": ""]
        }
    }
}
