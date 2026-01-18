//
//  CotegoryButton.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 18.01.2026.
//

import SwiftUI

struct CotegoryButton: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.customSen(.semiBold, size: 14))
            .foregroundStyle(.mainGreen)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: 60, alignment: .leading)
            .background(.ultraThinMaterial.opacity(0.2))
            .cornerRadius(20)
    }
}
