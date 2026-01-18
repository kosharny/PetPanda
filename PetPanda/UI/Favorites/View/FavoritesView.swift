//
//  FavoritesView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 18.01.2026.
//

import SwiftUI

struct FavoritesView: View {
    let isLoading = true
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(alignment: .leading, spacing: 20) {
                
                HeaderView(tilte: "Favorites", leftBarButton: "chevron.left", rightBarButton: "gearshape.fill")
                
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        HStack {
                            CotegoryButton(title: "All")
                            CotegoryButton(title: "Articles")
                            CotegoryButton(title: "Guides")
                            CotegoryButton(title: "Quizzes")
                        }
                        .padding(.vertical)
                        if !isLoading {
                            EmptyView(title: "Add articles and guides here", imageName: "favoriteEmptyImage", isButtonNeeded: false)
                        } else {
                            VStack(spacing: 20) {
                                ArticleCard(category: "Article", title: "Panda Conservation Success Story", tag: "Population", type: "Habitat")
                                ArticleCard(category: "Guides", title: "What Do Giant Pandas Eat?", tag: "Diet", type: "Care guides")
                                ArticleCard(category: "Article", title: "Panda Conservation Success Story", tag: "Population", type: "Habitat")
                                ArticleCard(category: "Guides", title: "What Do Giant Pandas Eat?", tag: "Diet", type: "Care guides")
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
    FavoritesView()
}
