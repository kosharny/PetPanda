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

struct PandaPieChartView: View {
    let data: [PandaCategory]
    
    var body: some View {
        HStack(spacing: 30) {
            Chart(data) { item in
                SectorMark(
                    angle: .value("Value", item.value),
                    innerRadius: .ratio(0),
                    angularInset: 0.5
                )
                .foregroundStyle(item.color)
            }
            .frame(width: 200, height: 200)
            
            VStack(alignment: .leading, spacing: 12) {
                ForEach(data) { item in
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
