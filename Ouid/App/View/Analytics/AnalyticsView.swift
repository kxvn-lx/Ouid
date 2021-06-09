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
    @EnvironmentObject private var viewModel: AnalyticsViewModel
    @State private var activeSheet: ActiveSheet?
    
    var body: some View {
        VStack {
            Form {
                Section(header: selectionHeaderView) {
                    EmptyView()
                }
                .textCase(nil)
                
                Section {
                    totalAmountSmokedView
                }
                .listRowBackground(Color.clear)
                
                Section {
                    graphView
                }
                
                Section(header: entriesHeaderView) {
                    EntriesRow(entries: $viewModel.filteredEntries)
                    if viewModel.shouldDisplayAllEntriesButton() {
                        NavigationLink(
                            destination: AllEntriesView(entries: viewModel.filteredEntries),
                            label: {
                                Text("See all \(viewModel.filteredEntries.count) entries")
                                    .foregroundColor(.accentColor)
                            })
                    }
                }
            }
            .onAppear(perform: {
                viewModel.load()
                UITableViewCell.appearance().backgroundColor = UIColor.clear
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
                        TapticHelper.shared.lightTaptic()
                        viewModel.arrowCount -= 1
                    }, label: {
                        Image(systemName: "chevron.left.circle")
                    })
                    .disabled(viewModel.shouldDisableLeftScanner)
                }
                ToolbarItem(placement: .bottomBar) {
                    Spacer()
                }
                ToolbarItem(placement: .bottomBar) {
                    if !(viewModel.arrowCount == 0) {
                        Button {
                            TapticHelper.shared.lightTaptic()
                            viewModel.arrowCount = 0
                        } label: {
                            Text("Show \(viewModel.parseJumpToCurrentTitle())")
                        }
                    } else {
                        Spacer()
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Spacer()
                }
                ToolbarItem(placement: .bottomBar) {
                    Button(action: {
                        TapticHelper.shared.lightTaptic()
                        viewModel.arrowCount += 1
                    }, label: {
                        Image(systemName: "chevron.right.circle")
                    })
                    .disabled(viewModel.arrowCount == 0)
                }
            }
        }
    }
}

// MARK: - Views
extension AnalyticsView {
    private var totalAmountSmokedView: some View {
        HStack {
            Spacer()
            VStack (spacing: 10) {
                HStack(alignment: .firstTextBaseline) {
                    Text("\(viewModel.totalAmount.value, specifier: "%.2f")")
                        .font(.system(.largeTitle, design: .rounded))
                    Text("G")
                        .font(.system(.title3, design: .rounded))
                }
                
                Text(viewModel.totalAmountTitle)
                    .foregroundColor(.secondary)
            }
            Spacer()
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
            Button {
                activeSheet = .addEntryView
            } label: {
                HStack {
                    Image(systemName: "plus.circle")
                }
            }
        }
    }
    
    @ViewBuilder
    private var graphView: some View {
        switch viewModel.selectedFrequency {
        case .day: EmptyView()
        case .week, .month:
            ChartView(data: $viewModel.chartData)
                .frame(maxWidth: .infinity)
        }
    }
}

struct AnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsView()
    }
}
