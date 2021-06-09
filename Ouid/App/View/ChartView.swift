//
//  ChartView.swift
//  Ouid
//
//  Created by Kevin Laminto on 8/6/21.
//

import SwiftUI

struct ChartView: View {
    let data: [Double]
    private let multiplier: CGFloat = 100
    
    var body: some View {
        HStack(spacing: 20) {
            ForEach(data, id: \.self) { value in
                VStack {
                    Spacer()
                    ZStack(alignment: .bottom) {
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .fill(Color.systemGroupedBackground)
                            .frame(width: 20, height: min(CGFloat(data.max()!) * multiplier, multiplier))
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .fill(Color.accentColor)
                            .frame(width: 20, height: min(CGFloat(value) * multiplier, multiplier))
                    }
                    .transition(.scale)
                }
            }
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(data: [0.5, 0.25, 0.3, 0.4, 0.45, 0.23, 0.67])
    }
}
