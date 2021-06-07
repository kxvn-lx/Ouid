//
//  AnalyticsView.swift
//  Ouid
//
//  Created by Kevin Laminto on 31/5/21.
//

import SwiftUI
import Combine

// MARK: - Main
struct AnalyticsView: View {
    @ObservedObject private var viewModel = AnalyticsViewModel()
    @State private var isShowingEntries = true
    @State private var activeSheet: ActiveSheet?
    
    init() {
        UITableViewCell.appearance().backgroundColor = UIColor.clear
    }
    
    var body: some View {
        VStack {
            Form {
                Section(header: selectionHeaderView) {
                    EmptyView()
                }
                .textCase(nil)
                
                Section(header: Text("Total Amount Smoked")) {
                    totalAmountSmokedView
                }
                
                Section(header: entriesHeaderView) {
                    Button {
                        activeSheet = .addEntryView
                    } label: {
                        HStack {
                            Spacer()
                            Text("Add an Entry")
                            Spacer()
                        }
                    }
                    
                    if isShowingEntries {
                        DailyAnalyticsRow(entries: $viewModel.filteredEntries)
                    }
                }
            }
        }
        .onAppear(perform: {
            viewModel.load()
        })
        .navigationBarTitle("Dashboard", displayMode: .large)
        .sheet(item: $activeSheet) {
            viewModel.load()
        } content: { item in
            switch item {
            case .addEntryView:
                AddEntryView()
            }
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button(action: {
                    viewModel.arrowCount -= 1
                }, label: {
                    Image(systemName: "chevron.left.circle")
                })
            }
            ToolbarItem(placement: .bottomBar) {
                Spacer()
            }
            ToolbarItem(placement: .bottomBar) {
                Button(action: {
                    viewModel.arrowCount += 1
                }, label: {
                    Image(systemName: "chevron.right.circle")
                })
                .disabled(viewModel.arrowCount == 0)
            }
        }
    }
}

// MARK: - Views
extension AnalyticsView {
    private var totalAmountSmokedView: some View {
        HStack {
            Text("Today")
            Spacer()
            HStack {
                Text("\(viewModel.totalAmount.value, specifier: "%.2f")")
                Text("G")
            }
            .font(.system(.body, design: .rounded))
            .foregroundColor(.secondary)
        }
    }
    
    private var selectionHeaderView: some View {
        VStack(alignment: .center, spacing: 0) {
            Picker(selection: $viewModel.selectedFrequency, label: Text("Select frequency")) {
                ForEach(AnalyticsViewModel.Frequency.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
    
    private var entriesHeaderView: some View {
        HStack {
            Text("Entries")
            Spacer()
            Button(action: {
                withAnimation(.linear) {
                    isShowingEntries.toggle()
                }
            }, label: {
                Text(isShowingEntries ? "Hide" : "Show")
            })
            .textCase(nil)
        }
    }
}

// MARK: - Sub views
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

struct AnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsView()
    }
}
