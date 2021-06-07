//
//  Date+.swift
//  Ouid
//
//  Created by Kevin Laminto on 29/5/21.
//

import Foundation

extension Date {
    init(_ dateString:String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        let date = dateStringFormatter.date(from: dateString)!
        self.init(timeInterval:0, since:date)
    }
    
    func timeToString() -> String {
        let format = DateFormatter()
        format.timeZone = .current
        format.dateFormat = "h:mm a"
         
        return format.string(from: self)
    }
}
