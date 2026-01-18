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
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(alignment: .leading, spacing: 20) {
                
                HeaderView(tilte: "Journal", leftBarButton: "chevron.left", rightBarButton: "gearshape.fill")
                
                if !isLoading {
                    EmptyView(title: "Here you will find articles read and quizzes completed.", imageName: "journalEmptyImage", isButtonNeeded: false)
                } else {
                    ScrollView(showsIndicators: false) {
                        SearchBarView(searchText: $searchText, showFilters: $showFilters)
                        VStack(spacing: 20) {
                            HStack {
                                CotegoryButton(title: "All")
                                CotegoryButton(title: "Articles")
                                CotegoryButton(title: "Guides")
                                CotegoryButton(title: "Quizzes")
                            }
                            .padding(.vertical)
                            
                            HStack {
                                Image("calendar")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: 20)
                                Text("01/01/26")
                                    .font(.customSen(.semiBold, size: 16))
                                    .foregroundStyle(.text)
                            }
                            
                            ArticleCard(category: "Article", title: "Panda Conservation Success Story", tag: "Population", type: "Habitat")
                            ArticleCard(category: "Guides", title: "What Do Giant Pandas Eat?", tag: "Diet", type: "Care guides")
                            ArticleCard(category: "Article", title: "Panda Conservation Success Story", tag: "Population", type: "Habitat")
                            ArticleCard(category: "Guides", title: "What Do Giant Pandas Eat?", tag: "Diet", type: "Care guides")
                            ZStack {
                                MainButtonsFillView(title: "Export Data (PDF)")
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
                        .padding(.horizontal)
                        Spacer(minLength: 100)
                    }
                }
            }
        }
    }
}

#Preview {
    JournalView()
}
