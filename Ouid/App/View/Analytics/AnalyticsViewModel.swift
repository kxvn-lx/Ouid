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
    
    static let MAX_ENTRIES = 5
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
    @Published var shouldDisableLeftScanner = true
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
    
    func shouldDisplayAllEntriesButton() -> Bool {
        let filteredCount = filteredEntries.count
        let difference = filteredCount - Self.MAX_ENTRIES
        
        return difference >= 5
    }
    
    /// Main function
    private func renderAnalytics() {
        DispatchQueue.main.async { [self] in
            filteredEntries = filterEntries(arrowCount: arrowCount)
            filteredEntries = filteredEntries.sorted(by: { $0.date.compare($1.date) == .orderedDescending })
            
            totalAmount = calculateTotalAmount()
            totalAmountTitle = parseTotalAmountTitle()
            
            shouldDisableLeftScanner = arrowCount == getMinArrowCount()
        }
    }
    
    private func getMinArrowCount() -> Int {
        let earlistEntry = entries.sorted(by: { $0.date.compare($1.date) == .orderedDescending }).last!
        
        switch selectedFrequency {
        case .day:
            let diffs = Calendar.current.dateComponents([.day], from: Date(), to: earlistEntry.date)
            return diffs.day!
        case .week:
            let diffs = Calendar.current.dateComponents([.weekday], from: Date(), to: earlistEntry.date)
            return diffs.weekday!
        case .month:
            let diffs = Calendar.current.dateComponents([.weekOfMonth], from: Date(), to: earlistEntry.date)
            return diffs.weekOfMonth!
        }
    }
    
    private func filterEntries(arrowCount: Int) -> [Entry] {
        var filteredEntries = [Entry]()
        switch selectedFrequency {
        case .day:
            filteredEntries = entries.filter({ $0.date.convertTo(region: .current).compare(.isSameDay(Date().convertTo(region: .current) + arrowCount.days)) })
            break
        case .week:
            filteredEntries = entries.filter({$0.date.convertTo(region: .current).compare(.isSameWeek((Date().convertTo(region: .current)) + arrowCount.weeks)) })
            break
        case .month:
            filteredEntries = entries.filter({$0.date.convertTo(region: .current).compare(.isSameMonth(Date().convertTo(region: .current) + arrowCount.months)) })
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
                title = "Today (\((Date() + arrowCount.days).toFormat("d MMMM")))"
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
                title = "This Week (\(firstDayTitle) - \(lastDayTitle))"
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
