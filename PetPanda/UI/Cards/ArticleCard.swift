//
//  ArticleCard.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 18.01.2026.
//

import SwiftUI

struct ArticleCard: View {
    let category: String
    let title: String
    let tag: String
    let type: String
    let isFavorite: Bool
    let progress: Double
    let onTap: () -> Void
    
    var body: some View {
        Button {
            onTap()
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(category)
                            .font(.customSen(.regular, size: 12))
                            .foregroundStyle(.text)
                        Text(title)
                            .font(.customSen(.semiBold, size: 14))
                            .foregroundStyle(.text)
                    }
                    Spacer()
                    Image(isFavorite ? "isFavoriteFiil" : "isFavorite")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 20)
                }
                HStack {
                    ProgressTagView(progress: progress)
                    TagView(title: "10 min")
                    TagView(title: tag)
                    TagView(title: type)
                }
                .foregroundColor(.gray)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.ultraThinMaterial.opacity(0.1))
            .cornerRadius(25)
        }
    }
}

struct ProgressTagView: View {
    let progress: Double
    
    var body: some View {
        Text("\(Int(progress * 100))%")
            .font(.customSen(.regular, size: 10))
            .foregroundStyle(progress > 0.5 ? .text : .mainGreen)
            .padding(4)
            .padding(.horizontal, 8)
            .background {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Material.ultraThinMaterial)
                    
                    GeometryReader { geo in
                        RoundedRectangle(cornerRadius: 28)
                            .fill(Color.mainGreen)
                            .frame(width: geo.size.width * progress)
                            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: progress)
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 28))
            .overlay(
                RoundedRectangle(cornerRadius: 28)
                    .stroke(Color.mainGreen.opacity(0.3), lineWidth: 1)
            )
    }
}
