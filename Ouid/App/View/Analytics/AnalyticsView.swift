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
                
                Section {
                    totalAmountSmokedView
                }
                .listRowBackground(Color.clear)
                
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
                    TapticHelper.shared.lightTaptic()
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
                    TapticHelper.shared.lightTaptic()
                    viewModel.arrowCount += 1
                }, label: {
                    Image(systemName: "chevron.right.circle")
                })
                .disabled(viewModel.arrowCount == 0)
            }
        }
    }
    
    private func delete(at offsets: IndexSet) {
        
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
            Spacer()
            Button(action: {
                isShowingEntries.toggle()
            }, label: {
                Text(isShowingEntries ? "Hide" : "Show")
            })
            .textCase(nil)
        }
    }
}

struct AnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsView()
    }
}
