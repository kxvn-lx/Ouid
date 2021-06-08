//
//  DailyAnalyticsRow.swift
//  Ouid
//
//  Created by Kevin Laminto on 7/6/21.
//

import SwiftUI
import SwiftDate

struct AnalyticsRow: View {
    let entry: Entry
    
    var body: some View {
        HStack(spacing: 20) {
            VStack {
                Text("\(entry.date.convertTo(region: .current).toFormat("MMM"))")
                    .foregroundColor(.red)
                    .font(.caption)
                    .textCase(.uppercase)
                Text("\(entry.date.convertTo(region: .current).toFormat("d"))")
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
            Text("\(entry.date.convertTo(region: .current).toFormat("h:mm a"))")
                .textCase(.lowercase)
                .foregroundColor(.secondary)
                .font(.caption)
        }
    }
}

struct EntriesRow: View {
    @Binding var entries: [Entry]
    @EnvironmentObject private var viewModel: AnalyticsViewModel
    
    var body: some View {
        if !entries.isEmpty {
            ForEach(entries.prefix(viewModel.shouldDisplayAllEntriesButton() ? 5 : entries.count)) { entry in
                AnalyticsRow(entry: entry)
            }
            .onDelete(perform: { indexSet in
                viewModel.delete(entryAt: indexSet)
            })
        } else {
            Text("No entries. Perhaps time for a J? 👀")
                .foregroundColor(.secondary)
        }
    }
}

struct DailyAnalyticsRow_Previews: PreviewProvider {
    static var previews: some View {
        EntriesRow(entries: .constant(Entry.dummy_entries))
            .padding()
    }
}
