//
//  StatsView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 18.01.2026.
//

import SwiftUI
import Charts

struct StatsView: View {
    
    let onSettingsTap: () -> Void
    let onBackTap: () -> Void
    let onFilterTap: () -> Void
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(alignment: .leading, spacing: 20) {
                
                HeaderView(
                    tilte: "Stats",
                    leftBarButton: "chevron.left",
                    rightBarButton: "gearshape.fill",
                    onRightTap: {
                        onSettingsTap()
                    },
                    onLeftTap: {
                        onBackTap()
                    })
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        HStack {
                            CotegoryButton(title: "All time", onTap: { onFilterTap() })
                            CotegoryButton(title: "Week", onTap: { onFilterTap() })
                            CotegoryButton(title: "Month", onTap: { onFilterTap() })
                        }
                        .padding()
                    }
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ],
                        spacing: 16
                    ) {
                        StatsCardView(resultCount: "5", category: "Articles read", imageName: "articlesStat")
                        StatsCardView(resultCount: "5", category: "Guides complete", imageName: "guidesStat")
                        StatsCardView(resultCount: "8/10", category: "Test results", imageName: "quizzes")
                        StatsCardView(resultCount: "5", category: "Streak", imageName: "streak")
                    }
                    .padding(.horizontal)
                    Text("Daily activity")
                        .font(.customSen(.semiBold, size: 17))
                        .foregroundStyle(.text)
                        .padding()
                    CustomChartView()
                        .padding(.horizontal)
                    Text("Topics you've studied")
                        .font(.customSen(.semiBold, size: 17))
                        .foregroundStyle(.text)
                        .padding()
                    PandaPieChartView()
                        .padding(.horizontal)
                    
                    Spacer(minLength: 100)
                }
            }
        }
    }
}

#Preview {
    StatsView(onSettingsTap: {}, onBackTap: {}, onFilterTap: {})
}
