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
                    Text("20%")
                        .font(.customSen(.regular, size: 10))
                        .foregroundStyle(.mainGreen)
                        .padding(4)
                        .padding(.horizontal)
                        .background(
                            RoundedRectangle(cornerRadius: 28)
                                .fill(Material.ultraThinMaterial)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 28)
                                        .fill(Color.mainGreen)
                                    )
                                .opacity(0.5)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 28)
                                .stroke(Color.mainGreen.opacity(0.3), lineWidth: 1)
                        )
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
