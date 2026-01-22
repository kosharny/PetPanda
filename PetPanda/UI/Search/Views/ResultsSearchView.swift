//
//  ResultsSearchView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 18.01.2026.
//

import SwiftUI

struct ResultsSearchView: View {
    
    @StateObject private var vm: ResultsSearchViewModel
    @State private var showFilters = false
    
    let onArticleTap: (String, String) -> Void
    let onBackTap: () -> Void
    
    init(
        articleIds: [String],
        articlesRepo: ArticlesRepository,
        careRepo: CareGuideRepository,
        quizRepo: QuizRepository,
        favoritesRepo: FavoritesRepository,
        onArticleTap: @escaping (String, String) -> Void,
        onBackTap: @escaping () -> Void
    ) {
        _vm = StateObject(wrappedValue: ResultsSearchViewModel(
            ids: articleIds,
            articlesRepo: articlesRepo,
            careRepo: careRepo,
            quizRepo: quizRepo,
            favoritesRepo: favoritesRepo
        ))
        self.onArticleTap = onArticleTap
        self.onBackTap = onBackTap
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(alignment: .leading) {
                
                HeaderView(
                    tilte: "Result",
                    leftBarButton: "chevron.left",
                    rightBarButton: "slider.horizontal.3",
                    onRightTap: {
                        showFilters = true
                    },
                    onLeftTap: {
                        onBackTap()
                    })
                
                if vm.displayedItems.isEmpty {
                    VStack(alignment: .center) {
                        Spacer()
                        EmptyView(
                            title: "No results match your filters.",
                            imageName: "emptyImage",
                            isButtonNeeded: false
                        )
                        .frame(maxWidth: .infinity)
                        Spacer()
                    }
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 16) {
                            ForEach(vm.displayedItems) { item in
                                ArticleCard(
                                    category: item.categoryType,
                                    title: item.title,
                                    tag: item.tag,
                                    type: item.subTitle,
                                    isFavorite: item.isFavorite,
                                    progress: item.progress,
                                    duration: item.duration,
                                    onTap: {
                                        onArticleTap(item.id, item.categoryType)
                                    }
                                )
                            }
                        }
                        Spacer(minLength: 100)
                    }
                    .padding(.top)
                    .padding(.horizontal)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showFilters) {
                ResultsFilterMenuView(vm: vm, onApply: {
                    showFilters = false
                    vm.applyFilters()
                })
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
            }
        }
    }
}

struct ResultsFilterMenuView: View {
    @ObservedObject var vm: ResultsSearchViewModel
    let onApply: () -> Void
    
    let progressOptions = ["< 20%", "20 - 70%", "70 - 100%"]
    
    var body: some View {
        ZStack {
            Color.endBg.edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 24) {
                
                FilterGroup(title: "By title:") {
                    HStack {
                        CotegoryButton(
                            title: "A - Z",
                            isSelected: vm.sortOrder == .az,
                            onTap: { vm.sortOrder = (vm.sortOrder == .az ? nil : .az) }
                        )
                        CotegoryButton(
                            title: "Z - A",
                            isSelected: vm.sortOrder == .za,
                            onTap: { vm.sortOrder = (vm.sortOrder == .za ? nil : .za) }
                        )
                    }
                }
                
                FilterGroup(title: "Reading Time:") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 10) {
                        ForEach(ReadingTimeType.allCases) { time in
                            CotegoryButton(
                                title: time.rawValue,
                                isSelected: vm.selectedTime == time,
                                onTap: { vm.selectedTime = (vm.selectedTime == time ? nil : time) }
                            )
                        }
                    }
                }
                
                FilterGroup(title: "By progress:") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 10) {
                        ForEach(progressOptions, id: \.self) { option in
                            CotegoryButton(
                                title: option,
                                isSelected: vm.selectedProgress == option,
                                onTap: { vm.selectedProgress = (vm.selectedProgress == option ? nil : option) }
                            )
                        }
                    }
                }
                
                HStack {
                    Toggle("Unread only", isOn: $vm.unreadOnly)
                        .toggleStyle(GlassToggleStyle())
                        .padding(.horizontal, 4)
                }
                
                Spacer()
                
                HStack(spacing: 16) {
                    MainButtonTransparentView(title: "Reset") {
                        withAnimation {
                            vm.resetFilters()
                        }
                    }
                    MainButtonsFillView(title: "Apply") {
                        onApply()
                    }
                }
                .padding(.bottom, 20)
            }
            .padding(24)
        }
    }
}
