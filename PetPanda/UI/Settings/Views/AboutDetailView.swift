//
//  AboutDetailView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 22.01.2026.
//

import SwiftUI

struct AboutDetailView: View {
    @EnvironmentObject var settingsVM: SettingsViewModel
    @Environment(\.dismiss) private var dismiss
    
    let title: String
    let content: String
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                HeaderView(
                    tilte: title,
                    leftBarButton: "chevron.left",
                    rightBarButton: nil,
                    onRightTap: {},
                    onLeftTap: { dismiss() }
                )
                
                ScrollView(showsIndicators: false) {
                    Text(content)
                        .font(.customSen(.regular, size: 14, offset: settingsVM.fontSizeOffset))
                        .foregroundStyle(.text)
                        .lineSpacing(6)
                        .multilineTextAlignment(.leading)
                        .padding(24)
                }
            }
        }
        .navigationBarHidden(true)
    }
}
