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
    
    private var maxY: Double {
        let maxVal = data.map { $0.value }.max() ?? 0
        return maxVal < 5 ? 5 : maxVal + 1.2
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Chart {
                ForEach(data) { item in
                    BarMark(
                        x: .value("Date", item.category),
                        y: .value("Value", item.value),
                        width: .fixed(16)
                    )
                    .foregroundStyle(item.color)
                    .cornerRadius(4)
                }
            }
            .chartXScale(domain: data.map { $0.category })
            .chartYScale(domain: 0...maxY)
            .chartXAxis(.hidden)
            .chartYAxis {
                AxisMarks(position: .leading, values: .automatic(desiredCount: 3)) { value in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                        .foregroundStyle(Color.white.opacity(0.2))
                    AxisValueLabel()
                        .foregroundStyle(Color.white.opacity(0.6))
                }
            }
            .frame(height: 200)
            .padding(.top, 10)
        }
        .padding()
        .background(Color.endBg)
        .cornerRadius(12)
    }
}
