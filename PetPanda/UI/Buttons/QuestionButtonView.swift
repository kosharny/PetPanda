//
//  QuestionButtonView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 18.01.2026.
//

import SwiftUI

struct QuestionButtonView: View {
    let question: String
    var body: some View {
        Text(question)
            .font(.customSen(.semiBold, size: 15))
            .foregroundStyle(.text)
            .padding(.horizontal)
            .frame(maxWidth: .infinity, minHeight: 60, alignment: .leading)
            .background(
                Capsule()
                    .fill(Material.ultraThinMaterial.opacity(0.2))
                    .overlay(
                        Capsule()
                            .fill(Color.mainGreen.opacity(0))
                    )
            )
            .overlay(
                Capsule()
                    .stroke(Color.text.opacity(0.3), lineWidth: 1)
            )
    }
}
