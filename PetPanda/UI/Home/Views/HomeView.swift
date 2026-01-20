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
    
    init(
        articlesRepo: ArticlesRepository,
        careRepo: CareGuideRepository,
        quizRepo: QuizRepository,
        onSettingsTap: @escaping () -> Void,
        onArticleTap: @escaping (String, ContentType) -> Void,
        onCategoryTap: @escaping ([String]) -> Void,
        onQuickAccessTap: @escaping ([String]) -> Void
    ) {
        self._vm = StateObject(wrappedValue: HomeViewModel(
            articlesRepo: articlesRepo,
            careRepo: careRepo,
            quizRepo: quizRepo
        ))
        self.onSettingsTap = onSettingsTap
        self.onArticleTap = onArticleTap
        self.onCategoryTap = onCategoryTap
        self.onQuickAccessTap = onQuickAccessTap
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
                                onQuickAccessTap([""])
                            })
                            QuickAccessButton(icon: "guides", title: "Care guides", onTap: {
                                onQuickAccessTap([""])
                            })
                            QuickAccessButton(icon: "quizzes", title: "Quizzes", onTap: {
                                onQuickAccessTap([""])
                            })
                            QuickAccessButton(icon: "journal", title: "Journal", onTap: {
                                onQuickAccessTap([""])
                            })
                        }
                        .padding(.horizontal)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack{
                                CotegoryButton(title: "Habitat", onTap: {
                                    onCategoryTap([""])
                                })
                                CotegoryButton(title: "Diet", onTap: {
                                    onCategoryTap([""])
                                })
                                CotegoryButton(title: "Behavior", onTap: {
                                    onCategoryTap([""])
                                })
                                CotegoryButton(title: "Fun Facts", onTap: {
                                    onCategoryTap([""])
                                })
                                CotegoryButton(title: "Health", onTap: {
                                    onCategoryTap([""])
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

