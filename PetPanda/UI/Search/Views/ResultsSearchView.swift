//
//  ResultsSearchView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 18.01.2026.
//

import SwiftUI

struct ResultsSearchView: View {
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(alignment: .leading) {
                
                HeaderView(tilte: "Result", leftBarButton: "chevron.left", rightBarButton: "slider.horizontal.3")
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        ArticleCard(category: "Article", title: "Panda Conservation Success Story", tag: "Population", type: "Habitat")
                        ArticleCard(category: "Guides", title: "What Do Giant Pandas Eat?", tag: "Diet", type: "Care guides")
                        ArticleCard(category: "Article", title: "Panda Conservation Success Story", tag: "Population", type: "Habitat")
                        ArticleCard(category: "Guides", title: "What Do Giant Pandas Eat?", tag: "Diet", type: "Care guides")
                        ArticleCard(category: "Article", title: "Panda Conservation Success Story", tag: "Population", type: "Habitat")
                        ArticleCard(category: "Guides", title: "What Do Giant Pandas Eat?", tag: "Diet", type: "Care guides")
                    }
                    Spacer(minLength: 100)
                }
                .padding(.top)
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    ResultsSearchView()
}
