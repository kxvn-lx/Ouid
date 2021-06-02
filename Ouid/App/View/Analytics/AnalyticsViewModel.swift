//
//  AnalyticsViewModel.swift
//  Ouid
//
//  Created by Kevin Laminto on 30/5/21.
//

import Foundation
import Combine

struct ScheduleDates {
    let month: String
    let dates: [Date]
}

class AnalyticsViewModel: NSObject, ObservableObject {
    enum SumAmountState {
        case day, week, month
    }
    
    private var entries = [Entry]() {
        didSet {
            calculateAllSumAmount()
        }
    }
    @Published var dayAmount: Double = 0.0
    @Published var monthAmount: Double = 0.0
    @Published var weekAmount: Double = 0.0
    @Published var monthlyAmount: [String: Double] = [:]
    
    private var saveEngine = SaveEngine()
    
    override init() {
        super.init()
        load()
        calculateAllSumAmount()
        NotificationCenter.default.addObserver(self, selector:#selector(self.calendarDayDidChange(_:)), name:NSNotification.Name.NSCalendarDayChanged, object:nil)
    }
    
    @objc private func calendarDayDidChange(_ notification : NSNotification) {
        load()
    }
    
    func load() {
        saveEngine.load()
        entries = saveEngine.savedEntries
    }
    
    private func calculateAllSumAmount() {
        dayAmount = calculateSumAmount(.day)
        monthAmount = calculateSumAmount(.month)
        weekAmount = calculateSumAmount(.week)
        
        monthlyAmount = calculateMonthly()
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
    
    private func calculateMonthly() -> [String: Double] {
        let parsedEntries = Dictionary(grouping: entries) { entry -> String in
            let monthAsInt = Calendar.current.dateComponents([.month], from: entry.date).month!
            let monthName = DateFormatter().monthSymbols[(monthAsInt) - 1]
            return monthName
        }
        
        var parsedAmount: [String: Double] = [:]
        
        for (key, value) in parsedEntries {
            let valueTotal = value.map({ $0.measurement.value }).reduce(0, +)
            parsedAmount[key] = valueTotal
        }
        
        return parsedAmount
    }
}
