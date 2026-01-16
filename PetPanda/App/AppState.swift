//
//  AppState.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 16.01.2026.
//

import Foundation
import Combine

enum AppLaunchState {
    case splash
    case onboarding
    case main
}

@MainActor
final class AppState: ObservableObject {
    
    @Published var state: AppLaunchState = .splash
    
    private let hasSeenOnboardingKey = "has_seen_onboarding"
    
    init() {
        start()
    }
    
    func start() {
        Task {
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            decideNextStep()
        }
    }
    
    private func decideNextStep() {
        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: hasSeenOnboardingKey)
        state = hasSeenOnboarding ? .main : .onboarding
    }
    
    func finishOnboarding() {
        UserDefaults.standard.set(true, forKey: hasSeenOnboardingKey)
        state = .main
    }
}
