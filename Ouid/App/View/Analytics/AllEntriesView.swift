//
//  AllEntriesView.swift
//  Ouid
//
//  Created by Kevin Laminto on 8/6/21.
//

import SwiftUI

class ScrollToModel: ObservableObject {
    enum Action {
        case end
        case top
    }
    @Published var direction: Action? = nil
}

struct AllEntriesView: View {
    @StateObject private var vm = ScrollToModel()
    @EnvironmentObject private var viewModel: AnalyticsViewModel
    private let entries: [Entry]
    
    init(entries: [Entry]) {
        self.entries = entries
    }
    
    var body: some View {
        Form {
            Section {
                ForEach(entries) { entry in
                    AnalyticsRow(entry: entry)
                }
            }
        }
        .navigationBarTitle(viewModel.totalAmountTitle, displayMode: .inline)
    }
}

struct AllEntriesView_Previews: PreviewProvider {
    static var previews: some View {
        AllEntriesView(entries: Entry.dummy_entries)
    }
}
