//
//  CustomPurchaseAlert.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 22.01.2026.
//

import SwiftUI

struct CustomPurchaseAlert: View {
    let title: String
    let message: String
    let primaryButtonTitle: String
    let secondaryButtonTitle: String
    let action: () -> Void
    let cancelAction: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture {
                    cancelAction()
                }
            
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    Text(title)
                        .font(.customSen(.bold, size: 20))
                        .foregroundStyle(.text)
                    
                    Text(message)
                        .font(.customSen(.regular, size: 16))
                        .foregroundStyle(.text)
                        .multilineTextAlignment(.center)
                }
                
                HStack(spacing: 16) {
                    MainButtonTransparentView(title: secondaryButtonTitle, onTap: { cancelAction() })
                    
                    MainButtonsFillView(title: primaryButtonTitle, onReady: { action() })
                }
            }
            .padding(30)
            .background(Color.endBg)
            .cornerRadius(28)
            .padding(.horizontal, 30)
        }
        .zIndex(100)
    }
}


