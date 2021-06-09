//
//  ChartView.swift
//  Ouid
//
//  Created by Kevin Laminto on 8/6/21.
//

import SwiftUI

struct ChartView: View {
    @Binding var data: [Double]
    private let multiplier: CGFloat = 100
    private let WEEK_NAMES = ["S", "M", "T", "W", "T", "F", "S"]
    
    var body: some View {
        HStack(spacing: 20) {
            ForEach(data, id: \.self) { value in
                VStack {
                    ZStack(alignment: .bottom) {
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .fill(Color.systemGroupedBackground)
//                            .frame(width: 20, height: min(CGFloat(data.max()!) * multiplier, multiplier))
                            .frame(width: 20, height: CGFloat(data.max()!) * multiplier)
                        
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .fill(Color.accentColor)
//                            .frame(width: 20, height: min(CGFloat(value) * multiplier, multiplier))
                            .frame(width: 20, height: CGFloat(value) * multiplier)
                    }
                }
            }
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(data: .constant([0.5, 0.25, 0.3, 0.4, 0.45, 0.23, 0.67]))
    }
}