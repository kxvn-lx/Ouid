//
//  AnalyticsView.swift
//  Ouid
//
//  Created by Kevin Laminto on 31/5/21.
//

import SwiftUI
import Combine

struct AnalyticsView: View {
    @ObservedObject private var viewModel = AnalyticsViewModel()
    
    var body: some View {
        Form {
            Section(header: Text("Amount Smoked")) {
                HStack {
                    Text("Today")
                    Spacer()
                    HStack {
                        Text("\(viewModel.dayAmount, specifier: "%.2f")")
                        Text("G")
                            .font(.caption)
                    }
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(.secondary)
                }
                HStack {
                    Text("This week")
                    Spacer()
                    HStack {
                        Text("\(viewModel.weekAmount, specifier: "%.2f")")
                        Text("G")
                            .font(.caption)
                    }
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(.secondary)
                }
                HStack {
                    Text("This month")
                    Spacer()
                    HStack {
                        Text("\(viewModel.monthAmount, specifier: "%.2f")")
                        Text("G")
                            .font(.caption)
                    }
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(.secondary)
                }
            }
        }
        .navigationBarTitle("Analytics", displayMode: .large)
    }
}

struct AnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsView()
    }
}
