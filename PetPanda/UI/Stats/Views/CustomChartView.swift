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

let sampleData: [ChartData] = [
    ChartData(category: "1", value: 80, color: Color.blueCharts),
    ChartData(category: "2", value: 45, color: Color.mainGreen),
    ChartData(category: "3", value: 25, color: Color.greanCharts),
    ChartData(category: "4", value: 85, color: Color.mainGreen),
    ChartData(category: "5", value: 45, color: Color.greanCharts),
    ChartData(category: "6", value: 55, color: Color.blueCharts),
    ChartData(category: "7", value: 90, color: Color.greanCharts),
    ChartData(category: "8", value: 48, color: Color.mainGreen),
    ChartData(category: "9", value: 90, color: Color.blueCharts),
    ChartData(category: "10", value: 10, color: Color.mainGreen),
    ChartData(category: "11", value: 70, color: Color.greanCharts),
    ChartData(category: "12", value: 90, color: Color.blueCharts),
    ChartData(category: "13", value: 75, color: Color.greanCharts),
    ChartData(category: "14", value: 70, color: Color.mainGreen),
    ChartData(category: "15", value: 72, color: Color.blueCharts),
    ChartData(category: "16", value: 40, color: Color.mainGreen),
    ChartData(category: "17", value: 60, color: Color.greanCharts),
    ChartData(category: "18", value: 50, color: Color.blueCharts),
    ChartData(category: "19", value: 35, color: Color.greanCharts),
    ChartData(category: "20", value: 12, color: Color.mainGreen)
]

struct CustomChartView: View {
    var body: some View {
        VStack {
            Chart {
                ForEach(sampleData) { item in
                    BarMark(
                        x: .value("Category", item.category),
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
