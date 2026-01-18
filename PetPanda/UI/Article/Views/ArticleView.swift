//
//  ArticleView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 18.01.2026.
//

import SwiftUI

struct ArticleView: View {
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(alignment: .leading, spacing: 20) {
                
                HeaderView(tilte: "Article", leftBarButton: "chevron.left", rightBarButton: "star.fill")
                
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        ZStack(alignment: .bottomLeading) {
                            Image("panda_population_cover")
                                .resizable()
                                .scaledToFit()
                            
                            LinearGradient(
                                colors: [
                                    Color.black.opacity(0.65),
                                    Color.black.opacity(0.2),
                                    Color.clear
                                ],
                                startPoint: .bottom,
                                endPoint: .top
                            )
                            
                            Text("Panda Conservation Success Story")
                                .font(.customSen(.semiBold, size: 15))
                                .foregroundStyle(.text)
                                .padding()
                            
                        }
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("A global conservation success story showing how habitat protection and science helped giant pandas recover.")
                                .font(.customSen(.regular, size: 13))
                                .foregroundStyle(.text)
                            HStack(spacing: 16) {
                                TagView(title: "Population")
                                TagView(title: "Conservation")
                                TagView(title: "Habitat")
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.ultraThinMaterial.opacity(0.1))
                        .cornerRadius(25)
                        .padding(.horizontal)
                        
                        HStack {
                            CotegoryButton(title: "Habitat")
                            CotegoryButton(title: "Diet")
                            CotegoryButton(title: "Behavior")
                        }
                        .padding(.horizontal)
                        
                        Text("Giant pandas were once on the brink of extinction. Today, their recovery is considered one of the most successful conservation efforts in history — a result of habitat protection, scientific programs, and global awareness. Native only to China’s mountain forests, pandas depend almost entirely on bamboo, making their survival directly tied to the health of this ecosystem.")
                            .font(.customSen(.regular, size: 13))
                            .foregroundStyle(.text)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.ultraThinMaterial.opacity(0.1))
                            .cornerRadius(25)
                            .padding(.horizontal)
                        
                        ArticleTextView(
                            title: "How the comeback happened",
                            description: """
                 - Habitat loss was the main threat due to deforestation and land expansion.
                 - China created a national protection strategy focused on rebuilding forests and isolating safe zones.
                 - Protected reserves grew to more than 60, later unified into the Giant Panda National Park.
                 - Scientific breeding and health monitoring programs improved survival rates of newborn cubs.
                 - International cooperation and symbolic adoption programs helped fund protection initiatives.
                 
                 The panda story proves that conservation can work when governments, scientists, and communities act together.
                 """
                        )
                        
                        ArticleTextView(
                            title: "Key facts you should know",
                            description: """
                 - Giant pandas are still classified as vulnerable, not fully safe.
                 - Bamboo forests are essential — protecting pandas means protecting entire ecosystems.
                 - Panda reproduction is slow, so population growth takes decades, not years.
                 - Climate change remains a long-term risk to bamboo availability.
                 - Poaching has decreased dramatically but requires constant monitoring.
                 - Conservation success is ongoing, and public support still matters.
                 """
                        )
                        
                        ArticleTextView(
                            title: "Q&A",
                            description: """
                 Q: Why were pandas endangered? 
                 A: The biggest reason was habitat destruction from deforestation, which reduced bamboo forests — their primary food source.
                 
                 Q: How many pandas are in the wild now? 
                 A: Around 1,800+ giant pandas live in the wild today thanks to conservation and habitat protection.
                 
                 Q: Do breeding programs release pandas into nature? 
                 A: Yes, but only a small percentage. Pandas must learn survival skills first — bamboo foraging, climbing, and self-defense.
                 
                 Q: Why does population grow so slowly? 
                 A: Pandas reproduce rarely. Females are fertile only 2–3 days a year, and usually raise one cub at a time.
                 
                 Q: How does bamboo protection help other species? 
                 A: Bamboo forests support red pandas, golden monkeys, birds, insects, and many rare plant species. Protecting pandas protects them too.
                 """
                        )
                        
                        HStack {
                            MainButtonTransparentView(title: "Share")
                            MainButtonsFillView(title: "Mark as read")
                        }
                        .padding(.horizontal)
                    }
                    Spacer(minLength: 100)
                }
            }
        }
    }
}

struct ArticleTextView: View {
    let title: String
    let description: String
    var body: some View {
        VStack(spacing: 16) {
            Text(title)
                .font(.customSen(.semiBold, size: 14))
                .foregroundStyle(.text)
            Text(description)
                .font(.customSen(.regular, size: 13))
                .foregroundStyle(.text)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial.opacity(0.1))
        .cornerRadius(25)
        .padding(.horizontal)
    }
}

#Preview {
    ArticleView()
}
