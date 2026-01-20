//
//  CotegoryButton.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 18.01.2026.
//

import SwiftUI

struct CotegoryButton: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button {
            onTap()
        } label: {
            Text(title)
                .font(.customSen(.semiBold, size: 14))
                .foregroundStyle(isSelected ? .text : .mainGreen)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 60, alignment: .center)
                .background(
                    Capsule()
                        .fill(Material.ultraThinMaterial.opacity(0.2))
                        .overlay(
                            Capsule()
                                .fill(Color.mainGreen.opacity(isSelected ? 0.3 : 0))
                        )
                )
                .overlay(
                    Capsule()
                        .stroke(Color.text.opacity(0.3), lineWidth: 1)
                )
        }
    }
}

