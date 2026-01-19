//
//  RootView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 16.01.2026.
//

import SwiftUI
import CoreData

struct RootView: View {
    
    @StateObject private var appState = AppState()
    let conteiner: NSPersistentContainer
    
    var body: some View {
        ZStack {
            switch appState.state {
            case .splash:
                SplashView()
                
            case .onboarding:
                OnboardingView(
                    onFinish: {
                        appState.finishOnboarding()
                    }
                )
                
            case .main:
                MainTabView()
//                MainTabView(container: conteiner)
            }
        }
        .animation(.easeInOut, value: appState.state)
    }
}

