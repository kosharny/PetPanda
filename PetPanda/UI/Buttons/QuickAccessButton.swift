//
//  QuickAccessButton.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 18.01.2026.
//

import SwiftUI

struct QuickAccessButton: View {
    @EnvironmentObject var settingsVM: SettingsViewModel
    let icon: String
    let title: String
    let onTap: () -> Void
    
    var body: some View {
        Button {
            onTap()
        } label: {
            HStack {
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 40)
                    .offset(x: 2, y: 2)
                Text(title)
                    .font(.customSen(.semiBold, size: 15, offset: settingsVM.fontSizeOffset))
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
}
