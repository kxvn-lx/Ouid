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
            Section {
                averageRow
                chart
            }
        }
    }
    
    private func getCurrentDay() -> Int {
        return Calendar.current.dateComponents([.weekday], from: (Date())).weekday! - 1
    }
    
    private func isCurrentDay(_ index: Int) -> Bool {
        if viewModel.selectedFrequency == .month {
            return false
        } else {
            return index == getCurrentDay() && viewModel.arrowCount == 0
        }
    }
    
    private func calculateAverage() -> Double {
        let sum = data.reduce(0.0, +)
        return sum / Double(data.count)
    }
}

extension ChartView {
    private var averageRow: some View {
        HStack {
            Text("Average")
            Spacer()
            HStack {
                Text("\(calculateAverage(), specifier: "%.2f")")
                    .font(.system(.body, design: .rounded))
                Text("G")
                    .textCase(.uppercase)
            }
            .foregroundColor(.secondary)
        }
    }
    
    private var chart: some View {
        HStack {
            ForEach((0...data.count - 1), id: \.self) { index in
                VStack {
                    ZStack(alignment: .bottom) {
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .fill(Color.systemGroupedBackground)
                            .frame(width: 20, height: min(CGFloat(data.max()!) * multiplier, multiplier.advanced(by: multiplier / 4)))
                        
                        ZStack(alignment: .top) {
                            RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .fill(Color.accentColor)
//                                .fill(
//                                    LinearGradient(gradient: Gradient(colors: [Color(hex: "#fccb90"), Color(hex: "#d57eeb")]), startPoint: .bottom, endPoint: .top)
//                                )
                                .frame(width: 20, height: viewModel.shouldAnimateChart ? min(calculateBarHeight(at: index), multiplier.advanced(by: multiplier / 4)) : 0)
                                .transition(AnyTransition.slide)
                                .animation(.easeInOut)
                            
                            if data[index] != 0.0 {
                                Text("\(data[index], specifier: "%.2f")")
                                    .foregroundColor(data[index] <= 0.6 ? .label : .systemBackground)
                                    .font(.system(.caption, design: .monospaced))
                                    .rotationEffect(.degrees(-90))
                                    .offset(y: data[index] <= 0.6 ? -25 : 10)
                                    .transition(AnyTransition.opacity)
                                    .animation(.default)
                            }
                        }
                    }
                    Text(viewModel.chartXLabels[index])
                        .foregroundColor(isCurrentDay(index) ? .label : .secondary)
                        .font(.system(.caption, design: .monospaced))
                        .fontWeight(isCurrentDay(index) ? .bold : .regular)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding([.top, .bottom])
    }
    
    private func calculateBarHeight(at index: Int) -> CGFloat {
        let perc = data[index] * (viewModel.selectedFrequency == .week ? 0.5 : 0.75)
        return CGFloat(data[index] - perc) * multiplier
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(data: .constant([0.5, 0.25, 0.3, 0.4, 0.45, 0.23, 0.67]))
    }
}
