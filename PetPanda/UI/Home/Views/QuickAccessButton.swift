//
//  QuickAccessButton.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 18.01.2026.
//

import SwiftUI

struct QuickAccessButton: View {
    let icon: String
    let title: String
    var body: some View {
        HStack {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 40)
                .offset(x: 2, y: 2)
            Text(title)
                .font(.customSen(.semiBold, size: 15))
                .foregroundStyle(.mainGreen)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.mainGreen)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 60, alignment: .leading)
        .background(.ultraThinMaterial.opacity(0.2))
        .cornerRadius(25)
    }
}
