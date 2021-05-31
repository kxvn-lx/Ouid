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
}

extension Calendar {
    func isDayInCurrentWeek(date: Date) -> Bool? {
        let currentComponents = Calendar.current.dateComponents([.weekOfYear], from: Date())
        let dateComponents = Calendar.current.dateComponents([.weekOfYear], from: date)
        guard let currentWeekOfYear = currentComponents.weekOfYear, let dateWeekOfYear = dateComponents.weekOfYear else { return nil }
        return currentWeekOfYear == dateWeekOfYear
    }
    
    func isDayInCurrentMonth(date: Date) -> Bool? {
        let currentComponents = Calendar.current.dateComponents([.month], from: Date())
        let dateComponents = Calendar.current.dateComponents([.month], from: date)
        
        guard let currentMonth = currentComponents.month, let dateMonth = dateComponents.month else { return nil }
        return currentMonth == dateMonth
    }
}
