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
                ZStack {
                    Text("Home")
                        .font(.customSen(.semiBold, size: 20))
                        .foregroundStyle(.text)
                              
                    HStack {
                        Spacer()
                        Image(systemName: "gearshape.fill")
                            .frame(maxWidth: 25)
                            .foregroundStyle(.textButton)
                            .padding()
                            .background(
                                Circle()
                                    .fill(Material.ultraThinMaterial)
                                    .opacity(0.2)
                            )
                            .overlay(
                                Circle()
                                    .stroke(Color.textButton.opacity(0.3), lineWidth: 1)
                            )
                    }
                }
                .padding(.horizontal)
                if !isLoading {
                    EmptyView()
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
                        
                        Spacer(minLength: 100) // Место под TabBar
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
