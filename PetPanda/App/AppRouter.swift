//
//  AppRouter.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 19.01.2026.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class AppRouter: ObservableObject {
    
    @Published var homePath: [Route] = []
    @Published var favoritesPath: [Route] = []
    @Published var searchPath: [Route] = []
    @Published var journalPath: [Route] = []
    @Published var statsPath: [Route] = []
    @Published var settingsPath: [Route] = []
    
    enum Route: Hashable {
        case settings
        case results(articleIds: [String])
        case article(id: String)
        case about
        case care(id: String)
        case quiz(id: String)
    }
}
