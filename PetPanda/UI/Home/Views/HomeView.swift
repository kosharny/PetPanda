//
//  HomeView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 18.01.2026.
//

import SwiftUI

struct HomeView: View {
    let isLoading = true
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(alignment: .leading, spacing: 20) {
                
                HeaderView(tilte: "Home", leftBarButton: nil, rightBarButton: "gearshape.fill")
                
                if !isLoading {
                    EmptyView(title: "Uh-oh, pandas couldn’t deliver this page :(", imageName: "emptyImage", isButtonNeeded: true)
                } else {
                    ScrollView(showsIndicators: false) {
                        FactCardView()
                            .padding(.vertical)
                        // Grid Categories
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            QuickAccessButton(icon: "population", title: "Population")
                            QuickAccessButton(icon: "guides", title: "Care guides")
                            QuickAccessButton(icon: "quizzes", title: "Quizzes")
                            QuickAccessButton(icon: "journal", title: "Journal")
                        }
                        .padding(.horizontal)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack{
                                CotegoryButton(title: "Habitat")
                                CotegoryButton(title: "Diet")
                                CotegoryButton(title: "Behavior")
                                CotegoryButton(title: "Fun Facts")
                                CotegoryButton(title: "Health")
                            }
                        }
                        .padding(.vertical)
                        .padding(.leading)
                        // Recommended Section
                        VStack(alignment: .leading) {
                            Text("Recommended")
                                .font(.customSen(.semiBold, size: 16))
                                .foregroundStyle(.mainGreen)
                                .padding(.horizontal)
                            
                            VStack(spacing: 12) {
                                ArticleCard(category: "Article", title: "Panda Conservation Success Story", tag: "Population", type: "Habitat")
                                ArticleCard(category: "Guides", title: "What Do Giant Pandas Eat?", tag: "Diet", type: "Care guides")
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
    HomeView()
}
