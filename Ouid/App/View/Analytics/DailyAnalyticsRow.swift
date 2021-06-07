//
//  DailyAnalyticsRow.swift
//  Ouid
//
//  Created by Kevin Laminto on 7/6/21.
//

import SwiftUI
import SwiftDate

struct DailyAnalyticsRow: View {
    @Binding var entries: [Entry]
    @EnvironmentObject private var viewModel: AnalyticsViewModel
    
    var body: some View {
        ForEach(entries) { entry in
            HStack(spacing: 20) {
                VStack {
                    Text("\(entry.date.toFormat("MMM"))")
                        .foregroundColor(.red)
                        .font(.caption)
                        .textCase(.uppercase)
                    Text("\(entry.date.toFormat("d"))")
                }
                .frame(width: 45, height: 45)
                .clipShape(RoundedRectangle(cornerRadius: 11.25, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 11.25, style: .continuous)
                     .stroke(Color.systemGray5, lineWidth: 1)
                 )
                
                HStack {
                    Text("\(entry.measurement.value, specifier: "%.2f")")
                        .font(.system(.body, design: .rounded))
                    Text("\(entry.measurement.unit.symbol)")
                        .textCase(.uppercase)
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                
                Spacer()
                Text("\(entry.date.timeToString())")
                    .textCase(.lowercase)
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
        }
        .onDelete(perform: { indexSet in
            viewModel.delete(entryAt: indexSet)
        })
    }
}

struct DailyAnalyticsRow_Previews: PreviewProvider {
    static var previews: some View {
        DailyAnalyticsRow(entries: .constant(Entry.dummy_entries))
            .padding()
    }
}
