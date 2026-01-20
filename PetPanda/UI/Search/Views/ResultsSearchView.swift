//
//  ResultsSearchView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 18.01.2026.
//

import SwiftUI

struct ResultsSearchView: View {
    let articleIds: [String]
    let onArticleTap: (String) -> Void
    let onBackTap: () -> Void
    let onFilterTap: () -> Void
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(alignment: .leading) {
                
                HeaderView(
                    tilte: "Result",
                    leftBarButton: "chevron.left",
                    rightBarButton: "slider.horizontal.3",
                    onRightTap: {
                        onFilterTap()
                    },
                    onLeftTap: {
                        onBackTap()
                    })
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        ArticleCard(
                            category: "Article",
                            title: "Panda Conservation Success Story",
                            tag: "Population",
                            type: "Habitat",
                            isFavorite: false,
                            onTap: {
                                onArticleTap("")
                            })
                        ArticleCard(
                            category: "Guides",
                            title: "What Do Giant Pandas Eat?",
                            tag: "Diet",
                            type: "Care guides",
                            isFavorite: false,
                            onTap: {
                                onArticleTap("")
                            })
                        ArticleCard(
                            category: "Article",
                            title: "Panda Conservation Success Story",
                            tag: "Population",
                            type: "Habitat",
                            isFavorite: false,
                            onTap: {
                                onArticleTap("")
                            })
                        ArticleCard(
                            category: "Guides",
                            title: "What Do Giant Pandas Eat?",
                            tag: "Diet",
                            type: "Care guides",
                            isFavorite: false,
                            onTap: {
                                onArticleTap("")
                            })
                        ArticleCard(
                            category: "Article",
                            title: "Panda Conservation Success Story",
                            tag: "Population",
                            type: "Habitat",
                            isFavorite: false,
                            onTap: {
                                onArticleTap("")
                            })
                        ArticleCard(
                            category: "Guides",
                            title: "What Do Giant Pandas Eat?",
                            tag: "Diet",
                            type: "Care guides",
                            isFavorite: false,
                            onTap: {
                                onArticleTap("")
                            })
                    }
                    Spacer(minLength: 100)
                }
                .padding(.top)
                .padding(.horizontal)
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    ResultsSearchView(articleIds: [""], onArticleTap: {_ in}, onBackTap: {}, onFilterTap: {})
}
