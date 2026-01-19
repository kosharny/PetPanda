//
//  FavoritesView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 18.01.2026.
//

import SwiftUI

struct FavoritesView: View {
    let isLoading = true
    let onSettingsTap: () -> Void
    let onBackTap: () -> Void
    let onFilterTap: () -> Void
    let onArticleTap: (String) -> Void
    
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
                            CotegoryButton(title: "All", onTap: {onFilterTap()})
                            CotegoryButton(title: "Articles", onTap: {onFilterTap()})
                            CotegoryButton(title: "Guides", onTap: {onFilterTap()})
                            CotegoryButton(title: "Quizzes", onTap: {onFilterTap()})
                        }
                        .padding(.vertical)
                        if !isLoading {
                            EmptyView(title: "Add articles and guides here", imageName: "favoriteEmptyImage", isButtonNeeded: false)
                        } else {
                            VStack(spacing: 20) {
                                ArticleCard(
                                    category: "Article",
                                    title: "Panda Conservation Success Story",
                                    tag: "Population",
                                    type: "Habitat",
                                    onTap: { onArticleTap("")
                                    })
                                ArticleCard(
                                    category: "Guides",
                                    title: "What Do Giant Pandas Eat?",
                                    tag: "Diet",
                                    type: "Care guides",
                                    onTap: { onArticleTap("")
                                    })
                                ArticleCard(
                                    category: "Article",
                                    title: "Panda Conservation Success Story",
                                    tag: "Population",
                                    type: "Habitat",
                                    onTap: { onArticleTap("")
                                    })
                                ArticleCard(
                                    category: "Guides",
                                    title: "What Do Giant Pandas Eat?",
                                    tag: "Diet",
                                    type: "Care guides",
                                    onTap: { onArticleTap("")
                                    })
                            }
                        }
                    }
                    Spacer(minLength: 100)
                } 
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    FavoritesView(onSettingsTap: {}, onBackTap: {}, onFilterTap: {}, onArticleTap: {_ in })
}
