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
            arrowCount = 0
            renderAnalytics()
        }
    }
    @Published var totalAmountTitle = "Today"
    
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
    
    func delete(entryAt offsets: IndexSet) {
        let entryToDelete = offsets.map({ filteredEntries[$0] }).first!
        
        SaveEngine.shared.delete(entry: entryToDelete) { [weak self] entries in
            guard let self = self else { return }
            self.entries = entries
        }
    }
    
    func parseJumpToCurrentTitle() -> String {
        switch selectedFrequency {
        case .day: return "Today"
        case .week: return "This Week"
        case .month: return "This Month"
        }
    }
    
    /// Main function
    private func renderAnalytics() {
        filteredEntries = filterEntries(arrowCount: arrowCount)
        filteredEntries = filteredEntries.sorted(by: { $0.date.compare($1.date) == .orderedDescending })
        
        totalAmount = calculateTotalAmount()
        totalAmountTitle = parseTotalAmountTitle()
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
    
    private func parseTotalAmountTitle() -> String {
        var title = ""
        
        switch selectedFrequency {
        case .day:
            if arrowCount == 0 {
                title = "Today"
            } else if arrowCount == -1 {
                title = "Yesterday (\((Date() + arrowCount.days).toFormat("d MMMM")))"
            } else {
                title = (Date() + arrowCount.days).toFormat("d MMMM")
            }
            break
        case .week:
            let selectedDate = Date() + arrowCount.weeks
            let firstDayOfWeek = selectedDate.dateAtStartOf(.weekOfYear)
            let lastDayOfWeek = selectedDate.dateAtEndOf(.weekOfYear)
            
            let firstDayTitle = firstDayOfWeek.toFormat("d MMM")
            let lastDayTitle = lastDayOfWeek.toFormat("d MMM")
            
            if arrowCount == 0 {
                title = "This Week"
            } else if arrowCount == -1 {
                title = "Last Week (\(firstDayTitle) - \(lastDayTitle))"
            } else {
                title = "\(firstDayTitle) - \(lastDayTitle)"
            }
            break
        case .month:
            if arrowCount == 0 {
                title = "This Month (\(Date().toFormat("MMMM")))"
            } else if arrowCount == -1 {
                title = "Last Month (\((Date() - 1.months).toFormat("MMMM")))"
            } else {
                title = (Date() + arrowCount.months).toFormat("MMMM")
            }
            break
        }
        
        return title
    }
    
    @objc private func calendarDayDidChange(_ notification : NSNotification) {
        load()
    }
}
