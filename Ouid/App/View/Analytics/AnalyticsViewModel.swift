//
//  AnalyticsViewModel.swift
//  Ouid
//
//  Created by Kevin Laminto on 30/5/21.
//

import Foundation
import Combine
import SwiftDate

class AnalyticsViewModel: NSObject, ObservableObject {
    enum Frequency: String, CaseIterable {
        case day = "Daily"
        case week = "Weekly"
        case month = "Monthly"
    }
    
    private var entries = [Entry]() {
        didSet {
            renderAnalytics()
        }
    }
    @Published var filteredEntries = [Entry]()
    @Published var arrowCount = 0 {
        didSet {
            renderAnalytics()
        }
    }
    @Published var totalAmount: Measurement<UnitMass> = Measurement(value: 0.0, unit: .grams)
    @Published var selectedFrequency: Frequency = .day {
        didSet {
            renderAnalytics()
        }
    }
    
    override init() {
        super.init()
        load()
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.calendarDayDidChange(_:)), name:NSNotification.Name.NSCalendarDayChanged, object:nil)
    }
    
    /// reload the entries
    func load() {
        SaveEngine.shared.load { [weak self] entries in
            guard let self = self else { return }
            self.entries = entries
        }
    }
    
    /// Main function
    private func renderAnalytics() {
        filteredEntries = filterEntries(arrowCount: arrowCount)
        filteredEntries = filteredEntries.sorted(by: { $0.date.compare($1.date) == .orderedDescending })
        
        totalAmount = calculateTotalAmount()
    }
    
    private func filterEntries(arrowCount: Int) -> [Entry] {
        var filteredEntries = [Entry]()
        switch selectedFrequency {
        case .day:
            filteredEntries = entries.filter({ $0.date.compare(.isSameDay(Date() + arrowCount.days)) })
            break
        case .week:
            filteredEntries = entries.filter({ $0.date.compare(.isSameWeek(Date() + arrowCount.weeks)) })
            break
        case .month:
            filteredEntries = entries.filter({ $0.date.compare(.isSameMonth(Date() + arrowCount.months)) })
            break
        }
        
        return filteredEntries
    }
    
    private func calculateTotalAmount() -> Measurement<UnitMass> {
        var amount: Double = 0.0
        
        for entry in filteredEntries {
            amount += entry.measurement.value
        }
        
        return .init(value: amount, unit: .grams)
    }
    
    @objc private func calendarDayDidChange(_ notification : NSNotification) {
        load()
    }
}
