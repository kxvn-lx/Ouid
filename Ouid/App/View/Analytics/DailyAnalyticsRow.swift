//
//  DailyAnalyticsRow.swift
//  Ouid
//
//  Created by Kevin Laminto on 7/6/21.
//

import SwiftUI

struct DailyAnalyticsRow: View {
    @Binding var entries: [Entry]
    
    var body: some View {
        ForEach(entries) { entry in
            HStack {
                Text("Today")
                Spacer()
                HStack {
                    Text("\(entry.measurement.value, specifier: "%.2f")")
                    Text("\(entry.measurement.unit.symbol)")
                        .textCase(.uppercase)
                }
                .font(.system(.body, design: .rounded))
                .foregroundColor(.secondary)
            }
        }
    }
}

struct WeeklyAnalyticsRow: View {
    @Binding var entries: [Entry]
    
    var body: some View {
        ForEach(entries) { entry in
            HStack {
                Text("This Week")
                Spacer()
                HStack {
                    Text("\(entry.measurement.value, specifier: "%.2f")")
                    Text("\(entry.measurement.unit.symbol)")
                        .textCase(.uppercase)
                }
                .font(.system(.body, design: .rounded))
                .foregroundColor(.secondary)
            }
        }
    }
}

struct MonthlyAnalyticsRow: View {
    @Binding var entries: [Entry]
    
    var body: some View {
        ForEach(entries) { entry in
            HStack {
                Text("This Month")
                Spacer()
                HStack {
                    Text("\(entry.measurement.value, specifier: "%.2f")")
                    Text("\(entry.measurement.unit.symbol)")
                        .textCase(.uppercase)
                }
                .font(.system(.body, design: .rounded))
                .foregroundColor(.secondary)
            }
        }
    }
}

struct DailyAnalyticsRow_Previews: PreviewProvider {
    static var previews: some View {
        DailyAnalyticsRow(entries: .constant(Entry.dummy_entries))
    }
}
