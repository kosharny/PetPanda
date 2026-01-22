//
//  FactCardView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 18.01.2026.
//

import SwiftUI

struct FactCardView: View {
    @EnvironmentObject var settingsVM: SettingsViewModel
    let factTitle: String
    let onOpenTap: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Image("pandaFact")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 30)
                        .offset(x: 2, y: 2)
                    Text("Fact of the Day")
                }
                .font(.caption).bold()
                .foregroundStyle(.mainGreen)
                .padding(2)
                .padding(.horizontal)
                .background(
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Material.ultraThinMaterial)
                        .opacity(0.2)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(Color.textButton.opacity(0.3), lineWidth: 1)
                )
                
                Text(factTitle)
                    .font(.customSen(.medium, size: 18, offset: settingsVM.fontSizeOffset))
                    .foregroundStyle(.text)
                MainButtonsFillView(title: "Open", onReady: {
                    onOpenTap()
                })
            }
            Spacer()
            Image("factImage")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 120)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial.opacity(0.2))
        .cornerRadius(25)
        .padding(.horizontal)
    }
}
