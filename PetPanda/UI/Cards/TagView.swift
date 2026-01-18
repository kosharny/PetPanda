//
//  TagView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 18.01.2026.
//

import SwiftUI

struct TagView: View {
    let title: String
    
    var body: some View {
        Text(title)
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
                    .opacity(0.1)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 28)
                    .stroke(Color.mainGreen.opacity(0.3), lineWidth: 1)
            )
    }
}
