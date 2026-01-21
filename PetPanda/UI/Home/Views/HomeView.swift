//
//  HomeView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 18.01.2026.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var vm: HomeViewModel
    
    let onSettingsTap: () -> Void
    let onArticleTap: (String, ContentType) -> Void
    let onCategoryTap: ([String]) -> Void
    let onQuickAccessTap: ([String]) -> Void
    let onJournalTap: () -> Void
    
    init(
        articlesRepo: ArticlesRepository,
        careRepo: CareGuideRepository,
        quizRepo: QuizRepository,
        importer: ContentImporting,
        favoritesRepo: FavoritesRepository,
        onSettingsTap: @escaping () -> Void,
        onArticleTap: @escaping (String, ContentType) -> Void,
        onCategoryTap: @escaping ([String]) -> Void,
        onQuickAccessTap: @escaping ([String]) -> Void,
        onJournalTap: @escaping () -> Void
    ) {
        self._vm = StateObject(wrappedValue: HomeViewModel(
            articlesRepo: articlesRepo,
            careRepo: careRepo,
            quizRepo: quizRepo,
            importer: importer,
            favoritesRepo: favoritesRepo
        ))
        self.onSettingsTap = onSettingsTap
        self.onArticleTap = onArticleTap
        self.onCategoryTap = onCategoryTap
        self.onQuickAccessTap = onQuickAccessTap
        self.onJournalTap = onJournalTap
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(alignment: .leading, spacing: 20) {
                
                HeaderView(
                    tilte: "Home",
                    leftBarButton: nil,
                    rightBarButton: "gearshape.fill",
                    onRightTap: {
                        onSettingsTap()
                    },
                    onLeftTap: {})
                
                if vm.isLoading {
                    EmptyView(title: "Uh-oh, pandas couldn’t deliver this page :(", imageName: "emptyImage", isButtonNeeded: true)
                } else {
                    ScrollView(showsIndicators: false) {
                        FactCardView()
                            .padding(.vertical)
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            QuickAccessButton(icon: "population", title: "Population", onTap: {
                                onQuickAccessTap(vm.getIds(for: .article))
                            })
                            QuickAccessButton(icon: "guides", title: "Care guides", onTap: {
                                onQuickAccessTap(vm.getIds(for: .care))
                            })
                            QuickAccessButton(icon: "quizzes", title: "Quizzes", onTap: {
                                onQuickAccessTap(vm.getIds(for: .quiz))
                            })
                            QuickAccessButton(icon: "journal", title: "Journal", onTap: {
                                onJournalTap()
                            })
                        }
                        .padding(.horizontal)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack{
                                CotegoryButton(title: "Habitat", isSelected: false, onTap: {
                                    onCategoryTap(vm.getIds(forCategory: "Habitat"))
                                })
                                CotegoryButton(title: "Diet", isSelected: false, onTap: {
                                    onCategoryTap(vm.getIds(forCategory: "Diet"))
                                })
                                CotegoryButton(title: "Behavior", isSelected: false, onTap: {
                                    onCategoryTap(vm.getIds(forCategory: "Behavior"))
                                })
                                CotegoryButton(title: "Fun Facts", isSelected: false, onTap: {
                                    onCategoryTap(vm.getIds(forCategory: "Fun Facts"))
                                })
                                CotegoryButton(title: "Health", isSelected: false, onTap: {
                                    onCategoryTap(vm.getIds(forCategory: "Health"))
                                })
                            }
                        }
                        .padding(.vertical)
                        .padding(.leading)
                        if !vm.recommendations.isEmpty {
                            VStack(alignment: .leading) {
                                Text("Recommended")
                                    .font(.customSen(.semiBold, size: 16))
                                    .foregroundStyle(.mainGreen)
                                    .padding(.horizontal)
                                
                                VStack(spacing: 12) {
                                    ForEach(vm.recommendations) { item in
                                        ArticleCard(
                                            category: item.category,
                                            title: item.title,
                                            tag: item.tag,
                                            type: item.category,
                                            isFavorite: item.isFavorite,
                                            progress: item.progress,
                                            onTap: {
                                                onArticleTap(item.id, item.type)
                                            }
                                        )
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        Spacer(minLength: 100)
                    }
                    .padding(.top)
                }
            }
        }
        .task {
            await vm.loadData()
        }
    }
}

