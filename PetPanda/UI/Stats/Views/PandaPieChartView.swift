//
//  PandaPieChartView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 18.01.2026.
//

import SwiftUI
import Charts

struct PandaCategory: Identifiable {
    let id = UUID()
    let name: String
    let value: Double
    let color: Color
}

let pandaData: [PandaCategory] = [
    PandaCategory(name: "Habitat", value: 25, color: Color.mainGreen),
    PandaCategory(name: "Diet", value: 20, color: Color.darkBlueChart),
    PandaCategory(name: "Behavior", value: 15, color: Color.darkGreenChart),
    PandaCategory(name: "Fun Facts", value: 20, color: Color.greanCharts),
    PandaCategory(name: "Health", value: 20, color: Color.blueCharts)
]

struct PandaPieChartView: View {
    var body: some View {
        HStack(spacing: 30) {
            Chart(pandaData) { item in
                SectorMark(
                    angle: .value("Value", item.value),
                    innerRadius: .ratio(0),
                    angularInset: 0.5
                )
                .foregroundStyle(item.color)
            }
            .frame(width: 200, height: 200)
            
            VStack(alignment: .leading, spacing: 12) {
                ForEach(pandaData) { item in
                    HStack(spacing: 12) {
                        Circle()
                            .fill(item.color)
                            .frame(width: 14, height: 14)
                        
                        Text(item.name)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(Color.endBg)
        .cornerRadius(20)
    }
}
