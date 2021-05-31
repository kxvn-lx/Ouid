//
//  AnalyticsViewModel.swift
//  Ouid
//
//  Created by Kevin Laminto on 30/5/21.
//

import Foundation
import Combine

class AnalyticsViewModel: NSObject, ObservableObject {
    enum SumAmountState {
        case day, week, month
    }
    
    private var entries = [Entry]()
    @Published var dayAmount: Double = 0.0
    @Published var monthAmount: Double = 0.0
    @Published var weekAmount: Double = 0.0
    
    private var saveEngine = SaveEngine()
    
    override init() {
        super.init()
        entries = saveEngine.savedEntries
        
        calculateAllSumAmount()
        NotificationCenter.default.addObserver(self, selector:#selector(self.calendarDayDidChange(_:)), name:NSNotification.Name.NSCalendarDayChanged, object:nil)
    }
    
    @objc private func calendarDayDidChange(_ notification : NSNotification) {
        calculateAllSumAmount()
    }
    
    private func calculateAllSumAmount() {
        dayAmount = calculateSumAmount(.day)
        monthAmount = calculateSumAmount(.month)
        weekAmount = calculateSumAmount(.week)
    }
    
    private func calculateSumAmount(_ type: SumAmountState) -> Double {
        let calendar = Calendar.current
        let filteredEntries: [Entry]
        var sumAmount: Double = 0.0
        
        switch type {
        case .day:
            filteredEntries = entries.filter({ calendar.isDateInToday($0.date) })
            break
        case .week:
            filteredEntries = entries.filter({ calendar.isDayInCurrentWeek(date: $0.date) ?? false })
            break
        case .month:
            filteredEntries = entries.filter({ calendar.isDayInCurrentMonth(date: $0.date) ?? false })
            break
        }
        for entry in filteredEntries {
            sumAmount += entry.measurement.value
        }
        
        return sumAmount
    }
}
