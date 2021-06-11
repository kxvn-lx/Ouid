//
//  ChartStyle.swift
//  Ouid
//
//  Created by Kevin Laminto on 11/6/21.
//

import Foundation
import SwiftUI

struct ChartStyle: Identifiable, Hashable {
    let id = UUID()
    let gradient: Gradient
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static let DEFAULT_STYLES: [ChartStyle] = [
        .init(gradient: .init(colors: [.accentColor, .accentColor])),
        .init(gradient: .init(colors: [Color(hex: "#dd3e54"), Color(hex: "#6be585")])),
        .init(gradient: .init(colors: [Color(hex: "#8E2DE2"), Color(hex: "#4A00E0")])),
        .init(gradient: .init(colors: [Color(hex: "#4e54c8"), Color(hex: "#8f94fb")])),
        .init(gradient: .init(colors: [Color(hex: "#99f2c8"), Color(hex: "#283c86")])),
        .init(gradient: .init(colors: [Color(hex: "#7F7FD5"), Color(hex: "#86A8E7"), Color(hex: "#86A8E7")])),
        .init(gradient: .init(colors: [Color(hex: "#654ea3"), Color(hex: "#eaafc8")])),
        .init(gradient: .init(colors: [Color(hex: "#ad5389"), Color(hex: "#3c1053")])),
        .init(gradient: .init(colors: [Color(hex: "#fffbd5"), Color(hex: "#b20a2c")])),
    ]
}
