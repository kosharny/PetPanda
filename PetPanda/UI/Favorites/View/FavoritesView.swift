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
                
                HeaderView(tilte: "Home", leftBarButton: "chevron.left", rightBarButton: "gearshape.fill")
                
                if !isLoading {
                    EmptyView(title: "Add articles and guides here", imageName: "favoriteEmptyImage", isButtonNeeded: false)
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 20) {
                            HStack {
                                CotegoryButton(title: "All")
                                CotegoryButton(title: "Articles")
                                CotegoryButton(title: "Guides")
                                CotegoryButton(title: "Quizzes")
                            }
                            .padding(.vertical)
                            ArticleCard(category: "Article", title: "Panda Conservation Success Story", tag: "Population", type: "Habitat")
                            ArticleCard(category: "Guides", title: "What Do Giant Pandas Eat?", tag: "Diet", type: "Care guides")
                            ArticleCard(category: "Article", title: "Panda Conservation Success Story", tag: "Population", type: "Habitat")
                            ArticleCard(category: "Guides", title: "What Do Giant Pandas Eat?", tag: "Diet", type: "Care guides")
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
}

#Preview {
    FavoritesView()
}
