//
//  EntryViewModel.swift
//  Ouid
//
//  Created by Kevin Laminto on 29/5/21.
//

import Foundation

class EntryViewModel {
    private(set) var entries = [Entry]() {
        didSet {
            entries = entries.sorted(by: { $0.date.compare($1.date) == .orderedDescending })
        }
    }
    private var saveEngine = SaveEngine()
    
    init() {
        entries = saveEngine.savedEntries.sorted(by: { $0.date.compare($1.date) == .orderedDescending })
    }
    
    func save(_ entry: Entry) {
        saveEngine.save(entry)
        entries = saveEngine.savedEntries
    }
}
