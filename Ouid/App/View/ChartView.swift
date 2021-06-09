//
//  ChartView.swift
//  Ouid
//
//  Created by Kevin Laminto on 8/6/21.
//

import SwiftUI

struct ChartView: View {
    @EnvironmentObject private var viewModel: AnalyticsViewModel
    @Binding var data: [Double]
    private let multiplier: CGFloat = 100
    private let WEEK_NAMES = ["S", "M", "T", "W", "T", "F", "S"]
    
    var body: some View {
        if !data.isEmpty {
            HStack(spacing: 20) {
                ForEach((0...data.count - 1), id: \.self) { index in
                    VStack {
                        ZStack(alignment: .bottom) {
                            RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .fill(Color.systemGroupedBackground)
                                .frame(width: 20, height: min(CGFloat(data.max()!) * multiplier, multiplier.advanced(by: multiplier / 4)))
                            
                            ZStack(alignment: .top) {
                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                    .fill(Color.accentColor)
                                    .frame(width: 20, height: min(CGFloat(data[index]) * multiplier, multiplier))
                                
                                Text("\(data[index], specifier: "%.2f")")
                                    .foregroundColor(.systemBackground)
                                    .font(.caption)
                                    .rotationEffect(.degrees(-90))
                                    .offset(y: 10)
                                
                            }
                        }
                        Text(WEEK_NAMES[index])
                            .foregroundColor(isCurrentDay(index) ? .label : .secondary)
                            .font(.caption)
                            .fontWeight(isCurrentDay(index) ? .bold : .regular)
                    }
                }
            }
        }
    }
    
    private func getCurrentDay() -> Int {
        return Calendar.current.dateComponents([.weekday], from: (Date())).weekday! - 1
    }
    
    private func isCurrentDay(_ index: Int) -> Bool {
        return index == getCurrentDay() && viewModel.arrowCount == 0
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(data: .constant([0.5, 0.25, 0.3, 0.4, 0.45, 0.23, 0.67]))
    }
}
