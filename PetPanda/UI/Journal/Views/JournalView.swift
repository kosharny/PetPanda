//
//  JournalView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 18.01.2026.
//

import SwiftUI

struct JournalView: View {
    let isLoading = true
    @State private var searchText = ""
    @State private var showFilters = false
    
    
    let onSettingsTap: () -> Void
    let onBackTap: () -> Void
    let onFilterTap: () -> Void
    let onArticleTap: (String) -> Void
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(alignment: .leading, spacing: 20) {
                
                HeaderView(
                    tilte: "Journal",
                    leftBarButton: "chevron.left",
                    rightBarButton: "gearshape.fill",
                    onRightTap: {
                        onSettingsTap()
                    },
                    onLeftTap: {
                        onBackTap()
                    })
                
                
                ScrollView(showsIndicators: false) {
                    SearchBarView(isSearchView: false, searchText: $searchText, showFilters: $showFilters)
                    VStack(spacing: 20) {
                        HStack {
                            CotegoryButton(title: "All", isSelected: false, onTap: { onFilterTap()})
                            CotegoryButton(title: "Articles", isSelected: false, onTap: { onFilterTap()})
                            CotegoryButton(title: "Guides", isSelected: false, onTap: { onFilterTap()})
                            CotegoryButton(title: "Quizzes", isSelected: false, onTap: { onFilterTap()})
                        }
                        .padding(.vertical)
                        if !isLoading {
                            EmptyView(title: "Here you will find articles read and quizzes completed.", imageName: "journalEmptyImage", isButtonNeeded: false)
                        } else {
                            
                            VStack(spacing: 20) {
                                HStack {
                                    Image("calendar")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: 20)
                                    Text("01/01/26")
                                        .font(.customSen(.semiBold, size: 16))
                                        .foregroundStyle(.text)
                                }
                                
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
                                    }
                                )
                                ArticleCard(
                                    category: "Article",
                                    title: "Panda Conservation Success Story",
                                    tag: "Population",
                                    type: "Habitat",
                                    isFavorite: false,
                                    onTap: {
                                        onArticleTap("")
                                    }
                                )
                                ArticleCard(
                                    category: "Guides",
                                    title: "What Do Giant Pandas Eat?",
                                    tag: "Diet",
                                    type: "Care guides",
                                    isFavorite: false,
                                    onTap: {
                                        onArticleTap("")
                                    }
                                )
                                ZStack {
                                    MainButtonsFillView(title: "Export Data (PDF)", onReady: { })
                                    HStack {
                                        Spacer()
                                        Image("lock")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(maxWidth: 20)
                                    }
                                    .padding(.horizontal, 40)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    Spacer(minLength: 100)
                }
            }
        }
    }
}

#Preview {
    JournalView(onSettingsTap: {}, onBackTap: {}, onFilterTap: {}, onArticleTap: {_ in })
}
