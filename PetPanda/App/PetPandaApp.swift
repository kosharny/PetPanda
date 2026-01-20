//
//  PetPandaApp.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 16.01.2026.
//

import SwiftUI
import CoreData

@main
struct PetPandaApp: App {
    let container = PersistenceController.shared.container
    
    
    var body: some Scene {
        WindowGroup {
            RootView(container: container)
        }
    }
}
