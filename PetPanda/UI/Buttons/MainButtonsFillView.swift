//
//  MainButtonsView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 18.01.2026.
//

import SwiftUI

struct MainButtonsFillView: View {
    let title: String
    let onReady: () -> Void
    
    var body: some View {
        Button(title) { onReady() }
            .font(.customSen(.medium, size: 18))
            .foregroundStyle(.text)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                RoundedRectangle(cornerRadius: 28)
                    .fill(Material.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 28)
                            .fill(Color.mainGreen)
                        )
                    .opacity(0.2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 28)
                    .stroke(Color.mainGreen.opacity(0.3), lineWidth: 1)
            )
    }
}

