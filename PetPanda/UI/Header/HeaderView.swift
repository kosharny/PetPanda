//
//  HeaderView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 18.01.2026.
//

import SwiftUI

struct HeaderView: View {
    @EnvironmentObject var settingsVM: SettingsViewModel
    let tilte: String
    let leftBarButton: String?
    let rightBarButton: String?
    let onRightTap: () -> Void
    let onLeftTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ZStack {
                Text(tilte)
                    .font(.customSen(.semiBold, size: 20, offset: settingsVM.fontSizeOffset))
                    .foregroundStyle(.text)
                
                HStack {
                    if (leftBarButton != nil) {
                        Button {
                            onLeftTap()
                        } label: {
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

                        
                }
                    Spacer()
                if (rightBarButton != nil) {
                    Button {
                        onRightTap()
                    } label: {
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
            }
            .padding(.horizontal)
        }
    }
}

