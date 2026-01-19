//
//  HomeView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 18.01.2026.
//

import SwiftUI

struct HomeView: View {
    let isLoading = true
    
    let onSettingsTap: () -> Void
    let onArticleTap: (String) -> Void
    let onCategoryTap: ([String]) -> Void
    let onQuickAccessTap: ([String]) -> Void
    
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
                
                if !isLoading {
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
                        VStack(alignment: .leading) {
                            Text("Recommended")
                                .font(.customSen(.semiBold, size: 16))
                                .foregroundStyle(.mainGreen)
                                .padding(.horizontal)
                            
                            VStack(spacing: 12) {
                                ArticleCard(
                                    category: "Article",
                                    title: "Panda Conservation Success Story",
                                    tag: "Population",
                                    type: "Habitat",
                                    onTap: {
                                        onArticleTap("")
                                    }
                                )
                                ArticleCard(
                                    category: "Guides",
                                    title: "What Do Giant Pandas Eat?",
                                    tag: "Diet",
                                    type: "Care guides",
                                    onTap: {
                                        onArticleTap("")
                                    }
                                )
                            }
                            .padding(.horizontal)
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.top)
                }
            }
        }
    }
}

#Preview {
    HomeView(onSettingsTap: {}, onArticleTap: {_ in }, onCategoryTap: {_ in }, onQuickAccessTap: {_ in })
}
