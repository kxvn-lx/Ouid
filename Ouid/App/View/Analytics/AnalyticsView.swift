//
//  AnalyticsView.swift
//  Ouid
//
//  Created by Kevin Laminto on 31/5/21.
//

import SwiftUI
import Combine

struct EntryView: View {
    let entry: Entry
    
    var body: some View {
        HStack {
            Spacer()
            HStack {
                Text("\(entry.measurement.value, specifier: "%.2f")")
                Text("\(entry.measurement.unit)")
            }
            .font(.system(.body, design: .rounded))
            .foregroundColor(.secondary)
        }
    }
}

struct AnalyticsView: View {
    @ObservedObject private var viewModel = AnalyticsViewModel()
    private var selections = ["Daily", "Weekly", "Monthly"]
    @State private var selectedSelection = "Daily"
    
    var body: some View {
        VStack {
            Form {
                Section(header: selectionControlView) {
                    EmptyView()
                }
                .textCase(nil)
                
                Section(header: Text("Total Amount Smoked")) {
                    totalAmountSmokedView
                }
                
                Section(header: Text("Entries")) {
                    ForEach((1...5), id: \.self) {
                        Text("\($0)")
                    }
                }
            }
        }
        .onAppear(perform: {
            viewModel.load()
            UITableViewCell.appearance().backgroundColor = UIColor.clear
        })
        .navigationBarTitle("Analytics", displayMode: .large)
    }
}

extension AnalyticsView {
    private var totalAmountSmokedView: some View {
        HStack {
            Text("Today")
            Spacer()
            HStack {
                Text("\(viewModel.dayAmount, specifier: "%.2f")")
                Text("G")
            }
            .font(.system(.body, design: .rounded))
            .foregroundColor(.secondary)
        }
    }
    
    private var selectionControlView: some View {
        VStack(alignment: .center, spacing: 0) {
            Picker(selection: $selectedSelection, label: Text("What is your favorite color?")) {
                ForEach(selections, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
}

struct AnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsView()
    }
}
