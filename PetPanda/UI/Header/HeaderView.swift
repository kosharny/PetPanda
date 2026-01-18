//
//  HeaderView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 18.01.2026.
//

import SwiftUI

struct HeaderView: View {
    let tilte: String
    let leftBarButton: String?
    let rightBarButton: String?
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ZStack {
                Text(tilte)
                    .font(.customSen(.semiBold, size: 20))
                    .foregroundStyle(.text)
                
                HStack {
                    if (leftBarButton != nil) {
                        Image(systemName: leftBarButton ?? "")
                            .frame(maxWidth: 25)
                            .foregroundStyle(.textButton)
                            .padding()
                            .background(
                                Circle()
                                    .fill(Material.ultraThinMaterial)
                                    .opacity(0.2)
                            )
                            .overlay(
                                Circle()
                                    .stroke(Color.textButton.opacity(0.3), lineWidth: 1)
                            )
                }
                    Spacer()
                if (rightBarButton != nil) {
                    Image(systemName: rightBarButton ?? "")
                        .frame(maxWidth: 25)
                        .foregroundStyle(.textButton)
                        .padding()
                        .background(
                            Circle()
                                .fill(Material.ultraThinMaterial)
                                .opacity(0.2)
                        )
                        .overlay(
                            Circle()
                                .stroke(Color.textButton.opacity(0.3), lineWidth: 1)
                        )
                }
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    HeaderView(tilte: "Home", leftBarButton: "chevron.left", rightBarButton: "gearshape.fill")
}
