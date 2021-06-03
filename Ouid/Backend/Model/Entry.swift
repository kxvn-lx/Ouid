//
//  Entry.swift
//  Ouid
//
//  Created by Kevin Laminto on 29/5/21.
//

import Foundation

struct Entry: Codable, Hashable, Equatable, Identifiable {
    var id = UUID()
    var date: Date
    var measurement: Measurement<UnitMass>
    
    static let dummy_entries: [Entry] = [
        .init(date: .init("29/05/2021 15:12"), measurement: .init(value: 0.5, unit: .grams)),
        .init(date: .init("29/05/2021 09:30"), measurement: .init(value: 0.25, unit: .grams)),
        .init(date: .init("28/05/2021 20:10"), measurement: .init(value: 0.4, unit: .grams)),
        .init(date: .init("27/05/2021 14:30"), measurement: .init(value: 0.2, unit: .grams)),
    ]
}
