//
//  BackgroundView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 16.01.2026.
//

import SwiftUI

struct BackgroundView: View {
    @AppStorage("app_theme") var theme: AppTheme = .classic
    @EnvironmentObject var settings: SettingsViewModel
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: theme.colors,
                startPoint: .bottom,
                endPoint: .top
            )
        }
        .ignoresSafeArea()
        .animation(.easeInOut(duration: 0.5), value: theme)
    }
}

#Preview {
    BackgroundView()
}
