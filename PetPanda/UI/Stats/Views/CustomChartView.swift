//
//  CustomChartView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 18.01.2026.
//

import SwiftUI
import Charts

struct ChartData: Identifiable {
    let id = UUID()
    let category: String
    let value: Double
    let color: Color
}

struct CustomChartView: View {
    let data: [ChartData]
    
    var body: some View {
        VStack {
            Chart {
                ForEach(data) { item in
                    BarMark(
                        x: .value("Date", item.category),
                        y: .value("Value", item.value),
                        width: .fixed(12)
                    )
                    .foregroundStyle(item.color)
                    .cornerRadius(4)
                }
            }
            .chartXAxis(.hidden)
            .chartYAxis {
                AxisMarks(values: [0, 25, 50, 75, 100]) { value in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                        .foregroundStyle(Color.white.opacity(0.4))
                }
            }
            .frame(height: 200)
            .padding()
            .background(Color.endBg)
            .cornerRadius(12)
        }
    }
}
