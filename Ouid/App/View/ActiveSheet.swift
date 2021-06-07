//
//  ActiveSheet.swift
//  Ouid
//
//  Created by Kevin Laminto on 7/6/21.
//

import Foundation

enum ActiveSheet: Identifiable {
    case addEntryView
    
    var id: Int {
        hashValue
    }
}
