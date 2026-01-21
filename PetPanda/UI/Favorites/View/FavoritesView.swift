//
//  FavoritesView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 18.01.2026.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject private var vm: FavoritesViewModel
    
    let onBackTap: () -> Void
    let onSettingsTap: () -> Void
    let onItemTap: (FavoriteItem) -> Void
    
    init(
        repository: FavoritesRepository,
        articlesRepo: ArticlesRepository,
        careRepo: CareGuideRepository,
        quizRepo: QuizRepository,
        onBackTap: @escaping () -> Void,
        onSettingsTap: @escaping () -> Void,
        onItemTap: @escaping (FavoriteItem) -> Void
    ) {
        _vm = StateObject(wrappedValue: FavoritesViewModel(repository: repository, articlesRepo: articlesRepo, careRepo: careRepo, quizRepo: quizRepo))
        self.onBackTap = onBackTap
        self.onSettingsTap = onSettingsTap
        self.onItemTap = onItemTap
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(alignment: .leading, spacing: 20) {
                
                HeaderView(
                    tilte: "Favorites",
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
                            CotegoryButton(
                                title: "All",
                                isSelected: vm.selectedFilter == .all,
                                onTap: {vm.selectFilter(.all)
                                })
                            CotegoryButton(
                                title: "Articles",
                                isSelected: vm.selectedFilter == .article,
                                onTap: {vm.selectFilter(.article)
                                })
                            CotegoryButton(
                                title: "Guides",
                                isSelected: vm.selectedFilter == .care,
                                onTap: {vm.selectFilter(.care)
                                })
                            CotegoryButton(
                                title: "Quizzes",
                                isSelected: vm.selectedFilter == .quiz,
                                onTap: {vm.selectFilter(.quiz)
                                })
                        }
                        .padding(.vertical)
                        if vm.isEmpty {
                            EmptyView(title: "Add articles and guides here", imageName: "favoriteEmptyImage", isButtonNeeded: false)
                        } else {
                            VStack(spacing: 20) {
                                ForEach(vm.filteredItems) { item in
                                    ArticleCard(
                                        category: item.type.rawValue.capitalized,
                                        title: item.title,
                                        tag: item.tag,
                                        type: item.subtitle,
                                        isFavorite: true,
                                        progress: item.progress,
                                    ) {
                                        onItemTap(item)
                                    }
                                }
                            }
                        }
                    }
                    Spacer(minLength: 100)
                } 
                .padding(.horizontal)
                .onAppear {
                    vm.load()
                }
            }
        }
    }
}
