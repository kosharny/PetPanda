//
//  SplashView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 16.01.2026.
//

import SwiftUI

struct SplashView: View {
    
    @State private var isActive = false
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            Image("mainLogo")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 220)
                .scaleEffect(isAnimating ? 1.2 : 1.0)
                .animation(
                    .easeInOut(duration: 1.5)
                    .repeatForever(autoreverses: true),
                    value: isAnimating
                )
        }
        .onAppear {
            isAnimating = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}

#Preview {
    SplashView()
}
