//
//  SettingsViewModel.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 22.01.2026.
//

import Foundation
import Combine
import SwiftUI

enum AppTheme: String, CaseIterable {
    case classic = "Classic"
    case bambooNight = "Bamboo Night"
    
    var colors: [Color] {
        switch self {
        case .classic:
            return [.endBg, .endBg]
        case .bambooNight:
            return [.startBg, .endBg]
        }
    }
}

@MainActor
final class SettingsViewModel: ObservableObject {
    @AppStorage("app_theme") var selectedTheme: AppTheme = .classic
    @AppStorage("notifications_enabled") var notificationsEnabled: Bool = false
    @AppStorage("font_size_selection") var fontSizeSelection: Int = 1
    
    var fontSizeOffset: CGFloat {
        switch fontSizeSelection {
        case 0: return -2
        case 2: return 2
        default: return 0 
        }
    }
    
    func setTheme(_ theme: AppTheme) {
        selectedTheme = theme
    }
}
