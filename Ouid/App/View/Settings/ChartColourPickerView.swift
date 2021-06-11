//
//  ChartColourPickerView.swift
//  Ouid
//
//  Created by Kevin Laminto on 10/6/21.
//

import SwiftUI

struct ChartColourPickerView: View {
    @Environment(\.presentationMode) private var presentationMode
    private let columns: [GridItem] = .init(repeating: GridItem(.flexible(), spacing: 50), count: 3)
    private let data = (1...7).map( {_ in Double.random(in: 0.1...0.9)} )
    private let multiplier: Double = 100
    
    //    @UserDefaultsBacked<ChartStyle>(key: .chartStyle)
    //    var selectedStyle = ChartStyle.DEFAULT_STYLES.first!
    @State private var selectedStyle = ChartStyle.DEFAULT_STYLES.first!
    
    var body: some View {
        Form {
            Section {
                staticChart
            }
            
            Divider()
                .listRowBackground(Color.clear)
            
            Section {
                LazyVGrid(columns: columns, spacing: 20, content: {
                    ForEach(ChartStyle.DEFAULT_STYLES, id: \.self) { chartStyle in
                        ZStack {
                            RoundedRectangle(cornerRadius: 22.5, style: .continuous)
                                .fill(
                                    LinearGradient(gradient: chartStyle.gradient, startPoint: .top, endPoint: .bottom)
                                )
                                .frame(width: 90, height: 90)
                            
                            RoundedRectangle(cornerRadius: 25, style: .continuous)
                                .stroke(lineWidth: chartStyle == selectedStyle ? 3 : 0)
                                .foregroundColor(.systemGray)
                                .frame(width: 100, height: 100)
                            
                        }
                        .onTapGesture(perform: {
                            TapticHelper.shared.lightTaptic()
                            self.selectedStyle = chartStyle
                        })
                    }
                })
            }
            .listRowBackground(Color.clear)
        }
        .onAppear(perform: {
            UITableViewCell.appearance().backgroundColor = UIColor.clear
        })
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

extension ChartColourPickerView {
    private var staticChart: some View {
        HStack {
            ForEach((0...6), id: \.self) { index in
                VStack {
                    ZStack(alignment: .bottom) {
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .fill(Color.systemGroupedBackground)
                            .frame(width: 20, height: CGFloat(data.max()! * multiplier))
                        
                        ZStack(alignment: .top) {
                            RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .fill(
                                    LinearGradient(gradient: selectedStyle.gradient, startPoint: .top, endPoint: .bottom)
                                )
                                .frame(width: 20, height: CGFloat(data[index] * multiplier))
                            
                            Text("\(data[index], specifier: "%.2f")")
                                .foregroundColor(data[index] <= 0.4 ? .label : .systemBackground)
                                .font(.system(.caption, design: .monospaced))
                                .rotationEffect(.degrees(-90))
                                .offset(y: data[index] <= 0.4 ? -25 : 10)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding([.top, .bottom])
    }
}

struct ChartColourPickerView_Previews: PreviewProvider {
    static var previews: some View {
        ChartColourPickerView()
    }
}
