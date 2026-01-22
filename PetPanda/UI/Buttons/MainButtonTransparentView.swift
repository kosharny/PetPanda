//
//  MainButtonTransparentView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 18.01.2026.
//

import SwiftUI

struct MainButtonTransparentView: View {
    @EnvironmentObject var settingsVM: SettingsViewModel
    let title: String
    let onTap: () -> Void
    
    var body: some View {
        Button(title) { }
            .font(.customSen(.medium, size: 18, offset: settingsVM.fontSizeOffset))
            .foregroundStyle(.text)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                RoundedRectangle(cornerRadius: 28)
                    .fill(Material.ultraThinMaterial)
                    .opacity(0.2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 28)
                    .stroke(Color.textButton.opacity(0.3), lineWidth: 1)
            )
    }
}

#Preview {
    MainButtonTransparentView(title: "Reset", onTap: {})
}
