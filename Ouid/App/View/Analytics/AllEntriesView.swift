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
    let entries: [Entry]
    
    var body: some View {
        ScrollView {
            ScrollViewReader { sp in
                LazyVStack {
                    ForEach(entries) { entry in
                        AnalyticsRow(entry: entry)
                    }
                }.onReceive(vm.$direction) { action in
                    guard !entries.isEmpty else { return }
                    withAnimation {
                        switch action {
                        case .top:
                            sp.scrollTo(entries.first!, anchor: .top)
                        case .end:
                            sp.scrollTo(entries.last!, anchor: .bottom)
                        default:
                            return
                        }
                    }
                }
            }
        }
    }
}

struct AllEntriesView_Previews: PreviewProvider {
    static var previews: some View {
        AllEntriesView(entries: Entry.dummy_entries)
    }
}
