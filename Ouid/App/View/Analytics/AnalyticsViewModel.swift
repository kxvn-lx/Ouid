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
    
    private var saveEngine = SaveEngine()
    private var entries = [Entry]() {
        didSet {
            calculateAllSumAmount()
        }
    }
    @Published var dayAmount: Double = 0.0
    
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
    }
    
    private func calculateSumAmount(_ type: SumAmountState) -> Double {
        let calendar = Calendar.current
        var filteredEntries = [Entry]()
        var sumAmount: Double = 0.0
        
        switch type {
        case .day:
            filteredEntries = entries.filter({ calendar.isDateInToday($0.date) })
            break
        default: break
        }
        
        for entry in filteredEntries {
            sumAmount += entry.measurement.value
        }
        
        return sumAmount
    }
}
