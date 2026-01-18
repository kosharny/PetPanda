//
//  StatsCardView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 18.01.2026.
//

import SwiftUI

struct StatsCardView: View {
    let resultCount: String
    let category: String
    let imageName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(resultCount)
                .font(.customSen(.semiBold, size: 25))
                .foregroundStyle(.text)
            HStack(spacing: 8) {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                Text(category)
                    .font(.customSen(.regular, size: 13))
                    .foregroundStyle(.text)
                    .lineLimit(1)
            }
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 100)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(Material.ultraThinMaterial.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Color.mainGreen.opacity(0))
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28)
                .stroke(Color.text.opacity(0.1), lineWidth: 1)
        )
    }
}
