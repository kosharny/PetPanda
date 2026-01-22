//
//  StatsView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 18.01.2026.
//

import SwiftUI
import Charts

struct StatsView: View {
    
    @EnvironmentObject var settingsVM: SettingsViewModel
    @StateObject private var vm: StatsViewModel

        let onSettingsTap: () -> Void
        let onBackTap: () -> Void

        init(
            statsRepo: StatsRepository,
            journalRepo: JournalRepository,
            quizRepo: QuizRepository,
            onSettingsTap: @escaping () -> Void,
            onBackTap: @escaping () -> Void
        ) {
            _vm = StateObject(
                wrappedValue: StatsViewModel(
                    statsRepo: statsRepo,
                    journalRepo: journalRepo,
                    quizRepo: quizRepo
                )
            )
            self.onSettingsTap = onSettingsTap
            self.onBackTap = onBackTap
        }
    
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
                            ForEach(StatsFilter.allCases, id: \.self) { filter in
                                CotegoryButton(
                                    title: filter.rawValue,
                                    isSelected: vm.filter == filter,
                                    onTap: { vm.setFilter(filter) }
                                )
                            }
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
                        StatsCardView(resultCount: "\(vm.articlesRead)", category: "Articles read", imageName: "articlesStat")
                        StatsCardView(resultCount: "\(vm.guidesCompleted)", category: "Guides complete", imageName: "guidesStat")
                        StatsCardView(resultCount: "\(vm.quizResultText)", category: "Test results", imageName: "quizzes")
                        StatsCardView(resultCount: "\(vm.streak)", category: "Streak", imageName: "streak")
                    }
                    .padding(.horizontal)
                    Text("Daily activity")
                        .font(.customSen(.semiBold, size: 17, offset: settingsVM.fontSizeOffset))
                        .foregroundStyle(.text)
                        .padding()
                    CustomChartView(data: vm.dailyActivityData)
                        .padding(.horizontal)
                    Text("Topics you've studied")
                        .font(.customSen(.semiBold, size: 17, offset: settingsVM.fontSizeOffset))
                        .foregroundStyle(.text)
                        .padding()
                    PandaPieChartView(data: vm.categoryDistribution)
                        .padding(.horizontal)
                    
                    Spacer(minLength: 100)
                }
            }
        }
        .onAppear {
            vm.reload()
        }
    }
}

