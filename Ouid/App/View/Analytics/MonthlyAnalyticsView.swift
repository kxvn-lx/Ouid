//
//  MonthlyAnalyticsView.swift
//  Ouid
//
//  Created by Kevin Laminto on 1/6/21.
//

import SwiftUI

struct MonthlyAnalyticsView: View {
    @Binding var dict: [String: Double]
    var body: some View {
        List {
            ForEach(dict.sorted(by: >), id: \.key) { key, value in
                HStack {
                    Text(key)
                    Spacer()
                    HStack {
                        Text("\(value, specifier: "%.2f")")
                        Text("G")
                    }
                    .foregroundColor(.secondary)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("Monthly Amount")
    }
}

struct MonthlyAnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        MonthlyAnalyticsView(dict: .constant(["January": 20]))
    }
}
